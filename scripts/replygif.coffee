# Description:
#   Makes ReplyGif easier to use. See http://replygif.net.
#
# Dependencies:
#   "cheerio": ">= 0.9.2"
#
# Configuration:
#   None
#
# Commands:
#   :replygif <keyword> - Embeds random ReplyGif with the keyword.
#
# Notes:
#   None
#
# Author:
#   sumeetjain, meatballhat

cheerio = require 'cheerio'

module.exports = (robot) ->
  # Listen for someone to link to a ReplyGif and reply with the image.
  robot.hear /.*replygif\.net\/(i\/)?(\d+).*/i, (msg) ->
    id = msg.match[2]
    msg.send "http://replygif.net/i/#{id}#.gif"

  # Listen for a command to look up a ReplyGif by ID.
  robot.hear /:replygif( me)? (\d+)/i, (msg) ->
    id = msg.match[2]
    msg.send "http://replygif.net/i/#{id}#.gif"

  # Listen for a command to look up a ReplyGif by tag.
  robot.hear /:replygif( me)? (\D+)/i, (msg) ->
    replyGifByTag(msg, msg.match[2])

replyGifByTag = (msg, tag) ->
  msg
    .http("http://replygif.net/t/#{tagify(tag)}")
    .header('User-Agent: ReplyGIF for Hubot (+https://github.com/github/hubot-scripts)')
    .get() (err, res, body) ->
      if not err and res.statusCode is 200
        msg.send msg.random getGifs(body)
      else
        msg.send 'No GIF for you, human.'

getGifs = (body) ->
  $ = cheerio.load(body)
  $('img.gif[src]').map (i, elem) ->
    elem.attribs.src.replace(/thumbnail/, 'i')

tagify = (s) ->
  s.toLowerCase().replace(/\s+/g, '-').replace(/[^-a-z]/g, '')
