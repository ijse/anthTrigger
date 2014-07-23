
angular.module('anthTrigger')
.controller 'createScriptController',
($scope, $http, $location, notify)->

	_st = {}
	$scope.status = _st
	$scope.script = {}

	# Convert tags data format between object[] and string
	# eg: [{ text: 'aaa' }, {text: 'bbb' }] => ['aaa', 'bbb']
	convertTags = (data)->
		return data?.map? (v)-> if v.text then v.text else { text: v }


	$scope.save = ->
		_st.save = 'saving'

		script = $scope.script
		script.tags = convertTags script.tags
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