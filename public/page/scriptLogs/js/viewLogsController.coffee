angular.module 'anthTrigger'
.controller 'viewLogsController',
($scope, $location, $http, id)->

	$scope.status = _st = {}

	$scope.logs = {}

	loadLogs = ->
		$http
		.get '/scriptLogs/find/' + id
		.success (result)->
			console.log result
			$scope.logs = result.data

	loadLogs()