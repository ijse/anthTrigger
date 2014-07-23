angular.module('anthTrigger')
.controller 'userController', ($scope, $http, $modal)->

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


	editModal = (opt)->
		$modal.open {
			backdrop: 'static'
			keyboard: false
			templateUrl: "/page/users/edit_user.html"
			controller: ['$scope', (scope)->
				scope.options = opt
				scope.user = opt.user

			]
		}
		.result

	$scope.addUser = ->
		editModal {
			mode: 'add'
			user: { role: 'tester' }
		}
		.then (user)->
			$http
			.post "/user/add", user
			.success (data)->
				loadList()
			.error ->
				alert "添加用户失败！"

	$scope.editUser = (user)->
		editModal {
			mode: 'edit'
			user: user
		}
		.then (user)->
			$http
			.post "/user/edit", user
			.success (data)->
				loadList()
			.error ->
				alert "编辑用户出错！"


