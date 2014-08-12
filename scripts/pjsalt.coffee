
# Description:
#   Add salt to conversation
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   salt - Get salt
#
# Author:
#   HarrisYip


salt = [
    "http://img33.imageshack.us/img33/4519/pjsalt.jpg",
    "http://whatishealthfood.net/images/health-risks-of-high-sodium-intake_1.jpg",
    "http://sd.keepcalm-o-matic.co.uk/i/keep-calm-and-be-salty.png"
  ]

module.exports = (robot) ->
  robot.hear /:salt/i, (msg) ->
    msg.send msg.random salt
