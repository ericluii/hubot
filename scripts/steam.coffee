# Description:
#	Steam related api calls
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   :steamID <vanity> - get your steam id from your vanity url (steamcommunity.com/id/<vanity>)
#
# Author:
#   Harris Yip
#

module.exports = (robot) ->
	robot.hear /:steamID (.*)/i, (msg) ->
		msg.http("http://api.steampowered.com/ISteamUser/ResolveVanityURL/v0001/?key=C7ABEE6B17095BC1F9BC822CFD1C7D08&vanityurl=" + msg.match[1])
			.get() (err, res, body) ->
				response = JSON.parse(body).response
				if response.success == 1
					msg.send response.steamid
				else
					msg.send response.message