Thenjs = require 'thenjs'
userModel = require './UserModel'

exports.login = (uname, upass)->
  # todo...

  userModel.find {
  	name: uname
  	password: upass
  }, (err, doc)->


exports.addUser = (user)->

	Thenjs (cb)->
		user = new userModel(user)
		user.save cb
