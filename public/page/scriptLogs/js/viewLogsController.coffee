angular.module 'anthTrigger'
.controller 'viewLogsController',
($scope, $location, $interval, $http, id)->

	$scope.status = _st = {}
	$scope.logs = {}
	t = null

	loadLogs = ->
		_st.load = 'loading'
		$http
		.get '/scriptLogs/find/' + id
		.success (result)->
			$scope.logs = result.data
			_st.load = 'done'

	loadLogs()

	$scope.setAuto = (auto)->
		if auto
			t = $interval loadLogs, 1000
		else
			$interval.cancel t if angular.isDefined(t)

	$scope.$on '$locationChangeStart', ->
		$interval.cancel t if angular.isDefined(t)

	return