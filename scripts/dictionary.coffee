# Description:
#   Get definitions of words from 
#
# Commands:
#   :define|def <query> - Searches for the definition of query through google.
module.exports = (robot) ->
  robot.hear /:(define|def)( me)? (.*)/i, (msg) ->
    query = msg.match[3]
    robot.http("http://api.wordnik.com:80/v4/word.json/" + query + "/definitions?limit=1&includeRelated=false&sourceDictionaries=all&useCanonical=false&includeTags=false&api_key=a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5")
      .get() (err, res, body) ->
        def = JSON.parse(body)
        if def[0]
          def = def[0]["text"]
        else
          msg.send "No definitions for \"#{query}\""
          return

        unless def?
          msg.send "No definitions for \"#{query}\""
          return

        msg.send def

