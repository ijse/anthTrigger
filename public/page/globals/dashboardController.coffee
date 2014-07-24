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
  return
