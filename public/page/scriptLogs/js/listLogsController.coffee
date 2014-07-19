angular.module 'anthTrigger'
.controller 'listLogsController',
($scope, $location, $http)->

	$scope.status = _st = {}
	$scope.list = []
	loadList = ->
		_st.list = 'loading'
		$http.get '/scriptLogs/list'
		.success (result)->
			$scope.list = result.data
			_st.list = 'done'

	loadList()


