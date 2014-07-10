
should = require 'should'

Tiny = require 'tiny'
global.__config = require './configs.js'

User = require '../lib/users'

describe 'User', ->
  db = null

  before (done)->
    Tiny __config.dbDir + '/User.db', (err, _db)->
      db = _db
      db.remove 'ijse', (err)->
        db.compact done

  it 'add one user named ijse', (done)->
    User.add {
      body: {
        name: 'ijse'
        pass: '123'
      }
    }, {
      json: (resp)->
        done()
    }

  it 'should login failed for wrong password', (done)->
    User.login {
      body: {
        username: 'ijse'
        password: 'wrongPass'
      }
    }, {
      json: (data)->
        data.success.should.be.false
        done()
    }

  it 'should login successful with the right password', (done)->
    User.login {
      body: { username: 'ijse', password: '123' }
    }, {
      json: (resp)->
        resp.success.should.be.true
        done()
    }

  it 'should return the user data with the name ijse', (done)->
    User.find {
      param: -> 'ijse'
    }, {
      json: (resp)->
        resp.name.should.be.eql('ijse')
        done()
    }
