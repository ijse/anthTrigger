
Ctrl = require './controller.coffee'
spawn = require('child_process').spawn
path = require 'path'

exports.route = (app)->

	app.post '/scripts/create', (req, res)->

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

	app.get '/scripts/find/:id', (req, res)->

		scriptId = req.param('id')

		Ctrl
		.findById '' + scriptId #'53c8f792a8848500001488d5'
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
		page = req.param('page')
		page = parseInt(page) or 1

		pageSize = req.param('pageSize')
		pageSize = parseInt(pageSize) or 10

		Ctrl
		.listByPage {}, {
			skip: (page-1)*pageSize
			limit: pageSize
			sort: {
				lastRunAt: -1
			}
		}
		.fin (cont, err, list, total)->

			res.json {
				success: !!!err
				total: total
				list: list or []
			}


	app.post '/scripts/edit/:id', (req, res)->
		sid = '' + req.param('id')
		Ctrl
		.editScript(sid, req.body)
		.then (cb, result)->
			res.json {
				success: true
			}
		.fail (cb, err)->
			res.json {
				success: false
				error: err
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

	app.put '/scripts/run/:id', (req, res)->
		sid = '' + req.param('id')

		Ctrl
		.runScript sid, [], app.get('configs').spawnOptions
		.then (cb, result, doc)->
			res.json {
				success: true,
				error: result.error
				script: doc
				code: result.code
				logs: result.logs
			}
		.fail (cb, err)->
			res.json {
				success: false
				error: err
			}

	app.post '/scripts/kill/:scriptId', (req, res)->
		sid = '' + req.param('scriptId')

		Ctrl
		.killScript sid
		.fin (cb, err, script, logs)->
			res.json {
				success: !!!err
				error: err
				script: script
				logs: logs
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
