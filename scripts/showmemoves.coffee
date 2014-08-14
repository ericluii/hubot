
# Description:
#   Show Your Moves to the Convo
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   showmemoves - Show Me Your Moves
#
# Author:
#   TerrenceLeung

showmemoves = [
  "http://i.imgur.com/fkm9aDu.gif",
  "http://i.imgur.com/7VFK8RN.gif"
]

module.exports = (robot) ->
  robot.hear /:showmemoves/i, (msg) ->
    msg.send msg.random showmemoves
