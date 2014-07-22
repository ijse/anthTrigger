Thenjs = require 'thenjs'
userModel = require './UserModel'

exports.model = userModel

exports.login = (uname, upass)->
  # todo...

  userModel.find {
  	name: uname
  	password: upass
  }, (err, doc)->


exports.addUser = (user)->

	Thenjs (cont)->
		user = new userModel(user)
		user.save cont

exports.findUser = (critcal)->
	Thenjs (cont)->
		userModel.findOne critcal, cont

exports.login = (name, pass)->
	Thenjs (cont)->
		userModel.findOne {
			name: name,
			password: pass
		}, (err, doc)->
			return cont(err) if err
			return cont('Password wrong!') if not doc
			return cont(null, doc)
	.then (cont, doc)->
		# Update last login time
		doc.lastLoginAt = new Date()
		doc.save (err)-> cont(err, doc)

exports.listUser = ()->
	Thenjs (cont)->
		userModel.find {}, (err, list)->
			return cont(err) if err
			return cont(null, list or [])

