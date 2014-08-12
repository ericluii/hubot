
# Description:
#   No Johns
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   nojohns - No Johns
#
# Author:
#   TerrenceLeung

nojohns = [
	"http://i2.kym-cdn.com/photos/images/newsfeed/000/796/665/439.gif"
  ]

module.exports = (robot) ->
  robot.hear /:nojohns/i, (msg) ->
    msg.send msg.random nojohns
