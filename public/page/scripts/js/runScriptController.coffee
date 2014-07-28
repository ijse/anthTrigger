
modl = angular.module('anthTrigger')

modl.filter 'cmdArgsFormatFilter', ->
	(input, inArray=false)->
		return input if not input
		if inArray
			return input.split('\n')
		else
			input.replace(/\n/g, ' ')

modl.controller 'runScriptController',
($scope, $modalInstance, script)->
	$scope.script = script

	$scope.runScript = (args='', notes)->
		argsInArray = args.split('\n')

		$modalInstance.close {
			args: argsInArray,
			notes: notes
		}
