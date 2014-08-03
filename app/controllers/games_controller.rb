class GamesController < ApplicationController

  # Display an index of all open games
  def index
    @games = Game.all
    @running_games = []
    @open_games = []
    # Only include the open games in the array
    for item in @games
      if item.p2 == nil
        @open_games << item
      else 
        @running_games << item
      end
    end
  end

  # Create a new game
  def new
    game = Game.new
    # Gemerate a random game ID
    game.idhash = SecureRandom.urlsafe_base64(10)
    game.move_number = 1
    if (game.save)
      render plain: "GOOD\n" + game.idhash
    else
      render plain: "ERROR CREATING"
    end
  end

  # Join the game
  def join
    game = Game.find_by(idhash: params[:gamehash])
    if game
      
      # Player 1 joins
      if game.p1 == nil
        logger.debug("Adding player 1")
        game.p1 = SecureRandom.urlsafe_base64(10)
        if (game.save)
          # Tell the player that they will be playing as white, and what their ID is
          render plain: "WHITE\n" + game.p1
        else
          render plain: "ERROR"
        end
      
      # Player 2 joins
      elsif game.p2 == nil
        logger.debug("Adding player 2")
        game.p2 = SecureRandom.urlsafe_base64(10)
        if (game.save)
          # Give Black their ID
          render plain: "BLACK\n" + game.p2
        else
          render plain: "ERROR SAVING"
        end
      
      # Both players have joined
      else
        render plain: "GAME FULL"
      end
    else
      render plain: "NO SUCH GAME"
    end
  end

  def show
    game = Game.find_by(idhash: params[:gamehash])
    if game and game.p2 != nil
      # Show the game log
      movenum = 1
      string = '[Event "%{event}"]
[Site "%{site}"]
[Date "%{date}"]
[Round "%{round}"]
[White "%{white_name}"]
[Black "%{black_name}"]
[Result "%{result}"]
[Mode "ICS"]
1.' % {
        event: "Online Game",
        site: "Online",
        date: game.created_at.to_time.strftime('%Y.%m.%d'),
        round: "0",
        white_name: "White",
        black_name: "Black",
        result: "*" }
# [SetUp "1"]
# [FEN "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"]
      for move in game.moves
        if move.move_number != movenum
          movenum = move.move_number
          string += "\n"+movenum.to_s+"."
        end
        string += " " + move.action
      end
      render plain: string
    elsif game
      render plain: "NOT STARTED"
    else
      render plain: "NO SUCH GAME"
    end
  end

  # Make a move
  def move
    game = Game.find_by(idhash: params[:gamehash])

    # If the player trying to move didn't make the previous move
    if (game.moves.last == nil and params[:playerhash] == game.p1) or
       (game.moves.last != nil and game.moves.last.player != params[:playerhash])
      # Validate the move
      # TODO: Real validation
      validated = params[:move] =~ /([NBRQK]?[a-e]?[1-8]?x?[a-h][1-8](=[NBRQ])?(\+|#)?|O-O(-O)?)/
      if (validated)
        render plain: "GOOD"
        if params[:playerhash] == game.p2
          game.move_number += 1
        end

        # Create a new move, and populate it with data
        move = Move.new
        move.player = params[:playerhash]
        move.action = params[:move]
        move.move_number = game.move_number
        move.game = game
        move.save

        # Add the move the the game
        game.moves << move
        game.save
      else
        # TODO: Add reasons to the response
        render plain: "ILLEGAL MOVE"
      end
    else
      # It's not the player's turn
      render plain: "NOT YOUR TURN"
    end
  end

   # Allow a player to ask what their opponent has recently done
  def ask
    # TODO: Implement
    render plain: "TODO: Implement"
  end
end
