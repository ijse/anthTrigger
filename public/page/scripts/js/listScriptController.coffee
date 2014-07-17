
angular.module 'anthTrigger'
.controller 'listScriptController',
($scope, $http)->

	$scope.status = _st = {}
	$scope.list = []

	_st.list = 'loading'
	$http
		.get '/scripts/list'
		.success (result)->
			_st.list = if result.success then 'done' else 'error'

			$scope.list = result.list


