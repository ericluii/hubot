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
#   :movie <movie> - search for the movie using the Rotten Tomatoes API, return relavent information
#
# Author:
#   Harris Yip
#

module.exports = (robot) ->
  robot.hear /:movie (.*)/i, (msg) ->
    q = encodeURIComponent(msg.match[1])
    link = 'http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=' + q + '&page_limit=5&page=1&apikey=bapg8jv23rf37dcusgra7znj'
    msg.http(link)
      .get() (err, res, body) ->
        object = JSON.parse(body);
        if object.total == 0
          msg.send "No results found"
        else if object.total < 3
          for movie in object.movies 
            msg.send movie.title + " - " + movie.year
            msg.send movie.posters.thumbnail.replace /_tmb/, "_det"
            msg.send movie.synopsis
            msg.send "Audience Score: " + movie.ratings.audience_score 
            msg.send "Critic Score: " + movie.ratings.critics_score 
            msg.send movie.links.alternate
        else
          for movie in object.movies 
            msg.send movie.title + " - " + movie.year
            msg.send movie.synopsis
            msg.send "Audience Score: " + movie.ratings.audience_score 
            msg.send "Critic Score: " + movie.ratings.critics_score 
            msg.send movie.links.alternate
