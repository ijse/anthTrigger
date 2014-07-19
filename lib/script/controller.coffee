
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
      return cont('Not found.') if not doc
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





exports.runScript = (id, arg=[], options={})->

  options.shell = options.shell or 'sh'

  # Find script by id, and check its status;
  # if everything is ok, update the status and go on
  _findScriptAndLock = (cont)->
    scriptModel.findById id, (err, doc)->
      return cont(err) if err
      return cont('Script not found.') if not doc
      return cont('Script isnt ready.') if doc.status isnt 'ready'
      doc.status = 'running'
      doc.lastRunAt = new Date()
      doc.save (err)->
        return cont(err) if err
        cont(null, doc)

  # Write the codes of script to a temporary file, and get ready to run
  _createTmpScriptFile = (cont, doc)->
    # Get the codes
    codes = doc.codes

    # Make tmp shell file
    tmpDir = os.tmpDir()
    tmpShellFile = path.join(tmpDir, 'shell-' + doc._id + '.sh')
    fs.writeFile tmpShellFile, codes, (err)->
      return cont(err) if err
      cont(null, tmpShellFile, doc)

  # Run the tmp script file and collect the logs
  _runScriptFile = (cont, shellFile, doc)->
    shellOutput = ''
    exc = spawn options.shell, [
      shellFile
    ].concat(arg), options

    exc.stdout.on 'data', (data)-> shellOutput += data
    exc.stderr.on 'data', (data)-> shellOutput += data
    exc.on 'close', (code)->
      # Remove tmpfile
      fs.unlink shellFile

      return cont(null, {
        code: code
        logs: shellOutput
      }, doc)

  Thenjs _findScriptAndLock

  .then _createTmpScriptFile

  # Run script and collect logs
  .then _runScriptFile

  .fin (cont, err, result, doc)->
    # Reset script status
    doc.lastRunEnd = new Date()
    doc.status = 'ready'
    doc.save (err)->
      # Got error when update status after script run
      result.error = err if err
      cont(err, result)


