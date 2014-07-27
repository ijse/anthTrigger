
angular.module 'anthTrigger'
.controller 'listScriptController',
($scope, $location, $http, $modal, notify)->

	$scope.status = _st = {}
	$scope.list = []

	searchParams = $location.search()
	$scope.critical = searchParams

	$scope.q = searchParams.q or ''
	$scope.page = 1
	$scope.pageSize = 10
	$scope.totalItems = 0

	loadList = ()->
		_st.list = 'loading'

		params = {
			q: $scope.q
			page: $scope.page
			pageSize: $scope.pageSize
		}

		$http
		.get '/scripts/list', {
			params: params
		}
		.success (result)->
			_st.list = if result.success then 'done' else 'error'
			$scope.totalItems = result.total
			$scope.list = result.list

	loadList()

	$scope.pageChange = -> loadList()
	$scope.search = (q)->
		$location.url('/scripts?q=' + $scope.q)

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
		# Open modal, ask for script arguments

		$modal.open {
			templateUrl: '/page/scripts/run_scripts.html'
			controller: 'runScriptController'
			resolve: {
				script: ()-> script
			}
			backdrop: 'static'
			keyboard: false
		}
		.result.then (result)->

			# return if not confirm("确定要【执行】脚本:\n\n\t'#{script.title}'\n\n吗?")
			script.status = 'running'
			notify "正在执行脚本 (#{script.title})..."

			$http
			.put '/scripts/run/' + script._id, {
				args: result
			}
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
