Thenjs = require 'thenjs'
zipUtil = require './zipUtil'
scriptModel = require '../script/ScriptModel'

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
