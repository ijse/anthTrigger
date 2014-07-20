
Ctrl = require './controller'

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
		.fin (cont, err, logs)->
			res.json {
				success: !!!err
				data: logs
			}