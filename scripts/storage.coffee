# Description:
#   Inspect the data in redis easily
#
# Commands:
#   :showusers - Display all users that hubot knows about
#   :showstorage - Display the contents that are persisted in the brain


Util = require "util"

module.exports = (robot) ->
  robot.hear /:showstorage$/i, (msg) ->
    output = Util.inspect(robot.brain.data, false, 4)
    msg.send output

  robot.hear /:showusers$/i, (msg) ->
    response = ""

    for own key, user of robot.brain.data.users
      response += "#{user.id} #{user.name}"
      response += " <#{user.email_address}>" if user.email_address
      response += "\n"

    msg.send response

