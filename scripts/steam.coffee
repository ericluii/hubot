# Description:
#   Steam related api calls
#
# Dependencies:
#    None
#
# Configuration:
#    None
#
# Commands:
#   :steamID <vanity> - get your steam id from your vanity url (steamcommunity.com/id/<vanity>)
#   :dotaLastMatch <vanity> - get the data for your last dota match with your <vanity> tag
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
  robot.hear /:dotaLastMatch (.*)/i, (msg) ->
    msg.http("http://api.steampowered.com/ISteamUser/ResolveVanityURL/v0001/?key=C7ABEE6B17095BC1F9BC822CFD1C7D08&vanityurl=" + msg.match[1])
      .get() (err, res, body) ->
        response = JSON.parse(body).response
        if response.success == 1
          id = response.steamid
          msg.http("http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1?key=C7ABEE6B17095BC1F9BC822CFD1C7D08&account_id=" + id)
            .get() (err, res, body) ->
              result = JSON.parse(body).result
              if result.status == 1
                match1 = result.matches[0].match_id
                msg.http("http://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/v1?key=C7ABEE6B17095BC1F9BC822CFD1C7D08&match_id=" + match1)
                  .get() (err, res, body) ->
                    match = JSON.parse(body).result
                    printString = ''
                    if match.radiant_win
                      printString = printString + "RADIANT WIN\n"
                    else
                      printString = printString + "DIRE WIN\n"
                    printString = printString +  "RADIANT:\n"
                    direBool = false
                    msg.http("http://api.steampowered.com/IEconDOTA2_570/GetHeroes/v1?key=C7ABEE6B17095BC1F9BC822CFD1C7D08")
                      .get() (err, res, body) ->
                        heroes = JSON.parse(body).result.heroes
                        for player in match.players
                          if player.player_slot > 4 && !direBool
                            direBool = true
                            printString = printString + "\nDIRE:\n"
                          printString = printString +  "\t" + player.account_id + "\n"
                          for hero in heroes
                            if player.hero_id == hero.id
                              heroName = hero.name.replace /npc_dota_hero_/, ""
                              heroName = heroName.replace /_/, " "
                              heroName = (heroName.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '
                              printString = printString + "\t\t" + heroName  + "\n"
                              printString = printString + "\t\t" + player.kills + "/" + player.deaths + "/" + player.assists + "\n"
                              msg.send printString
                              break
              else 
                msg.send result.statusDetail
        else
          msg.send response.message