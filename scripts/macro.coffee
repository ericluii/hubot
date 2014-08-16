# Description:
#   Allows macros to be added and used to hubot
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   :macro add <macro> <url>
#   :macro delete <macro>
#   :macro list - list all the macros currently implemented
#   :macro url - print http://macros.ealui.com/
#
# Author:
#   ealui, Harris Yip

class Macros
  constructor: (@robot) ->
    @cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.macros
        @cache = @robot.brain.data.macros
  add: (macroString, urlString) ->
    macro = {macro: macroString, url: urlString}
    @cache.push macro
    @robot.brain.data.macros = @cache
    macro
  list: -> @cache
  delete: (macroString) ->
    index = @cache.map((n) -> n.macro).indexOf(macroString)
    macro = @cache.splice(index, 1)[0]
    @robot.brain.data.macros = @cache
    macro
  find: (macroString) ->
    index = @cache.map((n) -> n.macro).indexOf(macroString)
    macro = @cache[index]
    macro

module.exports = (robot) ->
  macros = new Macros robot

  robot.hear /:macro add (.+) (.+)/i, (msg) ->
    macro = macros.add msg.match[1], msg.match[2]
    msg.send "Macro added: #{macro.macro} - #{macro.url}"

  robot.hear /:macro list/i, (msg) ->
    response = ""
    for macro in macros.list()
      response += "#{macro.macro} - #{macro.url}\n"
    msg.send response

  robot.hear /:macro delete (.*)/i, (msg) ->
    macroString = msg.match[1]
    macro = macros.delete macroString
    msg.send "Macro deleted: #{macro.macro} - #{macro.url}"

  robot.hear /:macro url/i, (msg) ->
    msg.send "http://macros.ealui.com"
    
  robot.hear /.*/i, (msg) ->
    macrosList = macros.list()
    for curMacro in macrosList
      message = msg.match[0]
      found = message.match(curMacro.macro)
      if found
        msg.send curMacro.url
        break
