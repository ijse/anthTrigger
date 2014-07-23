
angular.module('anthTrigger')
.controller 'editScriptController',
($scope, $http, $location, $q, notify, id)->

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
				notify "脚本载入失败！"
				_st.data = 'error'

	loadScript()

	$scope.loadTags = (query)->
		deferred = $q.defer()
		$http
		.get '/scripts/tags?q=' + query
		.success (data)->
			deferred.resolve(data.map (v)-> { text: v })

		return deferred.promise

	$scope.save = ->
		_st.save = 'saving'
		script = angular.copy $scope.script
		script.tags = convertTags script.tags

		notify "正在保存脚本 (#{script.title})..."

		$http
		.post '/scripts/edit/' + id, script
		.success (result)->
			_st.save = if result.success then 'done' else 'error'

			if result.success
				notify "脚本 (#{script.title}) 保存成功！"
				$location.url('/scripts')
			else
				notify "脚本 (#{script.title}) 保存失败！"


	return