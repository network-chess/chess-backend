# Show the game log
def render_game(game)
  string = ""
  for move in game.moves
    string += move.action + "\n"
  end
  render text: string
end