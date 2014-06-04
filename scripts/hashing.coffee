# Description:
#   Various hashing algorithms.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   :md5|sha|sha1|sha256|sha512|rmd160 <string> - Generate hash of <string>
#
# Author:
#   jimeh

crypto = require 'crypto'

module.exports = (robot) ->
  robot.hear /:md5 (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'md5')

  robot.hear /:SHA (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'sha')

  robot.hear /:SHA1 (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'sha1')

  robot.hear /:SHA256 (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'sha256')

  robot.hear /:SHA512 (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'sha512')

  robot.hear /:RMD160 (.*)/i, (msg) ->
    msg.send hexDigest(msg.match[2], 'rmd160')

# hex digest helper
hexDigest = (str, algo) ->
  crypto.createHash(algo).update(str, 'utf8').digest('hex')
