
Thenjs = require 'thenjs'
scriptModel = require './ScriptModel'
spawn = require('child_process').spawn

exports.runshell = (shellObj, cb)->
  # Execute shell file
  execution = spawn shellObj.cmd, [
    shellObj.file,
    JSON.stringify(shellObj.param)
  ]

  # Collection outputs
  execution.stdout.on 'data', (data)-> shellOutput += data
  execution.stderr.on 'data', (data)-> shellOutput += data
  execution.on 'close', (code)->
    cb?(code, shellOutput)

exports.addScript = (script)->

  Thenjs (cont)->
    sc = new scriptModel(script)
    sc.save (err)->
      cont(err, sc)

exports.findById = (id)->
  Thenjs (cont)->
    scriptModel.findById id, (err, doc)->
      return cont(err) if err
      return cont(new Exception('Not found.')) if not doc
      cont(null, doc)

exports.editScript = (id, updates)->
  delete updates._id
  Thenjs (cont)->
    scriptModel.update {
      id: id
    }, {
      $set: updates
    }, (err, count)->
      return cont(err) if err
      cont(null)

exports.listScript = (crital)->

  Thenjs (cont)->
    scriptModel.find crital, (err, docs)->
      return cont(err) if err
      cont(null, docs)

exports.deleteScript = (key)->

  Thenjs (cont)->
    scriptModel.remove {
      _id: key
    }, (err, count)->
      return cont(err) if err
      return cont(new Exception('Not found')) if count <= 0
      cont(null)

