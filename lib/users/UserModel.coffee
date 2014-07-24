
mongoose = require 'mongoose'

schema = mongoose.Schema {
	name: {
		type: String
		unique: true
	}
	password: String
	role: {
		type: String
		default: 'user'
		enum: 'tester,manager,admin'.split(',')
	}
	tags: [ String ]
	lastLoginAt: Date
	lastLoginIp: String
	frozen: {
		type: Boolean
		default: false
	}
}

User = mongoose.model 'user', schema

module.exports = User