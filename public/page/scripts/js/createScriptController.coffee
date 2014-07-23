
angular.module('anthTrigger')
.controller 'createScriptController',
($scope, $http, $location, notify)->

	_st = {}
	$scope.status = _st
	$scope.script = {}

	$scope.save = ->
		script = $scope.script
		_st.save = 'saving'
		$http
			.post '/scripts/create', script
			.success (result)->

				_st.save = if result.success then 'done' else 'error'


				if result.success
					notify "脚本 (#{script.title}) 创建成功！"
					$location.url('/scripts')
				else
					notify "脚本 (#{script.title}) 创建失败！"

	return