angular.module 'anthTrigger'
.controller 'listLogsController',
($scope, $location, $http)->

	$scope.page = 1
	$scope.totalItems = 0
	$scope.pageSize = 10

	$scope.status = _st = {}
	$scope.list = []
	loadList = (page)->
		_st.list = 'loading'
		$http.get '/scriptLogs/list', {
			params: {
				page: page
				pageSize: $scope.pageSize
			}
		}
		.success (result)->
			$scope.list = result.data
			$scope.totalItems = result.total
			_st.list = 'done'

	loadList(1)

	$scope.pageChange = ->
		loadList($scope.page)