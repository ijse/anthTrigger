angular.module 'anthTrigger'
.controller 'manageDataController',
($scope, $http, notify)->

  $scope._st = _st = {}

  $scope.exportZip = ->

    _st.export = 'loading'
    $http
    .put '/settings/export_scripts'
    .success (result)->
      _st.export = null
      notify('脚本备份文件已经生成到：' + result.file)
    .error ->
      _st.export = null
      notify('脚本文件导出失败..')

  $scope.clearScriptLogs = (days)->

    _st.clearScriptLogs = 'loading'
    $http
    .put '/settings/clear_scriptLogs', {
      days: days
    }
    .success (result)->
      _st.clearScriptLogs = null
      notify('清理成功! 共清除' + (result.count || 0) + "条数据！")

    .error ->
      _st.clearScriptLogs = null
      notify('清理失败..')

  $scope.clearEventLogs = (days)->

    _st.clearEventLogs = 'loading'
    $http
    .put '/settings/clear_eventLogs', {
      days: days
    }
    .success (result)->
      _st.clearEventLogs = null
      notify('清理成功! 共清除' + (result.count || 0) + "条数据！")

    .error ->
      _st.clearEventLogs = null
      notify('清理失败..')

  $scope.dumpDatabase = ()->
    _st.dumpDatabase = 'loading'
    $http
    .put '/settings/dump_database'
    .success (result)->
      _st.dumpDatabase = null

      notify('数据库备份成功！备份文件：' + (result.file))

    .error ->
      _st.dumpDatabase = null
      notify('数据库备份失败。')

