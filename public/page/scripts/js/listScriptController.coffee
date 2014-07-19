
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

		$http
		.delete "/scripts/delete/#{script._id}"
		.success (result)->
			if result.success
				# remove from local list
				$scope.list.splice(index, 1)
		.error ->
			console.log arguments

	$scope.runScript = (script, index)->

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

		$http
		.post '/scripts/kill/' + script._id
		.succes (result)->
			if result.success
				$scope.list[index] = result.doc


