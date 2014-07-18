
spawn = require('child_process').spawn
path = require 'path'

exports.attach = (app)->

	app.get '/ping', (req, res)-> res.send('pong!')

####### User
	rUser = require './users'
	app.post '/login', (req, res)->
		rUser
		.login req.body.username, req.body.password
		.fin (cont, err, user)->

			return res.json {
				success: false
			} if err
			# write to session
			req.session.user = user
			res.cookie 'user', user.name

			delete user.password
			res.json {
				success: true
				user: user
			}


####### Shell
	rShell = require './shell'

	app.post '/scripts/create', (req, res)->

		console.log(req.body)

		rShell
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

		rShell
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

		rShell
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
