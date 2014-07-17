
request = require 'supertest'
configs = require './configs'
app = require('../lib/server')(configs)

describe "Test scripts", ->

	it 'Ping pong test', (done)->
		request(app)
			.get('/ping')
			.expect(200)
			.end done
