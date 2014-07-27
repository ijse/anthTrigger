should = require 'should'

request = require 'supertest'
mongoose = require 'mongoose'
configs = require './configs'
util = require '../lib/utils'
app = require('../lib/server')(configs)
scriptCtrl = require '../lib/script/controller'

describe "Test scripts", ->

	script_id = null
	sid = 0
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
				script_id = result._id
				sid = result.scriptId
				done()

	it 'Test find one script', (done)->
		scriptCtrl
			.findById script_id
			.fin (cont, err, script)->
				(err is null).should.be.ok
				script.should.have.property('title')
				done()

	it.skip 'Modify a script', (done)->
		scriptCtrl
			.editScript script_id, {
				title: 'hello modifyed'
			}
			.fin (cont, err, count, result)->
				(err is null).should.be.ok
				count.should.be.above(0)
				done()
			.fail (cont, err)->
				console.log err

	it 'Run the script and get the result.', (done)->
		scriptCtrl
			.runScript script_id, [ 'arg1']
			.fin (cont, err, result)->
				(err is null).should.be.ok
				result.logs.should.be.eql '+ echo hello - arg1\nhello - arg1\n'
				done()

	it 'Kill the process with script_id ' + script_id, (done)->
		scriptCtrl
			.killScript script_id
			.fin (cont, err, result)->
				(err is null).should.be.ok
				result.should.be.ok
				done()

	it 'Call and run the script by id', (done)->
		scriptCtrl
			.callScript sid, [ 'arg132' ], { shell: 'sh' }, process.env
			.then (cont, code, output, script)->
				output.should.be.match /hello - arg1/
				done()
			.fail (cont, err)->
				console.log "Got error: ", err
				done(err)

	it 'Delete the script', (done)->
		scriptCtrl
			.deleteScript script_id
			.fin (cont, err, result)->
				(err is null).should.be.ok
				result.should.be.above(0)
				done()

