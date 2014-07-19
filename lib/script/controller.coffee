
Thenjs = require 'thenjs'
scriptModel = require './ScriptModel'
logsModel = require '../scriptLogs/logsModel'
spawn = require('child_process').spawn
fs = require 'fs'
path = require 'path'
os = require 'os'

killProcess = (pid)-> spawn 'pkill', [ '-P', pid ]

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

# We cant ensure pid be unique, but for sure we have scriptId when kill the script running
exports.killScript = (scriptId)->

  exports
  .findById(scriptId)

  # Update the script status
  .then (cont, script)->
    # Reset script status
    script.lastRunEnd = new Date()
    script.status = 'ready'
    script.save (err)->
      return cont(err) if err
      cont(null, script)

  # Find the logs record of the pid
  .then (cont, script)->
    logsModel.findById script.lastRunLogs, (err, logs)->
      return cont(err) if err
      return cont('Logs of script ' + script._id + ' does not exist.') if not logs
      cont(null, logs, script)

  # Kill the process of pid
  .then (cont, logs, script)->
    # Kill the process whatever succeed
    killProcess(logs.pid)

    # Update logs record info
    logs.endAt = new Date()
    logs.save()

    # Return whatever logs updates
    cont(null, script, logs)




exports.runScript = (id, arg=[], options={})->

  options.shell = options.shell or 'sh'


  # Create logs model for recording the executation of script
  _createLogsModel = (cont)->
    scriptLogs = new logsModel {
      scriptId: id
    }
    scriptLogs.save (err)->
      return cont(err) if err
      cont(null, scriptLogs)

  # Find script by id, and check its status;
  # if everything is ok, update the status and go on
  _findScriptAndLock = (cont, scriptLogs)->
    scriptModel.findById id, (err, doc)->
      return cont(err) if err
      return cont('Script not found.') if not doc
      return cont('Script isnt ready.') if doc.status isnt 'ready'
      doc.status = 'running'
      doc.lastRunAt = new Date()
      doc.lastRunLogs = scriptLogs._id
      doc.save (err)->
        return cont(err) if err
        cont(null, doc, scriptLogs)

  # Snapshot everything,, for storing everything about the execution
  _createSnapshot = (cont, script, scriptLogs)->
    scriptLogs.snapshot = {}
    scriptLogs.snapshot.title = script.title
    scriptLogs.snapshot.runOptions = options
    scriptLogs.snapshot.args = arg
    scriptLogs.snapshot.codes = script.codes
    scriptLogs.save (err)->
      return cont(err) if err

      cont(null, script, scriptLogs)

  # Write the codes of script to a temporary file, and get ready to run
  _createTmpScriptFile = (cont, script, scriptLogs)->
    # Get the codes
    codes = script.codes

    # Make tmp shell file
    tmpDir = os.tmpDir()
    tmpShellFile = path.join(tmpDir, 'shell-' + script._id + '.sh')
    fs.writeFile tmpShellFile, codes, (err)->
      return cont(err) if err
      cont(null, tmpShellFile, script, scriptLogs)

  # Run the tmp script file and collect the logs
  _runScriptFile = (cont, shellFile, doc, scriptLogs)->
    shellOutput = ''
    exc = spawn options.shell, [
      shellFile
    ].concat(arg), options

    scriptLogs.pid = exc.pid
    receiveOutput = (data)->
      shellOutput += data
      # save to mongodb
      scriptLogs.content = shellOutput
      scriptLogs.endAt = new Date()
      scriptLogs.save() #! Async problem?

    exc.stdout.on 'data', receiveOutput
    exc.stderr.on 'data', receiveOutput
    exc.on 'close', (code)->
      # Remove tmpfile
      fs.unlink shellFile

      return cont(null, {
        code: code
        logs: shellOutput
      }, doc, scriptLogs)

  Thenjs _createLogsModel

  .then _findScriptAndLock

  .then _createSnapshot

  .then _createTmpScriptFile

  # Run script and collect logs
  .then _runScriptFile

  .fin (cont, err1, result, doc, scriptLogs)->
    # Reset script status
    doc.lastRunEnd = new Date()
    doc.status = 'ready'

    scriptLogs.endAt = new Date()

    console.log scriptLogs
    scriptLogs.save (err2)->
      console.log arguments
      doc.save (err3)->
        # Got error when update status after script run
        result.error = [ err1, err2, err3 ]
        cont(null, result, doc)


