Thenjs = require 'thenjs'
util = require '../utils'
moment = require 'moment'

scriptCtrl = require '../script/controller'
scriptLogCtrl = require '../scriptLogs/controller'
eventCtrl = require '../events/controller'
userCtrl = require '../users/controller'

exports.route = (app)->

  app.get '/dashboard/stats', (req, res)->
    Thenjs (cont)->
      scriptCtrl
      .countScripts()
    Thenjs.parallel [
      (cont)-> scriptCtrl.countScripts().fin (c, e, v)-> cont(e, v)
      (cont)-> scriptLogCtrl.count().fin (c, e, v)-> cont(e,v)
      (cont)-> eventCtrl.countEvents().fin (c, e, v)-> cont(e,v)
    ]
    .then (cont, results)->
      res.json {
        success: true
        data: results
      }
    .fail (cont, err)->
      console.log 'err', err
      res.end err

  app.get '/dashboard/recentUser', (req, res, next)->

    userCtrl
    .getRecentUser(8)
    .then (cont, list)->
      res.json list or []
    .fail (cont, err)->
      next(err)


  app.get '/dashboard/recentRun', (req, res, next)->
    scriptLogCtrl
    .getRecentLog(8)
    .then (cont, list)->
      # handle user info
      Thenjs.each list, (cont2, scriptLog, index, array)->

        userCtrl
        .findById scriptLog.runByUser
        .then (cont3, user)->
          # save user info
          sl = {
            _id: scriptLog._id
            startAt: scriptLog.startAt
            snapshot: {
              title: scriptLog.snapshot.title
              user: user.name
            }
          }
          cont2(null, sl)
        .fail (cont3, err)->
          console.log 'err', err
          cont2(null)
      .then (cont2, result)->
        cont(null, result)

    .then (cont, list)->
      res.json list or []
    .fail (cont, err)->
      console.log err
      next(err)


  app.get '/dashboard/usageStats', (req, res, next)->

    scriptLogCtrl
    # find last 30 days
    .getUsageStats moment().subtract(30, 'd')
    .then (cont, results)->
      res.json results
    .fail (cont, err)->
      console.log err


  return
