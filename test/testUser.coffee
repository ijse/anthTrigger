
should = require 'should'

mongoose = require 'mongoose'
configs = require './configs.js'
util = require '../lib/utils'
userMdl = require '../lib/users/controller'
describe 'Test User', ->

	before (done)->
		if mongoose.connection.db
			userMdl.model.remove {}, done
			return
		util
		.connectDB configs.mongodb
		.then ->
			userMdl.model.remove {}, done
		.fail (err)->
			console.log arguments
			throw err

	it 'Create one user', (done)->

		userMdl.addUser {
			name: 'admin'
			password: '123'
			role: 'admin'
		}
		.then (cb, user)->
			user.name.should.be.eql 'admin'
			cb()
		.fail (err)->
			console.log err
			throw err
		.fin (cb, err, result)->
			done()
	it 'Find the user named admin', (done)->

		userMdl.findUser {
			name: 'admin'
		}
		.then (cont, user)->
			user.name.should.be.eql 'admin'
			user.password.should.be.eql '123'
			cont()
		.fin (cb, err, result)->
			done()

	it 'User login success with name admin', (done)->

		userMdl.login  'admin','123'
		.fin (cont, err, result)->
			(err is null).should.be.ok
			done()

	it 'User login fail with wrong name', (done)->

		userMdl.login  'xxx','123'
		.fin (cb, err)->
			err.should.be.ok;
			done()
	it 'User login fail with wrong password', (done)->

		userMdl.login  'admin','12345'
		.fin (cb, err)->
			err.should.be.ok;
			done()


