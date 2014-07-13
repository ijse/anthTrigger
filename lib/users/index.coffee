
util = require '../utils'

isExist = (username)->
  util.usedb('User').then (cont, db)->
    db.get username, (err, user)->
      cont(null, !!user)

addUser = (user)->
  username = user.name
  util.usedb('User').then (cb, db)->
    isExist(username).then (cont, exist)->
      if not exist
        db.set username, user, cb
      else
        cb new Error('Username exist!')
getUserByName = (name)->
  util.usedb('User').then (cb, db)->
    db.get name, cb

# User login
exports.login = (req, res)->
    username = req.body.username
    password = req.body.password

    util.usedb('User').then (cont, db)->
      db.get username, (err, user)->
        if user and user.pass is password
          cont(null, true, user)
        else
          cont(null, false)
    .then (cont, match, user)->
      delete user.password
      req.session.user = user
      res.json {
        success: match
        user: user
      }
    .fail (cont, err)->
      res.json {
        success: false
        error: err
      }

# Add user
exports.add = (req, res)->
  addUser(req.body).then (cont, success)->
    res.json { success: true }
  .fail (err)->
    res.json { success: false, err: err }

exports.auth = (req, res, next)->
  return next() if req.session.user
  res.send(401)

exports.find = (req, res)->
  name = req.param('name')
  getUserByName(name).then (cont, user)->
    res.json user
  .fail (err)->
    console.log err
    res.statusCode = 404
    res.end err
