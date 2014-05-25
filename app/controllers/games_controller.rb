class GamesController < ApplicationController
  def index
    tmp = Game.all
    @games = []
    for item in tmp
      if item.p2 == nil
        @games << item
      end
    end
  end

  def new
    game = Game.new
    game.idhash = SecureRandom.urlsafe_base64(10)
    if (game.save)
      render text: "SUCCEED\n" + game.idhash
    else
      render text: "FAIL"
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

  # Join the game
  def join
    game = Game.find_by(idhash: params[:gamehash])
    if game
      
      # Player 1 joins
      if game.p1 == nil
        logger.debug("Adding player 1")
        game.p1 = SecureRandom.urlsafe_base64(10)
        if (game.save)
          render text: game.p1 + "\nWHITE"
        else
          render text: "ERROR SAVING"
        end
      
      # Player 2 joins
      elsif game.p2 == nil
        logger.debug("Adding player 2")
        game.p2 = SecureRandom.urlsafe_base64(10)
        if (game.save)
          render text: game.p2 + "\nBLACK"
        else
          render text: "ERROR SAVING"
        end
      
      # Both players have joined, show the game log
      else
        display(game)
      end
    else
      render text: "NO SUCH GAME"
    end
  end

  # Make a move
  def move
    game = Game.find_by(idhash: params[:gamehash])
    # If the player trying to move HASN'T made the previous move
    shouldplay = false
    if (game.moves.last == nil && params[:playerhash] == game.p1) ||
       (game.moves.last != nil && game.moves.last.player != params[:playerhash])
      move = Move.new
      move.player = params[:playerhash]
      move.action = params[:move]
      move.save

      game.moves << move
      game.save
      render text: "GOOD"
    else
      render text: "NOT YOUR TURN"
    end
  end
end
