# Description
# Use hubot for points poker while doiing estimations
#
#
# Commands :
# hubot estimate <<points>> (or hubot es <<points>>)
#   - stores the points for the user in the storage
# hubot reveal estimates (or hubot res)
#   - reveals all the estimates in the storage
# hubot clear estimates (or hubot ces)
#   - clears all the estimates in the storage
#
# Author : https://github.com/deepakvenkat
#
# Note : You need the estimation-users.json file to indicate the devs and
#        admins

Util = require "util"
fs = require "fs"

estimates = {}

users = JSON.parse fs.readFileSync('estimation-users.json').toString()
devs = users["devs"]
admins = users["admins"]

save = (robot) ->
  robot.brain.data.estimates = estimates

module.exports= (robot) ->

  robot.hear /(estimate|es) (\d+)/i, (msg) ->
    user = msg.message.user.name
    points = msg.match[2]
    if devs.indexOf(user) > -1
      estimates[user] = parseInt(points)
      save(robot)
      msg.send user +  " " + points
    else
      msg.send "User has to be a developer to estimate"


  robot.respond /(reveal estimates|res)/i, (msg) ->
    user = msg.message.user.name
    dev_estimates = robot.brain.data.estimates

    for dev in devs
      if !dev_estimates[dev]
        msg.send dev + " has not estimated yet"
        return

    if admins.indexOf(user) > -1
      msg.send Util.inspect(robot.brain.data.estimates, false, 4)
    else
      msg.send "User has to be an admin to reveal estimates"


  robot.respond /(clear estimates|ces)/i, (msg) ->
    user = msg.message.user.name
    if admins.indexOf(user) > -1
      estimates = {}
      save(robot)
      msg.send "Estimates cleared"
    else
      msg.send "User has to be an admin to clear estimates"


