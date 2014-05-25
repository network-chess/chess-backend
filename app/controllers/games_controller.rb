class GamesController < ApplicationController
  
  # Display an index of all open games
  def index
    tmp = Game.all
    @games = []
    # Only include the open games in the array
    for item in tmp
      if item.p2 == nil
        @games << item
      end
    end
  end

  # Create a new game
  def new
    game = Game.new
    # Gemerate a random game ID
    game.idhash = SecureRandom.urlsafe_base64(10)
    if (game.save)
      render text: "GOOD\n" + game.idhash
    else
      render text: "ERROR CREATING"
    end
  end

  # Show the game log
  def display(game)
    string = ""
    for move in game.moves
      string += move.action + "\n"
    end
    render text: string
  end

  # Allow a player to ask what their opponent has recently done
  def ask
    # TODO: Implement
    render text: "TODO: Implement"
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
          render text: "WHITE\n" + game.p1
        else
          render text: "ERROR"
        end
      
      # Player 2 joins
      elsif game.p2 == nil
        logger.debug("Adding player 2")
        game.p2 = SecureRandom.urlsafe_base64(10)
        if (game.save)
          # Give Black their ID
          render text: "BLACK\n" + game.p2
        else
          render text: "ERROR SAVING"
        end
      
      # Both players have joined
      else
        render text: "GAME FULL"
      end
    else
      render text: "NO SUCH GAME"
    end
  end

  def show
    game = Game.find_by(idhash: params[:gamehash])
    if game
      # Show the game log
      display game
    else
      render text: "NO SUCH GAME"
    end
  end

  # Make a move
  def move
    game = Game.find_by(idhash: params[:gamehash])

    # If the player trying to move didn't make the previous move
    if (game.moves.last == nil && params[:playerhash] == game.p1) ||
       (game.moves.last != nil && game.moves.last.player != params[:playerhash])
    
      # Create a new move, and populate it with data
      move = Move.new
      move.player = params[:playerhash]
      move.action = params[:move]
      move.game = game
      move.save

      # Add the move the the game
      game.moves << move
      game.save

      # Validate the move
      # TODO: Real validation
      if (true)
        render text: "GOOD"
      else
        # TODO: Add reasons to the response
        render text: "ILLEGAL MOVE"
      end
    else
      # It's not the player's turn
      render text: "NOT YOUR TURN"
    end
  end
end
