
Thenjs = require 'thenjs'
scriptModel = require './ScriptModel'
spawn = require('child_process').spawn
fs = require 'fs'
path = require 'path'
os = require 'os'

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
      return cont(new Error('Not found.')) if not doc
      cont(null, doc)

exports.editScript = (id, updates)->
  delete updates._id
  Thenjs (cont)->
    scriptModel.update {
      _id: '' + id
    }, {
      $set: updates
    }, (err, count)->
      return cont(err) if err
      cont(null, count)

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
      return cont(new Error('Not found')) if count <= 0
      cont(null, count)


exports.runScript = (id, arg=[])->

  exports
    .findById(id)
    .then (cont, doc)->
      # Get the codes
      codes = doc.codes

      # Make tmp shell file
      tmpDir = os.tmpDir()
      tmpShellFile = path.join(tmpDir, 'shell-' + doc._id + '.sh')
      fs.writeFile tmpShellFile, codes, (err)->
        return cont(err) if err

        shellOutput = ''
        exc = spawn 'sh', [
          tmpShellFile
        ].concat(arg)

        exc.stdout.on 'data', (data)-> shellOutput += data
        exc.stderr.on 'data', (data)-> shellOutput += data
        exc.on 'close', (code)->
          # Remove tmpfile
          fs.unlink tmpShellFile

          return cont({
            code: code
            logs: shellOutput
          }) if code
          cont(null, shellOutput)


