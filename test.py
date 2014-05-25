#!/usr/bin/python
import urllib, sys

class Player:
  def __init__(self, game, pid):
    self.game = game
    self.pid = pid

  #TODO: Warn if not the player's turn, other errors
  def make_move(self, move):
    # True on move success, False on move failure
    response = urllib.urlopen(self.game.site+self.game.gid+"/"+self.pid+"/"+move).read()
    if response == "GOOD":
      return True
    else:
      return False

  def poll(self):
    # Return False if there's no new move, and the move if there is one
    response = urllib.urlopen(self.game.site+self.game.gid+"/"+self.pid)
    if response == "NO NEW MOVE":
      return False
    else:
      return response.split("\n")[1]

class Game:
  def __init__(self, site="http://localhost:3000/",game_name = ""):
    self.site=site
    if game_name == "":
      response = urllib.urlopen(site+"new").read()
      if response == "ERROR CREATING":
        self.gid = None
      else: # Strip off "GOOD"
        self.gid = response.split("\n")[1]
    else:
      self.gid = game_name

  def join(self):
    response = urllib.urlopen(self.site+self.gid+"/join").read()
    response = response.split("\n")
    if response[0] == "WHITE" or response[0] == "BLACK":
      return Player(self, response[1])
    else:
      return None

  def get(self):
    # None if game isn't ready to be listed, a transcript if it is
    response = urllib.urlopen(self.site+self.gid).read()
    if response == "NO SUCH GAME": # TODO: Add more error conditions
      return None
    else:
      return response

# Testing purposes
if __name__ == "__main__":
  game = newgame()
  if game == None:
    sys.exit()
  p1 = join(game)
  if p1 == None:
    sys.exit()
  p2 = join(game)
  if p2 == None:
    sys.exit()

  print "Game:", game
  print "Player 1:", p1
  print "Player 2:", p2

  make_move(p1, "a2a4")
  make_move(p2, "a7a5")

  print
  print "Move log:"
  print get(game)