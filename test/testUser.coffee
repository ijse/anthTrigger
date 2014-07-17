
util = require '../lib/utils'
userMdl = require '../lib/users'

describe 'Test User', ->

	before (done)->
		util
		.connectDB 'mongodb://127.0.0.1:27017/anthTrigger'
		.then -> done()

	it 'Create one user', (done)->

		userMdl.addUser {
			name: 'admin'
			password: '123'
			role: 'admin'
		}
		.then (cb, user)->
			console.log user.toObject()
			cb()
		.fail (err)->
			console.log err
			throw err
		.fin (cb, err, result)->
			done()
