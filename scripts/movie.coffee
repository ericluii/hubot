# Description:
#   Search for movies by a search query.
#   Return top box office movies.
#   Will print pictures and link if results are less than 3, otherwise go google it yourself
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
    if (msg.match[1] == '')
      number = 5
    else 
      number = msg.match[1].replace /^\s/, ""

    if number > 50
      msg.send "Only up to 50 allowed! Also, DO NOT FLOOD THE CHAT"
      return
    msg.http("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=" + number + "&country=us&apikey=bapg8jv23rf37dcusgra7znj")
      .get() (err, res, body) ->
        movies = JSON.parse(body).movies
        if (number < 3)
          printMoviePoster(movies,msg)
        else 
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
          printMoviePoster(object.movies, msg)
        else
          printMovie(object.movies, msg)

printMovie = (movies, msg) ->
  movieText = ""
  for movie in movies
    movieText += movie.title + " - " + movie.year + "\n"
    movieText += movie.synopsis + "\n"
    movieText += "Audience Score: " + movie.ratings.audience_score + "\n"
    movieText += "Critic Score: " + movie.ratings.critics_score + "\n"
    movieText += "\n"
  msg.send(movieText)
printMoviePoster = (movies, msg) ->
  movieText = ""
  for movie in movies 
    movieText += movie.title + " - " + movie.year + "\n"
    movieText += movie.posters.thumbnail.replace /_tmb/, "_det"
    movieText += "\n"
    movieText += movie.synopsis + "\n"
    movieText += "Audience Score: " + movie.ratings.audience_score + "\n"
    movieText += "Critic Score: " + movie.ratings.critics_score + "\n"
    movieText += movie.links.alternate + "\n"
    movieText += "\n"
  msg.send(movieText)
