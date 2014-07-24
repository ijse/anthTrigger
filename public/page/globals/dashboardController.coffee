angular.module('anthTrigger')
.controller 'dashboardController',
($scope, $http, $location, notify)->

  # Get statistic datas
  loadStatistic = ->
    $http
    .get '/dashboard/stats'
    .success (resp)->
      $scope.stat = resp.data
    .error ->

  loadStatistic()

  return