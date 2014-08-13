moment = require 'moment'
path = require 'path'
Ctrl = require './controller'

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
      res.json {
        success: false,
        erorr: err
      }
