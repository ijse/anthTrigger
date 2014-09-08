angular.module 'anthTrigger'
.controller 'viewLogsController',
($scope, $location, $interval, $http, ansi2html, $sce, id)->
	$scope.status = _st = {}
	$scope.logs = {}
	t = null
	$scope.autoReload = false

	loadLogs = ->
		_st.load = 'loading'
		$http
		.get '/scriptLogs/find/' + id
		.success (result)->
			$scope.logs = result.data

			if $scope.logs.endAt
				$scope.autoReload = false
				$scope.setAuto(false)
			_st.load = 'done'

	loadLogs()

	$scope.setAuto = (auto)->
		if auto
			t = $interval loadLogs, 1000
		else
			$interval.cancel t if angular.isDefined(t)

	$scope.$on '$locationChangeStart', ->
		$interval.cancel t if angular.isDefined(t)

	$scope.killScript = (scriptId, title, index)->

		return if not confirm("确定要【Kill】脚本:\n\n\t'#{title}'\n\n的此次执行吗?")

		$http
		.post '/scripts/kill/' + scriptId
		.success (result)->
			if result.success
				notify "中止脚本 (#{title}) 成功!"
				$scope.logs = result.logs
				$scope.setAuto(false)
			else
				notify "中止脚本 (#{title}) 失败!"

	return
