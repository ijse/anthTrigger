should = require 'should'

request = require 'supertest'
mongoose = require 'mongoose'
configs = require './configs'
util = require '../lib/utils'
app = require('../lib/server')(configs)
scriptCtrl = require '../lib/script/controller'

describe "Test scripts", ->

	scriptId = null
	before (done)->
		return done() if mongoose.connection.db
		util
		.connectDB configs.mongodb
		.then ->
			done()
		.fail (err)->
			throw err

	it 'Ping pong test', (done)->
		request(app)
			.get('/ping')
			.expect(200)
			.end done


	it 'Add a script', (done)->

		scriptCtrl
			.addScript {
				title: 'hello script'
				codes: 'echo hello - $1'
			}
			.fin (cont, err, result)->
				(err is null).should.be.ok
				result.should.have.property('_id')
				scriptId = result._id
				done()

	it 'Test find one script', (done)->
		scriptCtrl
			.findById scriptId
			.fin (cont, err, script)->
				(err is null).should.be.ok
				script.should.have.property('title')
				done()

	it 'Modify a script', (done)->
		scriptCtrl
			.editScript scriptId, {
				title: 'hello modifyed'
			}
			.fin (cont, err, result)->
				(err is null).should.be.ok
				result.should.be.above(0)
				done()

	it 'Run the script and get the result.', (done)->
		scriptCtrl
			.runScript scriptId, [ 'arg1']
			.fin (cont, err, result)->
				(err is null).should.be.ok
				result.logs.should.be.eql 'hello - arg1\n'
				done()

	it 'Delete the script', (done)->
		scriptCtrl
			.deleteScript scriptId
			.fin (cont, err, result)->
				(err is null).should.be.ok
				result.should.be.above(0)
				done()
