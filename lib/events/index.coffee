Ctrl = require './controller'
exports.route = (app)->

	# set up events recorder
	global._evt = Ctrl.record

	app.get '/eventLogs/list', (req, res)->
		page = req.param('page')
		page = parseInt(page) or 1

		pageSize = req.param('pageSize')
		pageSize = parseInt(pageSize) or 10

		critical = req.param('critical')
		critical = JSON.parse(critical)

		Ctrl
		.listByPage critical, {
			skip: (page-1) * pageSize
			limit: pageSize
			sort: { timeAt: -1 }
		}
		.fin (cont, err, list, total)->
			res.json {
				success: !!!err
				error: err
				list: list
				total: total
			}
	app.put '/eventLogs/add', (req, res)->
		uname = req.cookies.user
		msg = req.param('msg')
		Ctrl
		.add uname, msg
		.fin (cont, err)->
			res.json {
				success: !!!err
				error: err
			}
	return