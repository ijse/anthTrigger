Thenjs = require 'thenjs'
userModel = require './UserModel'

exports.model = userModel

exports.addUser = (user)->

	Thenjs (cont)->
		user = new userModel(user)
		user.save (err)->
			return cont(err) if err
			return cont(null, user)

exports.findUser = (critcal)->
	Thenjs (cont)->
		userModel.findOne critcal, cont

exports.editUser = (user)->
	Thenjs (cont)->
		id = user._id
		delete user._id
		userModel.update {
			_id: id
		}, {
			$set: user
		}, (err, na)->
			user._id = id
			return cont(err) if err
			cont(null, na, user)

exports.frozeUser = (id)->
	Thenjs (cont)->
		userModel.findById id, (err, user)->
			return cont(err) if err
			cont(null, user)
	.then (cont, user)->
		user.frozen = not user.frozen
		user.save (err)->
			return cont(err) if err
			cont(null)

exports.login = (name, pass, ip)->
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
		doc.lastLoginIp = ip
		doc.save (err)-> cont(err, doc)

exports.listUser = (critcal, fields, opts={})->
	Thenjs (cont)->
		userModel.find critcal, fields, opts, (err, list)->
			return cont(err) if err
			return cont(null, list or [])
