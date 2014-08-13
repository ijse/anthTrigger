moment = require 'moment'
fs = require 'fs'
path = require 'path'
Ctrl = require './controller'
util = require('../utils')


exports.route = (app)->

  app.get '/settings/export_scripts_download', (req, res)->

    Ctrl
    .exportScriptAsZipBuffer()
    .then (cb, zipFileBuf)->
      res.set {
        'Content-Type': 'application/zip; charset=utf8'
        'Content-disposition': 'attachment; filename=' + 'scriptPack.zip'
      }

      res.send(zipFileBuf)

    .fail (cb, err)->
      res.status(500)
      res.json {
        success: false,
        error: err
      }

  app.put '/settings/export_scripts', (req, res)->
    datetime = moment().format('YYYY-MM-DD')
    backupFileName = path.join app.get('configs').backupDir, "scripts_#{datetime}.zip"

    Ctrl
    .exportScriptAsZipToDisk({}, backupFileName)
    .then (cb)->
      res.json {
        success: true,
        file: backupFileName
      }

    .fail (cb, err)->
      res.status(500)
      res.json {
        success: false,
        erorr: err
      }

  app.put '/settings/clear_scriptLogs', (req, res)->

    days = req.body.days

    Ctrl
    .removeScriptLogs(days)
    .then (cb, result)->
      res.json {
        success: true,
        count: result
      }
    .fail (cb, err)->
      res.status(500)
      res.json {
        success: false
      }

  app.put '/settings/clear_eventLogs', (req, res)->

    days = req.body.days

    Ctrl
    .removeEventLogs(days)
    .then (cb, result)->
      res.json {
        success: true,
        count: result
      }
    .fail (cb, err)->
      res.status(500)
      res.json {
        success: false
      }


  app.put '/settings/dump_database', (req, res)->

    slot = moment().format('YYYY-MM-DD')
    config = app.get('configs')

    dbaddr = util.convertMongoUrl(config.mongodb)
    fileName = path.join config.backupDir, "db_#{slot}.bson"

    Ctrl
    .dumpDatabase(dbaddr, fileName)
    .then (cb, stdout, stderr)->
      res.json { success: true, file: fileName }
    .fail (cb, err)->
      res.status(500)
      res.json { success: false }

  app.put '/settings/restore_database', (req, res)->
    restoreFile = req.body.file
    config = app.get('configs')
    dbaddr = util.convertMongoUrl(config.mongodb)
    fileName = path.join config.backupDir, restoreFile

    Ctrl
    .restoreDatabase(dbaddr, fileName)
    .then (cb, stdout, stderr)->
      res.json { success: true, file: fileName }
    .fail (cb, err)->
      res.status(500)
      res.json { success: false }

  app.get '/settings/database_bak/list', (req, res)->

    config = app.get('configs')
    fs.readdir config.backupDir, (err, files)->
      list = []
      # console.log files
      for file in files
        continue if not /^db_.*\.bson$/.test(file)
        sta = fs.statSync path.join(config.backupDir, file)
        list.push {
          name: file
          date: sta.ctime
        }

      res.json {
        list: list
      }
