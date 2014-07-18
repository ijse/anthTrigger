angular
.module('anthTrigger', [
  'ngRoute',
  'ngResource',
  'ngCookies',
  'ui.bootstrap'
  ])
.config(function($routeProvider, $locationProvider) {

  $locationProvider.html5Mode(true).hashPrefix('!');

  $routeProvider
  .when('/', {
    templateUrl: '/page/partials/welcome.html'
  })
  .when('/scripts', {
    templateUrl: '/page/scripts/index.html',
    controller: 'listScriptController',
    auth: true
  })
  .when('/scripts/create', {
    templateUrl: '/page/scripts/edit_scripts.html',
    controller: 'editScriptController',
    auth: true
  })
  .when('/scripts/edit/:id', {
    templateUrl: '/page/scripts/edit_scripts.html',
    controller: 'editScriptController',
    auth: true,
    resolve: {
      id: function($route) {
        return $route.current.params.id;
      }
    }
  })
  // .otherwise({
  //   redirectTo: "/"
  // });
})
.run(function($rootScope, $location, $cookies, $http) {
  function getServerLocation() {
    $http
    .get('/whereAmI')
    .success(function(data) {
      $rootScope.SERVER_IP = data.ip;
    });

  }

  function getUser() {
    $http
    .get('/user/find?id=' + $cookies.uid)
    .success(function(data) {
      if (data.success)
        $rootScope.user = data.user;
    });
  }

  function checkLogin() {
    return !!$cookies.user;
  }
  $rootScope.$on('$routeChangeStart', function(event, next) {
    if(!next) {
      return location.href = $location.url()
    }
    if (next.auth && !checkLogin()) {
      location.href = '/page/login.html';
    }
  });

  getServerLocation();
  getUser();
});
