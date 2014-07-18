
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
			res.cookie 'uid', '' + user._id

			delete user.password
			res.json {
				success: true
				user: user
			}
	app.get '/user/find', (req, res)->
		uid = req.param('id')
		Ctrl
		.findUser { _id: uid }
		.then (cont, user)->
			res.json {
				success: true
				user: user
			}
		.fail (cont, err)->
			res.json {
				success: false
				error: err
			}

	app.get '/logout', (req, res)->
		req.session.user = null
		res.clearCookie('user')
		res.clearCookie('uid')

		res.redirect '/'
