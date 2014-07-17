
Thenjs = require 'thenjs'
util = require '../utils'
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
  util.usedb('scripts').then (cb, db)->

    key = util.generateId()
    db.set key, {
      title: script.title
      codes: script.codes
      createAt: new Date().getTime()
    }, (err)->
      return cb(err) if err
      script._key = key
      db.compact -> cb(null, script)

exports.editScript = (id, updates)->
  util.usedb('scripts').then (cb, db)->
    db.get id, (err, doc)->
      console.log arguments
      db.compact()

exports.listScript = ()->
  util.usedb('scripts').then (cb, db)->

    list = []
    db.each (doc)-> list.push doc
    cb(null, list)

exports.deleteScript = (key)->
  util.usedb('scripts').then (cb, db)->
    db.remove key, (err)->
      db.compact -> cb(err)
