# Description:
#   Returns the URL of the first google hit for a query
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   :(google|g|search) <query> - Googles <query> & returns 1st result's URL
#   :(googlet|gt|searcht) <query> - Googles <query> & returns multiple result URLs
#
# Author:
#   searls

module.exports = (robot) ->
  robot.hear /:(google|g|search) (.*)/i, (msg) ->
    googleMe msg, msg.match[2], (url) ->
      msg.send url

  robot.hear /:(googlet|gt|searcht) (.*)/i, (msg) ->
    googleMulti msg, msg.match[2], (urls) ->
      for url in urls
        msg.send url

googleMe = (msg, query, cb) ->
  msg.http('http://www.google.com/search')
    .query(q: query)
    .get() (err, res, body) ->
      cb body.match(/class="r"><a href="\/url\?q=([^"]*)(&amp;sa.*)">/)?[1] || "Sorry, Google had zero results for '#{query}'"


googleMulti = (msg, query, cb) ->
  msg.http('http://www.google.com/search')
    .query(q: query)
    .headers('User-Agent': 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4')
    .get() (err, res, body) ->
      urls = body.match(/class="r"><a href="\/url\?q=([^"]*)(&amp;sa.*)">/g);
      if urls
        rv = []
        rv.push url.match(/class="r"><a href="\/url\?q=([^"]*)(&amp;sa.*)">/)?[1] for url in urls
        cb rv
      else
        cb ["Sorry, Google had zero results for '#{query}'"]
