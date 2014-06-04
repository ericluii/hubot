# Description:
#   Kittens!
#
# Dependencies:
#   None
#
# Configuration:
#   None
# 
# Commands:
#   :kitten - A randomly selected kitten
#   :kitten <w>x<h> - A kitten of the given size
#   :kitten bomb <number> - Many many kittens!
#
# Author:
#   dstrelau

module.exports = (robot) ->
  robot.hear /:kitten/i, (msg) ->
    msg.send kittenMe()

  robot.hear /:kitten (\d+)(?:[x ](\d+))?$/i, (msg) ->
    msg.send kittenMe msg.match[1], (msg.match[2] || msg.match[1])

  robot.hear /:kitten bomb (\d+)?$/i, (msg) ->
    kittens = msg.match[1] || 5
    msg.send(kittenMe()) for i in [1..kittens]

kittenMe = (height, width)->
  h = height ||  Math.floor(Math.random()*250) + 250
  w = width  || Math.floor(Math.random()*250) + 250
  root = "http://placekitten.com"
  root += "/g" if Math.random() > 0.5 # greyscale kittens!
  return "#{root}/#{h}/#{w}#.png"
