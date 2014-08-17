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
#   :movieBoxOffice - return the top 5 movies in the box office 
#   :movieBoxOffice <number>- return the top <number> movies in the box office (capped at 50, DON'T FLOOD THE CHAT)
#
# Author:
#   Harris Yip
#

module.exports = (robot) ->
  robot.hear /:movieBoxOffice(\s?(\d*))/i, (msg) ->
    number = (msg.match[1] || 5)
    if number > 50
      msg.send "Only up to 50 allowed! Also, DO NOT FLOOD THE CHAT"
      return
    msg.http("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=" + number + "&country=us&apikey=bapg8jv23rf37dcusgra7znj")
      .get() (err, res, body) ->
        movies = JSON.parse(body).movies
        printMovie(movies, msg)
  robot.hear /:movie (.*)/i, (msg) ->
    q = encodeURIComponent(msg.match[1])
    link = 'http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=' + q + '&page_limit=5&page=1&apikey=bapg8jv23rf37dcusgra7znj'
    msg.http(link)
      .get() (err, res, body) ->
        object = JSON.parse(body)
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
            msg.send "\n"
        else
          printMovie(object.movies, msg)

printMovie = (movies, msg) ->
  for movie in movies
    msg.send movie.title + " - " + movie.year
    msg.send movie.synopsis
    msg.send "Audience Score: " + movie.ratings.audience_score 
    msg.send "Critic Score: " + movie.ratings.critics_score 
    msg.send "\n"

