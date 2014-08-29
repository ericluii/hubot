# Description
#   Gets the weather of the specified city, if not, then waterloo
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   :ww - Shortcut for Weather in waterloo
#   :(w|weather) <city> - Returns the weather for a city
#
# Author:
#   Eric Lui

module.exports = (robot) ->
  robot.hear /:ww/i, (msg) ->
    msg.http("http://api.openweathermap.org/data/2.5/weather?q=waterloo")
       .get() (err, res, body) ->
        if res.statusCode is 200
          data = JSON.parse body
          output = "http://openweathermap.org/img/w/" + data.weather[0].icon + ".png\n"
          output += data.name + ', ' + data.sys.country + '\n'
          output += data.weather[0].description + '\n'
          output += "Temperature: " + Math.round((data.main.temp - 273.15)*100)/100 + " degrees\n"
          output += "High: " + Math.round((data.main.temp_max - 273.15)*100)/100 + " degrees\n"
          output += "Low: " + Math.round((data.main.temp_min - 273.15)*100)/100 + " degrees\n"
          output += "Humidity: " + data.main.humidity + "%\n"
          output += "Wind Speed: " + data.wind.speed + " mps"
          msg.send output
        else
          msg.send "Request Failed to Complete"

  robot.hear /:(w|weather) (.*)/i, (msg) ->
    msg.http("http://api.openweathermap.org/data/2.5/weather?q=" + msg.match[2])
       .get() (err, res, body) ->
        if res.statusCode is 200
          data = JSON.parse body
          output = "http://openweathermap.org/img/w/" + data.weather[0].icon + ".png\n"
          output += data.name + ', ' + data.sys.country + '\n'
          output += data.weather[0].description + '\n'
          output += "Temperature: " + Math.round((data.main.temp - 273.15)*100)/100 + " degrees\n"
          output += "High: " + Math.round((data.main.temp_max - 273.15)*100)/100 + " degrees\n"
          output += "Low: " + Math.round((data.main.temp_min - 273.15)*100)/100 + " degrees\n"
          output += "Humidity: " + data.main.humidity + "%\n"
          output += "Wind Speed: " + data.wind.speed + " mps"
          msg.send output
        else
          msg.send "Request Failed to Complete"
