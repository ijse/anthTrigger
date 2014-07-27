
should = require 'should'

mongoose = require 'mongoose'
configs = require './configs.js'
util = require '../lib/utils'
userMdl = require '../lib/users/controller'
describe 'Test User', ->

	before (done)->
		if mongoose.connection.db
			userMdl.model.remove { name: 'testAdmin' }, done
			return
		util
		.connectDB configs.mongodb
		.then ->
			userMdl.model.remove { name: 'testAdmin' }, done
		.fail (err)->
			console.log arguments
			throw err

	it 'Create one user', (done)->

		userMdl.addUser {
			name: 'testAdmin'
			password: '123'
			role: 'admin'
		}
		.then (cb, user)->
			user.name.should.be.eql 'testAdmin'
			cb()
		.fail (err)->
			console.log err
			throw err
		.fin (cb, err, result)->
			done()
	it 'Find the user named testAdmin', (done)->

		userMdl.findUser {
			name: 'testAdmin'
		}
		.then (cont, user)->
			user.name.should.be.eql 'testAdmin'
			user.password.should.be.eql '123'
			cont()
		.fin (cb, err, result)->
			done()

	it 'User login success with name testAdmin', (done)->

		userMdl.login  'testAdmin','123'
		.fin (cont, err, result)->
			(err is null).should.be.ok
			done()

	it 'User login fail with wrong name', (done)->

		userMdl.login  'xxx','123'
		.fail (cb, err)->
			err.should.be.ok;
			done()

	it 'User login fail with wrong password', (done)->

		userMdl.login  'testAdmin','12345'
		.fail (cb, err)->
			err.should.be.ok;
			done()


