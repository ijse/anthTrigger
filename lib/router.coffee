
spawn = require('child_process').spawn
path = require 'path'

exports.attach = (app)->

	app.get '/ping', (req, res)-> res.send('pong!')

	# Static pages
	# app.get '/page/*', (req, res)->
	# 	res.sendfile(path.join(__dirname, '/../public/', req.url))

	rUser = require './users'
	app.post '/login', rUser.login

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
			res.end shellOutput