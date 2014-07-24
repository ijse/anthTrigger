Thenjs = require 'thenjs'

scriptCtrl = require '../script/controller'
scriptLogCtrl = require '../scriptLogs/controller'
eventCtrl = require '../events/controller'

exports.route = (app)->

  app.get '/dashboard/stats', (req, res)->
    console.log "start count..."
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