Thenjs = require 'thenjs'
zipUtil = require './zipUtil'
scriptModel = require '../script/ScriptModel'
scriptLogsModel = require '../scriptLogs/logsModel'
eventLogsModel = require '../events/EventModel'

exports.exportScriptAsZipBuffer = (critial={})->

  Thenjs (cont)->
    scriptModel.find critial, (err, result)-> cont(err, result)
  .then (cont, list)->
    zipBuf = zipUtil.getZipBuffer(list)
    cont(null, zipBuf)
  .fail (cont, err)->
    cont(err)

exports.exportScriptAsZipToDisk = (critial={}, zipFileName)->

  Thenjs (cont)->
    scriptModel.find critial, (err, result)-> cont(err, result)
  .then (cont, list)->

    zipUtil.writeZipFile(list, zipFileName)
    cont(null)
  .fail (cont, err)->
    cont(err)

exports.removeScriptLogs = (days)->
  d = new Date()
  d.setDate d.getDate() - days

  Thenjs (cont)->
    scriptLogsModel.remove {
        startAt: { $lt: d }
      }, (err, result)->
        cont(err, result)

exports.removeEventLogs = (days)->
  d = new Date()
  d.setDate d.getDate() - days

  Thenjs (cont)->
    eventLogsModel.remove {
        timeAt: { $lt: d }
      }, (err, result)->
        console.log ">>", result
        cont(err, result)

