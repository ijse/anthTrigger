
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

exports.addScript = (script, uid)->
  Thenjs (cont)->
    sc = new scriptModel(script)
    sc.createByUser = uid
    sc.lastUpdateByUser = uid
    sc.save (err)->
      cont(err, sc)

exports.findById = (id)->
  Thenjs (cont)->
    scriptModel.findById id, (err, doc)->
      return cont(err) if err
      return cont('Not found.') if not doc
      cont(null, doc)

exports.countScripts = ->
  Thenjs (cont)->
    scriptModel.count {}, (err, count)->
      return cont(err) if err
      cont(null, count)

exports.editScript = (id, updates, uid)->
  delete updates._id
  updates.lastUpdateByUser = uid
  Thenjs (cont)->
    scriptModel.update {
      _id: '' + id
    }, {
      $set: updates
    }, (err, count)->
      return cont(err) if err
      updates._id = id
      cont(null, count, updates)

exports.getTags = (q)->
  Thenjs (cont)->
    scriptModel.distinct 'tags', {
          "tags": {
            "$regex": "^" + q
            "$options": "i"
          }
    }, (err, list)->
      return cont(err) if err
      reg = new RegExp('^' + q)
      result = list.filter (v)-> reg.test(v)
      cont(null, result)

exports.listScript = (crital)->

  Thenjs (cont)->
    scriptModel.find crital, (err, docs)->
      return cont(err) if err
      cont(null, docs)

exports.listByPage = (crital, opts)->
  Thenjs (cont)->
    scriptModel
    .find crital, null, opts, (err, list)->
      return cont(err) if err
      cont(null, list)
  .then (cont, list)->
    # Get total count
    scriptModel.count crital, (err, count)->
      return cont(err) if err
      cont(null, list, count)

exports.deleteScript = (id)->

  Thenjs (cont)->
    scriptModel.findById id, (err, script)->
      return cont(err) if err
      cont(null, script)
  .then (cont, script)->
    scriptModel.remove {
      _id: id
    }, (err, count)->
      return cont(err) if err
      return cont(new Error('Not found')) if count <= 0
      cont(null, count, script)

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


exports.callScript = (sid, arg=[], options, env)->

  Thenjs (cont)->

    # find script by id
    scriptModel
    .findOne {
      scriptId: sid
    }, (err, script)->
      return cont(err) if err
      return cont('Not found') if not script
      cont(null, script)
  .then (cont, script)->
    # Generate script file
    tmpDir = os.tmpDir()
    tmpShellFile = path.join(tmpDir, 'shell-' + script._id + '.sh')
    fs.writeFile tmpShellFile, script.codes, (err)->
      return cont(err) if err
      cont(null, tmpShellFile, script)
  .then (cont, shellFile, script)->

    output = ''

    # execute the script
    exc = spawn options.shell, [
      shellFile
    ].concat(arg), env

    exc.stdout.on 'data', (d)-> output += d
    exc.stderr.on 'data', (d)-> output += d
    exc.on 'close', (code)->
      # Remove tmpfile
      fs.unlink shellFile

      return cont(null, code, output, script)



exports.runScript = (id, arg=[], options={}, uid)->

  options.shell = options.shell or 'sh'


  # Create logs model for recording the executation of script
  _createLogsModel = (cont)->
    scriptLogs = new logsModel {
      scriptId: id,
      runByUser: uid
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
      doc.lastRunByUser = uid
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
     '-x'
      shellFile
    ].concat(arg), options

    scriptLogs.pid = exc.pid
    receiveOutput = (data)->
      shellOutput += data
      # save to mongodb
      scriptLogs.content = shellOutput
      # scriptLogs.endAt = new Date()
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

    scriptLogs.save (err2)->
      doc.save (err3)->
        # Got error when update status after script run
        result.error = [ err1, err2, err3 ]
        cont(err1 or err2 or err3, result, doc, scriptLogs)


