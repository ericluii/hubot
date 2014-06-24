# Description:
#   Listens for "good" but with 3 or more "o"s
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commnads:
#
# Author:
#   tbwIII

darths = [
  "http://www.vamortgagecenter.com/blog/wp-content/uploads/2011/07/sidious.jpg",
  "http://torwars.com/wp-content/uploads/2011/10/darth-sidious.jpg"
]

module.exports = (robot) ->
  robot.hear /gooo+d/i, (msg) ->
    msg.send msg.random darths
