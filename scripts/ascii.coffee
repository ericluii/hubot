# Description:
#   ASCII art
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   :ascii <text> - Show text in ascii art
#
# Author:
#   atmos

module.exports = (robot) ->
  robot.hear /:ascii (.+)/i, (msg) ->
    msg
      .http("http://asciime.heroku.com/generate_ascii")
      .query(s: msg.match[1].split(' ').join('  '))
      .get() (err, res, body) ->
        msg.send body
