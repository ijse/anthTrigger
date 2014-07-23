
Ctrl = require './controller'

exports.route = (app)->
	app.post '/login', (req, res)->
		uname = req.body.username
		upass = req.body.password

		Ctrl
		.login uname, upass
		.fin (cont, err, user)->

			if err
				_evt.user_login uname, false

				res.json {
					success: false
					error: "server error"
				}
				return

			if user.frozen
				_evt.user_login uname, false
				res.json {
					success: false
					error: 'frozen user'
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

	app.post '/user/add', (req, res)->

		Ctrl
		.addUser req.body
		.fin (cont, err, user)->
			res.json {
				success: !!!err and user
				user: user
				error: err
			}

	app.post '/user/edit', (req, res)->

		Ctrl
		.editUser req.body
		.fin (cont, err, numberAffected, user)->
			# Refresh session user
			if user._id is req.session.user._id
				req.session.user = user
			res.json {
				success: !!!err and numberAffected > 0
				error: err
			}

	app.put '/user/frozen', (req, res)->
		uid = req.param('uid')
		Ctrl
		.frozeUser uid
		.fin (cont, err)->
			res.json {
				success: !!!err
				error: err
			}

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
		.listUser {}, { password: 0 }, { sort: { lastLoginAt: -1 } }
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
