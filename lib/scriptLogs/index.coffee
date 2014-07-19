
Ctrl = require './controller'

exports.route = (app)->

	app.get '/scriptLogs/list', (req, res)->
		Ctrl
		.list()
		.fin (cont, err, list)->

			res.json {
				success: !!!err
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