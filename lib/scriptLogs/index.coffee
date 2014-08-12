
Ctrl = require './controller'
userCtrl = require '../users/controller'

exports.route = (app)->

	app.get '/scriptLogs/list', (req, res)->
		page = req.param('page')
		page = parseInt(page) or 1

		pageSize = req.param('pageSize')
		pageSize = parseInt(pageSize) or 10

		Ctrl
		.listByPage {}, {
			skip: (page-1)*pageSize
			limit: pageSize
			sort: {
				startAt: -1
			}
		}
		.fin (cont, err, list, total)->

			res.json {
				success: !!!err
				total: total
				data: list or []
			}

	app.get '/scriptLogs/find/:id', (req, res)->
		lid = '' + req.param('id')

		Ctrl
		.findById lid
		.then (cont, logs)->

			# Populate the user
			userCtrl.findById {
				_id: logs.runByUser
			}
			.then (cont2, user)-> cont2(null, user or {})
			.fail (cont2, err)-> cont2(null, {})
			.fin (cont2, err, user)->
				user.password = null

				cont(null, logs, user)

		.fin (cont, err, logs, user)->
			data = logs.toObject()
			data.runByUser = {
				name: user.name
				role: user.role
				_id: user._id
			}
			res.json {
				success: !!!err
				data: data
			}