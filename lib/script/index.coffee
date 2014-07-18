
Ctrl = require './controller.coffee'
spawn = require('child_process').spawn
path = require 'path'

exports.route = (app)->

	app.post '/scripts/create', (req, res)->

		console.log(req.body)

		Ctrl
		.addScript(req.body)
		.then (cb, script)->
			res.json {
				success: true
				script: script
			}
		.fail (cb, err)->
			res.json {
				success: false
				error: err
			}

	app.get '/scripts/list', (req, res)->

		Ctrl
		.listScript()
		.then (cb, list)->
			res.json {
				success: true
				list: list.reverse()
			}
		.fail (cb, err)->
			res.json {
				success: false
				error: err
				list: []
			}

	app.delete '/scripts/delete/:key', (req, res)->
		key = req.param('key')

		Ctrl
		.deleteScript(key)
		.then (cb, result)->
			res.json {
				success: true
			}
		.fail (cb, err)->
			res.json {
				success: false
				error: err
			}


	app.post '/hook', (req, res)->
		shellOutput = ''
		projectName = req.body.repository.name
		projectConfig = configs.projects[projectName]

		# Missing project configs
		if not projectConfig
		  res.send 404, 'Project not configured.'
		  return
		  shellFile = path.join(configs.shellDir, projectConfig.shell)


		  # Execute shell file
		  execution = spawn projectConfig.cmd, [
		    shellFile,
		    JSON.stringify(req.body)
		  ]

		  # Collection outputs
		  execution.stdout.on 'data', (data)-> shellOutput += data
		  execution.stderr.on 'data', (data)-> shellOutput += data
		  execution.on 'close', (code)->
		    return res.send(500, shellOutput) if code isnt 0
