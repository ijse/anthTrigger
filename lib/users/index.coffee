
Ctrl = require './controller'

exports.route = (app)->
	app.post '/login', (req, res)->
		Ctrl
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
