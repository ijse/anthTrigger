angular.module 'anthTrigger'
.controller 'eventLogsController',
($scope, $location, $http)->

	searchParams = $location.search()
	$scope.critical = searchParams

	$scope.page = 1
	$scope.totalItems = 0
	$scope.pageSize = 10

	$scope.status = _st = {}
	$scope.list = []
	loadList = (page)->
		_st.list = 'loading'
		$http.get '/eventLogs/list', {
			params: {
				critical: searchParams
				page: page
				pageSize: $scope.pageSize
			}
		}
		.success (result)->
			$scope.list = result.list
			$scope.totalItems = result.total
			_st.list = 'done'

	loadList(1)

	$scope.pageChange = ->
		loadList($scope.page)