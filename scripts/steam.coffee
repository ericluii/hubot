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
#   :DLM <vanity> - get the data for your last dota match with your <vanity> tag
#
# Author:
#   Harris Yip, ealui
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
  robot.hear /:steamID64 (.*)/i, (msg) ->
    msg.http("http://api.steampowered.com/ISteamUser/ResolveVanityURL/v0001/?key=C7ABEE6B17095BC1F9BC822CFD1C7D08&vanityurl=" + msg.match[1])
      .get() (err, res, body) ->
        response = JSON.parse(body).response
        if response.success == 1
          msg.send SixFourBitID(response.steamid.toString(), msg)
        else
          msg.send response.message
  robot.hear /:DLM (.*)/i, (msg) ->
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
                      printString = printString + "RADIANT WIN - "
                    else
                      printString = printString + "DIRE WIN - "
                    printString = printString + epochToHuman(match.start_time) + "\n"
                    printString = printString +  "RADIANT:\n"
                    direBool = false
                    msg.http("http://api.steampowered.com/IEconDOTA2_570/GetHeroes/v1?key=C7ABEE6B17095BC1F9BC822CFD1C7D08")
                      .get() (err, res, body) ->
                        heroes = JSON.parse(body).result.heroes

                        request_count = 0
                        for player in match.players
                          if player.account_id.toString() != '4294967295'
                            request_count = request_count + 1

                        player_names = {}
                        request_complete_count = 0
                        for player in match.players
                          sf = SixFourBitID(player.account_id.toString(), msg)  
                          if player.account_id.toString() != '4294967295'
                            msg.http("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002?steamids=" + sf + "&key=C7ABEE6B17095BC1F9BC822CFD1C7D08")
                              .get() (err, res, body) ->
                                request_complete_count = request_complete_count + 1
                                players = JSON.parse(body).response.players
                                player_names[players[0].steamid] = players[0].personaname

                                if request_complete_count == request_count
                                  for player in match.players
                                    if player.player_slot > 4 && !direBool
                                      direBool = true
                                      printString = printString + "\nDIRE:\n"
                                    for hero in heroes
                                      if player.hero_id == hero.id
                                        player_name_key = SixFourBitID(player.account_id.toString(), msg)  
                                        printString = printString +  "\t" + player_names[player_name_key] + " - "
                                        heroName = hero.name.replace /npc_dota_hero_/, ""
                                        heroName = heroName.replace /_/, " "
                                        heroName = (heroName.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '
                                        printString = printString + heroName  + " - "
                                        printString = printString + player.kills + "/" + player.deaths + "/" + player.assists + "\n"
                                        break
                                  msg.send printString
                          else
                            player_names[sf] = 'Unknown Player'
              else 
                msg.send result.statusDetail
        else
          msg.send response.message

SixFourBitID = (ThreeTwoBitID, msg) ->
  while ThreeTwoBitID.length < 17
    ThreeTwoBitID = '0' + ThreeTwoBitID
  magic = '76561197960265728'
  newID = ''
  carryOver = 0
  for i in [16..0] by -1
    value = carryOver +  parseInt(ThreeTwoBitID[i]) + parseInt(magic[i])
    mod = value%10
    carryOver = Math.floor(value/10)
    newID = mod + newID
  return newID  

epochToHuman = (epoch) ->
  date = new Date(epoch * 1000)
  return date.toLocaleString() 
