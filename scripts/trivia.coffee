fs = require 'fs'
module.exports = (robot) ->
  robot.respond /(trivia)(.*)/i, (msg) ->
    category = escape(msg.match[1])
    apiData = JSON.parse fs.readFileSync('mashape.json').toString()
    url = apiData.quizmaster.url + "question"
    user = apidata.quizmaster.username
    pwd = apidata.quizmaster.password
    auth = 'Basic' + new Buffer(user + ':' + password).toString('base64')
     "&category=" + category : ""
    msg.http(url)
        .headers(Authorization: auth, Accept: 'application/json')
        .get() (err, res, body) ->
          msg.send res.statusCode

