Thenjs = require 'thenjs'
eventModel = require './EventModel'

exports.add = _add = (uname, msg)->

	Thenjs (cont)->
		doc = new eventModel({
			byUser: uname
			message: msg
		})
		doc.save (err)-> cont(err)

exports.listByPage = (crital, opts)->
	Thenjs (cont)->
		eventModel
		.find crital, null, opts, (err, list)->
			return cont(err) if err
			cont(null, list)
	.then (cont, list)->
	    # Get total count
	    eventModel.count crital, (err, count)->
	    	return cont(err) if err
	    	cont(null, list, count)

exports.countEvents = ->
  Thenjs (cont)->
    eventModel.count {}, (err, count)->
      return cont(err) if err
      cont(null, count)


exports.record = {
	user_login: (name, success, ip)->
		if success
			s = "用户#{name}登陆成功！IP: #{ip}"
		else
			s = "用户#{name}登陆失败。IP: #{ip}"
		_add name, s

	user_logout: (name)->
		_add name, '退出系统'

	script_add: (name, success, script)->
		if success
			s = "创建脚本#{script.title}(#{script._id})成功."
		else
			s = "创建脚本失败：#{err}"
		_add name, s

	script_edit: (name, success, script)->
		if success
			s = "编辑脚本#{script.title}(#{script._id})成功."
		else
			s = "编辑脚本失败：#{err}"
		_add name, s

	script_delete: (name, success, script)->
		if success
			s = "删除脚本#{script.title}(#{script._id})成功."
		else
			s = "删除脚本失败: #{err}"
		_add name, s

	script_kill: (name, logs)->
		_add name, "Kill进程#{logs.pid}, 脚本#{logs.snapshot.title}."

	script_run: (name, success, script, logs)->
		if success
			s = "执行脚本#{script.title}(#{script._id})成功, 日志：#{logs._id}."
		else
			s = "执行脚本#{script.title}(#{script._id})失败."
		_add name, s

}




