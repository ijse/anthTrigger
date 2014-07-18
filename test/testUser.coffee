
should = require 'should'
util = require '../lib/utils'
userMdl = require '../lib/users'

describe 'Test User', ->

	before (done)->
		util
		.connectDB 'mongodb://127.0.0.1:27017/anthTrigger'
		.then ->
			userMdl.model.remove {}, done

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


