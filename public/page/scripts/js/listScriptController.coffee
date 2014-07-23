
angular.module 'anthTrigger'
.controller 'listScriptController',
($scope, $location, $http, $modal, notify)->

	$scope.status = _st = {}
	$scope.list = []

	$scope.page = 1
	$scope.totalItems = 0
	$scope.pageSize = 10


	loadList = (page)->
		_st.list = 'loading'
		$http
		.get '/scripts/list', {
			params: {
				page: page
				pageSize: $scope.pageSize
			}
		}
		.success (result)->
			_st.list = if result.success then 'done' else 'error'
			$scope.totalItems = result.total
			$scope.list = result.list

	loadList(1)
	$scope.pageChange = ->
		loadList($scope.page)

	$scope.viewScript = (script)->
		$modal.open {
			templateUrl: '/page/scripts/view_scripts.html'
			controller: ['$scope', (scope)->
				scope.script = script
			]
		}

	$scope.deleteScript = (script, index)->

		return if not confirm("确定要【删除】脚本:\n\n\t'#{script.title}'\n\n吗?")

		$http
		.delete "/scripts/delete/#{script._id}"
		.success (result)->
			if result.success
				notify "删除脚本 (#{script.title}) 成功！"
				# remove from local list
				$scope.list.splice(index, 1)
			else
				notify "删除脚本 (#{script.title}) 失败！"


	$scope.runScript = (script, index)->
		return if not confirm("确定要【执行】脚本:\n\n\t'#{script.title}'\n\n吗?")

		script.status = 'running'
		notify "正在执行脚本 (#{script.title})..."

		$http
		.put '/scripts/run/' + script._id
		.success (result)->
			notify "脚本(#{result.script.title})执行完成！请到【执行历史】中查看！"
			$scope.list[index] = result.script

	$scope.killScript = (script, index)->

		return if not confirm("确定要【Kill】脚本:\n\n\t'#{script.title}'\n\n的此次执行吗?")

		$http
		.post '/scripts/kill/' + script._id
		.success (result)->
			if result.success
				notify "中止脚本 (#{script.title}) 成功!"
				$scope.list[index] = result.script
			else
				notify "中止脚本 (#{script.title}) 失败!"


	$scope.viewLogs = (script)->

		$http
		.get '/scripts/find/' + script._id
		.success (result)->
			$location.url("/scriptLogs/view/#{result.script.lastRunLogs}") if result.success
