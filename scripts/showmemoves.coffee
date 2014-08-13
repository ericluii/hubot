
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
	"http://www.gfycat.com/NeatLiveDoctorfish"
	"http://i.imgur.com/sxvOtNn.jpg"
	"http://gfycat.com/BruisedLividDiscus"
	"http://www.gfycat.com/OddBountifulAmericanalligator"
	"http://i.imgur.com/fkm9aDu.gif"
	"http://www.gfycat.com/PastelPhonyFlies"
	"http://www.gfycat.com/ThirdPitifulKatydid"
	"http://www.gfycat.com/EuphoricThornyAplomadofalcon"
	"http://www.gfycat.com/BowedHighGlobefish"
	"http://i.imgur.com/7VFK8RN.gif"
	"http://www.gfycat.com/BlackSizzlingKagu"
  ]

module.exports = (robot) ->
  robot.hear /:showmemoves/i, (msg) ->
    msg.send msg.random showmemoves