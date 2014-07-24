
Ctrl = require './controller.coffee'
spawn = require('child_process').spawn
path = require 'path'

exports.route = (app)->

	app.post '/scripts/create', (req, res)->
		Ctrl
		.addScript(req.body, req.cookies.uid)
		.fin (cb, err, script)->
			res.json {
				success: !!!err
				script: script,
				error: err
			}
			_evt.script_add req.cookies.user, !!!err, script

	app.get '/scripts/find/:id', (req, res)->

		scriptId = req.param('id')

		Ctrl
		.findById '' + scriptId
		.fin (cb, err, script)->
			res.json {
				success: !!!err
				error: err
				script: script
			}

	app.get '/scripts/tags', (req, res)->
		q = req.param('q')

		Ctrl
		.getTags q
		.fin (cb, err, list)->
			res.json list

	app.get '/scripts/list', (req, res)->
		page = req.param('page')
		page = parseInt(page) or 1

		pageSize = req.param('pageSize')
		pageSize = parseInt(pageSize) or 10

		q = req.param('q')

		user = req.session.user
		if not user then return res.json {
			success: false
			error: 400
		}

		q_reg = new RegExp(q)
		searchStr_critical = {
			"$or": [
				{ 'title': q_reg },
				{
					'tags': {
						'$elemMatch': { $in: [q_reg] }
					}
				}
			]
		}

		userPermission_critical = if user and user.role isnt 'admin' then {
			"$or": [
				{ 'createByUser': user._id },
				{
					"tags": {
						"$elemMatch": {
							$in: user.tags
						}
					}
				}
			]
		} else {}

		critical = {
			"$and": [
				userPermission_critical,
				searchStr_critical
			]
		}

		Ctrl
		.listByPage critical, {
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
		.editScript(sid, req.body, req.cookies.uid)

		.fin (cont, err, script)->
			res.json {
				success: !!!err
				script: script
				error: err
			}
			_evt.script_edit req.cookies.user, !!!err, script

	app.delete '/scripts/delete/:key', (req, res)->
		key = req.param('key')

		Ctrl
		.deleteScript(key)
		.fin (cont, err, script)->
			res.json {
				success: !!!err
				error: err
			}
			_evt.script_delete req.cookies.user, !!!err, script

	app.put '/scripts/run/:id', (req, res)->
		sid = '' + req.param('id')

		Ctrl
		.runScript sid, [], app.get('configs').spawnOptions, req.cookies.uid
		.then (cb, result, doc, logs)->
			res.json {
				success: true,
				error: result.error
				script: doc
				code: result.code
				logs: result.logs
			}
			_evt.script_run req.cookies.user, true, doc, logs

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
			_evt.script_kill req.cookies.user, logs


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
