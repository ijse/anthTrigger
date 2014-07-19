
angular.module 'anthTrigger'
.controller 'listScriptController',
($scope, $http, $modal)->

	$scope.status = _st = {}
	$scope.list = []

	loadList = ->
		_st.list = 'loading'
		$http
		.get '/scripts/list'
		.success (result)->
			_st.list = if result.success then 'done' else 'error'
			$scope.list = result.list

	loadList()

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
				# remove from local list
				$scope.list.splice(index, 1)

	$scope.runScript = (script, index)->
		return if not confirm("确定要【执行】脚本:\n\n\t'#{script.title}'\n\n吗?")

		script.status = 'running'

		$http
		.put '/scripts/run/' + script._id
		.success (result)->
			$modal.open {
				template: "<pre>{{content}}</pre>"
				controller: ['$scope', (scope)->
					scope.content = result.logs
					$scope.list[index] = result.script
				]
			}

	$scope.killScript = (script, index)->

		return if not confirm("确定要【Kill】脚本:\n\n\t'#{script.title}'\n\n的此次执行吗?")


		$http
		.post '/scripts/kill/' + script._id
		.success (result)->
			if result.success
				$scope.list[index] = result.script


