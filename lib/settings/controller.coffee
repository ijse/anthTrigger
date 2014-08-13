Thenjs = require 'thenjs'
zipUtil = require './zipUtil'
scriptModel = require '../script/ScriptModel'
scriptLogsModel = require '../scriptLogs/logsModel'
eventLogsModel = require '../events/EventModel'
exec = require('child_process').exec

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

exports.dumpDatabase = (slot, dbaddr, bkDir)->

  Thenjs (cont)->

    cmd = [
      'mongodump'
      '--host', dbaddr.hostname
      '--port', dbaddr.port
      '-d', dbaddr.dbname
    ]
    cmd.push('-u', dbaddr.username) if dbaddr.username
    cmd.push('-p', dbaddr.password) if dbaddr.password

    cmd.push('-o', bkDir)

    cmdStr = cmd.join(' ')

    exec cmdStr, (error, stdout, stderr)->
      console.error error, stderr if error
      cont(error, stdout, stderr)

    return
