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
          msg.send "http://openweathermap.org/img/w/" + data.weather[0].icon + ".png"
          msg.send data.name + ', ' + data.sys.country
          msg.send data.weather[0].description
          msg.send "Temperature: " + Math.round((data.main.temp - 273.15)*100)/100 + " degrees"
          msg.send "High: " + Math.round((data.main.temp_max - 273.15)*100)/100 + " degrees"
          msg.send "Low: " + Math.round((data.main.temp_min - 273.15)*100)/100 + " degrees"
          msg.send "Humidity: " + data.main.humidity + "%"
          msg.send "Wind Speed: " + data.wind.speed + " mps"
        else
          msg.send "Request Failed to Complete"

  robot.hear /:(w|weather) (.*)/i, (msg) ->
    msg.http("http://api.openweathermap.org/data/2.5/weather?q=" + msg.match[2])
       .get() (err, res, body) ->
        if res.statusCode is 200
          data = JSON.parse body
          msg.send "http://openweathermap.org/img/w/" + data.weather[0].icon + ".png"
          msg.send data.name + ', ' + data.sys.country
          msg.send data.weather[0].description
          msg.send "Temperature: " + Math.round((data.main.temp - 273.15)*100)/100 + " degrees"
          msg.send "High: " + Math.round((data.main.temp_max - 273.15)*100)/100 + " degrees"
          msg.send "Low: " + Math.round((data.main.temp_min - 273.15)*100)/100 + " degrees"
          msg.send "Humidity: " + data.main.humidity + "%"
          msg.send "Wind Speed: " + data.wind.speed + " mps"
        else
          msg.send "Request Failed to Complete"
