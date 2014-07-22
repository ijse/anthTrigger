angular.module('anthTrigger')
.controller 'userController', ($scope, $http)->

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


