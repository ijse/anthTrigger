angular.module('anthTrigger')
.controller 'userController', ($scope, $http, $modal, $q)->

	$scope.st = _st = {}
	$scope.list = []

	loadList = ->
		_st.list = 'loading'
		$http
		.get '/user/list'
		.success (data)->
			$scope.list = data.list or []

			if not data.success
				_st.list = 'error'
			else
				_st.list = 'done'

	loadList()


	# Convert tags data format between object[] and string
	# eg: [{ text: 'aaa' }, {text: 'bbb' }] => 'aaa,bbb'
	convertTags = (data)->
		result = null
		if typeof data is 'string'
			result = data.split(',').map (v)-> { text: v }
		else if data instanceof Array
			result = data.map (v)-> v.text
			result = result.join(',')

		return result

	editModal = (opt)->
		$modal.open {
			backdrop: 'static'
			keyboard: false
			templateUrl: "/page/users/edit_user.html"
			controller: ['$scope', (scope)->
				scope.options = opt
				scope.user = opt.user
				scope.user.tags = convertTags opt.user.tags
			]
		}
		.result

	$scope.addUser = ->
		editModal {
			mode: 'add'
			user: { role: 'tester' }
		}
		.then (user)->
			# to string
			user.tags = convertTags(user.tags)
			$http
			.post "/user/add", user
			.success (data)->
				loadList()
			.error ->
				alert "添加用户失败！"

	$scope.editUser = (preUser)->
		editModal {
			mode: 'edit'
			user: preUser
		}
		.then (user)->
			debugger
			# to string
			user.tags = convertTags(user.tags)
			$http
			.post "/user/edit", user
			.success (data)->
				loadList()
			.error ->
				alert "编辑用户出错！"


	$scope.loadScriptTags = (query)->
		deferred = $q.defer()
		# $http.get '/script/tags?q=' + query
		# .success (data)->
		deferred.resolve([])
		return deferred.promise