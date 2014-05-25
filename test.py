#!/usr/bin/python
import urllib

site = "http://localhost:3000/"

u = urllib.urlopen
game = u(site+"new").read()
game = game.split("\n")[1]
p1 = u(site+game).read()
p1 = p1.split("\n")[0]
p2 = u(site+game).read()
p2 = p2.split("\n")[0]

print "Game:", game
print "Player 1:", p1
print "Player 2:", p2

u(site+game+"/"+p1+"/"+"a2a4")
u(site+game+"/"+p2+"/"+"a8a6")

print
print "Move log:"
print u(site+game).read()