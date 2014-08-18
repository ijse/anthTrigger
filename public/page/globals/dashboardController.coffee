angular.module('anthTrigger')
.controller 'dashboardController',
($rootScope, $scope, $cookies, $http, $location, notify)->

  # Get statistic datas
  loadStatistic = ->
    $http
    .get '/dashboard/stats'
    .success (resp)->
      $scope.stat = resp.data
    .error ->

    $http
    .get '/dashboard/recentUser'
    .success (list)->
      $scope.recentUser = list

    $http
    .get '/dashboard/recentRun'
    .success (list)->
      $scope.recentRun = list

    $http
    .get '/dashboard/usageStats'
    .success (result)->
      $scope.usageData = result

  loadStatistic()

  $scope.login = (user)->
    $http
    .post '/login', user
    .success (result)->
      if result.success
        notify.closeAll()
        $cookies.uid = result.user._id
        $rootScope.ReloadCurrentUser()
      else
        notify "登陆失败！"
    .error ->
      notify "登陆失败，服务器错误！"
    .finally ->
      loadStatistic()
  return
