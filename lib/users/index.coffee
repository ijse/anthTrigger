
Ctrl = require './controller'

exports.route = (app)->
	app.post '/login', (req, res)->
		Ctrl
		.login req.body.username, req.body.password
		.fin (cont, err, user)->

			if err
				_evt.user_login user.name, false

				res.json {
					success: false
				}
				return
			# write to session
			req.session.user = user
			res.cookie 'user', user.name
			res.cookie 'uid', '' + user._id

			delete user.password
			res.json {
				success: true
				user: user
			}
			_evt.user_login user.name, true

	app.get '/user/find', (req, res)->
		uid = '' + req.param('id')
		Ctrl
		.findUser { _id: uid }
		.fin (cont, err, user)->
			res.json {
				success: !!!err and user
				user: user
				error: err
			}
		.fail ->

	app.get '/user/list', (req, res)->
		Ctrl
		.listUser()
		.fin (cont, err, list)->
			res.json {
				success: !!!err and list
				list: list
				error: err
			}
		.fail ->

	app.get '/logout', (req, res)->
		_evt.user_logout req.cookies.user
		req.session.user = null
		res.clearCookie('user')
		res.clearCookie('uid')


		res.redirect '/'
