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


	$scope.addUser = ->
		$modal.open {
			backdrop: 'static'
			keyboard: false
			templateUrl: "/page/users/edit_user.html"
			controller: ['$scope', (scope)->
				scope.user = {
					role: 'tester'
				}

			]
		}
		.result.then (user)->
			$http
			.post "/user/add", user
			.success (data)->
				loadList()
			.error ->
				alert( "添加用户失败！")
