
express = require 'express'
session = require 'express-session'
bodyParser = require 'body-parser'
logger = require 'morgan'

spawn = require('child_process').spawn
path = require 'path'
module.exports = (configs)->

	app = express()
	app.use logger('dev')

	# session support
	app.use session({
	  resave: false, # don't save session if unmodified
	  saveUninitialized: false, # don't create session until something stored
	  secret: 'AnthTrigger session secret'
	})

	app.use(bodyParser())
	app.use express.static(__dirname + '/../public')

	app.get '/ping', (req, res)-> res.send('pong!')
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

	return app
