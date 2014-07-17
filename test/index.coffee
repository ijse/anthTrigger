
request = require 'supertest'

configs = require './configs'
app = require('../lib/server')(configs)
data = require './data'

describe 'Test case 1', ->
	it 'test connection, send ping message.', (done)->
		request(app)
			.get '/ping'
			# pong! is ok
			.expect(200, 'pong!')
			.end done

	it 'missing project configurations, got 500 error', (done)->

		request(app)
			.post '/hook'
			.send data.d1
			.expect 500
			.end done

	it 'find the project configs, execute the shell.', (done)->

		request(app)
			.post '/hook'
			.send data.d2
			.expect 200, /da1560886d4f094c3e6c9ef40349f7d38b5d27d7/
			.end (err, res)->
				# Get shell executing outputs
				# console.log res.text
				done()


