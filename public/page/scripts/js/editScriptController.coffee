
angular.module('anthTrigger')
.controller 'editScriptController',
($scope, $http, $location, id)->

	_st = {}
	$scope.status = _st
	$scope.script = {}

	_st.data = 'loading'
	$http
		.get '/scripts/find/' + id
		.success (result)->
			if result.success
				_st.data = 'loaded'
				return $scope.script = result.script
			else
				_st.data = 'error'

	$scope.save = ->
		_st.save = 'saving'
		$http
			.post '/scripts/edit/' + id, $scope.script
			.success (result)->
				_st.save = if result.success then 'done' else 'error'

				$location.url('/scripts') if result.success


	return