angular.module 'anthTrigger'
.controller 'manageDataController',
($scope, $http, notify, $modal)->

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

  $scope.restoreDatabase = ->

    $modal.open {
      backdrop: 'static'
      keyboard: false
      templateUrl: "/page/settings/restoreDatabaseModal.html"
      controller: ['$scope', '$modalInstance', (scope, $modalInstance)->

        scope._st = _st = {}
        _st.list = 'loading'

        $http
        .get '/settings/database_bak/list'
        .success (resp)->
          scope.list = resp.list
          _st.list = null
        .error ->
          notify('查询数据库备份文件出错！')
          $modalInstance.dismiss()

        scope.restore = (file)->

          $http
          .put '/settings/restore_database', {
            file: file
          }
          .success (result)->
            notify('恢复数据库成功 ！')
            $modalInstance.dismiss()
          .error ->
            notify('恢复失败！')
            $modalInstance.dismiss()
      ]
    }
