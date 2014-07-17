Thenjs = require 'thenjs'
Tiny = require 'tiny'
pool = {}
exports.usedb = (dbname)->

  # console.log ">>>", dbname, pool[dbname]
  Thenjs (cb)->

    if not pool[dbname]

      Tiny __config.dbDir + '/' + dbname + '.db', (err, db)->

        pool[dbname] = db

        cb(err, db)

    else

      cb(null, pool[dbname])

exports.generateId = ()->
	d = new Date().getTime()
	d = '' + d + Math.round(Math.random()*1000)
	return d