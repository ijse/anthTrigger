
angular.module('anthTrigger')
.controller 'editScriptController',
($scope, $http, $location, id)->

	_st = {}
	$scope.status = _st
	$scope.script = {}

	_st.data = 'loading'

	# Convert tags data format between object[] and string
	# eg: [{ text: 'aaa' }, {text: 'bbb' }] => ['aaa', 'bbb']
	convertTags = (data)->
		return data?.map? (v)-> if v.text then v.text else { text: v }


	loadScript = ->
		$http
		.get '/scripts/find/' + id
		.success (result)->
			if result.success
				_st.data = 'loaded'
				result.script.tags = convertTags result.script.tags
				return $scope.script = result.script
			else
				_st.data = 'error'

	loadScript()

	$scope.save = ->
		_st.save = 'saving'
		script = angular.copy $scope.script
		script.tags = convertTags script.tags

		$http
		.post '/scripts/edit/' + id, script
		.success (result)->
			_st.save = if result.success then 'done' else 'error'

			$location.url('/scripts') if result.success


	return