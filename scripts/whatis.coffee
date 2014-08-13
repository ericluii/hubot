# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   :whatis <term> - search the term on urbandictionary.com and get a random popular definition for the term.
#
# Author:
#   Harris Yip
#
# FIXME merge with urban.coffee

module.exports = (robot) ->
  robot.hear /:whatis (.*)/i, (msg) ->
    urbanMe msg, msg.match[1], (entries) ->
      msg.send entry for entry in entries

urbanMe = (msg, query, cb) ->
  msg.http('http://api.urbandictionary.com/v0/define?term=' + query)
    .get() (err, res, body) ->
      object = JSON.parse(body)
      if object.list.length > 0 
      	rv = []
      	rv.push entry.definition for entry in object.list
      	cb rv
      else 
      	cb ["No results found"]