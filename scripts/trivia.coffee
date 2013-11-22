fs = require 'fs'
module.exports = (robot) ->
  robot.respond /(trivia)(.*)/i, (msg) ->
    category = escape(msg.match[1])
    apiData = JSON.parse fs.readFileSync('mashape.json').toString()
    url = apiData.trivia.url + "v=" + apiData.trivia.v + !!category ?
     "&category=" + category : ""
    msg.http(url)
        .headers( "X-Mashape-Authorization": apiData.trivia.api_key)
        .get() (err, res, body) ->
          msg.send res.statusCode

