#!/usr/bin/python
import urllib, sys

site = "http://localhost:3000/"

def newgame():
  # None on failure, ID on success
  response = urllib.urlopen(site+"new").read()
  if response == "ERROR CREATING":
    return None
  else:
    # Strip off "GOOD"
    return response.split("\n")[1]

def join(game):
  # None on failure, ID on success
  response = urllib.urlopen(site+game+"/join").read()
  response = response.split("\n")
  if response[0] == "WHITE" or response[0] == "BLACK":
    return response[1]
  else:
    return None

#TODO: Warn if not the player's turn
def make_move(player, move):
  # True on move success, False on move failure
  response = urllib.urlopen(site+game+"/"+player+"/"+move).read()
  if response == "GOOD":
    return True
  else:
    return False

def get(game):
  # None if game isn't ready to be listed, a transcript if it is
  response = urllib.urlopen(site+game).read()
  if response == "NO SUCH GAME": # TODO: Add more error conditions
    return None
  else:
    return response

def new_move(player):
  # Return False if there's no new move, and the move if there is one
  response = urllib.urlopen(site+game+"/"+player)
  if response == "NO NEW MOVE":
    return False
  else:
    return response.split("\n")[1]


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