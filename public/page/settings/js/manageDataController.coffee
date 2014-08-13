angular.module 'anthTrigger'
.controller 'manageDataController',
($scope, $http, notify)->

  $scope._st = _st = {}

  $scope.exportZip = ->

    _st.export = 'processing'
    $http
    .put '/settings/export_scripts'
    .success (result)->
      _st.export = null
      notify('脚本备份文件已经生成到：' + result.file)
    .error ->
      _st.export = null
