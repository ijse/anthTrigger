
angular.module('anthTrigger')
.controller 'editScriptController',
($scope, $http, $location)->

	_st = {}
	$scope.status = _st
	$scope.script = {}
	$scope.save = ->
		_st.save = 'saving'
		$http
			.post '/scripts/create', $scope.script
			.success (result)->

				_st.save = if result.success then 'done' else 'error'

				$scope.script = result.script

				$location.url('/scripts') if result.success

