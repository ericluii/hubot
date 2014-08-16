
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
  "http://i.imgur.com/7VFK8RN.gif",
  "http://giant.gfycat.com/NeatLiveDoctorfish.gif",
  "http://giant.gfycat.com/BruisedLividDiscus.gif",
  "http://giant.gfycat.com/OddBountifulAmericanalligator.gif",
  "http://giant.gfycat.com/PastelPhonyFlies.gif",
  "http://giant.gfycat.com/ThirdPitifulKatydid.gif",
  "http://giant.gfycat.com/EuphoricThornyAplomadofalcon.gif",
  "http://giant.gfycat.com/BowedHighGlobefish.gif",
  "http://giant.gfycat.com/BlackSizzlingKagu.gif",
  "http://puu.sh/aTkJ6/9eb9ccc9e6.jpg"
]

module.exports = (robot) ->
  robot.hear /:showmemoves/i, (msg) ->
    msg.send msg.random showmemoves
