angular
.module('anthTrigger', [
  'ngRoute',
  'ngResource',
  'ngCookies',
  'ngSanitize',
  'ngTagsInput',
  'cgNotify',
  'ansiToHtml',
  'angularMoment',
  'ui.bootstrap'
  ])
.config(function($routeProvider, $locationProvider) {

  $locationProvider.html5Mode(true).hashPrefix('!');

  $routeProvider
  .when('/', {
    templateUrl: '/page/globals/welcome.html'
  })
  .when('/scripts', {
    templateUrl: '/page/scripts/index.html',
    controller: 'listScriptController',
    auth: true
  })
  .when('/scripts/create', {
    templateUrl: '/page/scripts/edit_scripts.html',
    controller: 'createScriptController',
    auth: true,
    resolve: { id: function() {} }
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
  .when('/scriptLogs', {
    templateUrl: '/page/scriptLogs/index.html',
    controller: 'listLogsController',
    auth: true
  })
  .when('/scriptLogs/view/:id', {
    templateUrl: '/page/scriptLogs/logs_view.html',
    controller: 'viewLogsController',
    auth: true,
    resolve: {
      id: function($route) {
        return $route.current.params.id;
      }
    }
  })
  .when('/eventLogs', {
    templateUrl: '/page/eventLogs/index.html',
    controller: 'eventLogsController',
    auth: true
  })
  .when('/users', {
    templateUrl: '/page/users/index.html',
    controller: 'userController',
    auth: true
  })
  // .otherwise({
  //   redirectTo: "/"
  // });
})
.run(function($rootScope, $location, $cookies, $http, amMoment, ansi2html, notify) {
  amMoment.changeLanguage('de');
  function getServerLocation() {
    $http
    .get('/whereAmI')
    .success(function(data) {
      $rootScope.SERVER_INFO = data;
    });

  }

  function getUser() {
    if(!$cookies.uid) {
      return notify('请先登陆！');
    }

    $http
    .get('/user/find?id=' + $cookies.uid)
    .success(function(data) {
      if (data.success) {
        ldate = moment(data.user.lastLoginAt).format('YYYY-MM-DD HH:mm:ss');
        $rootScope.CurrentUser = data.user;
        notify('欢迎回来，' + data.user.name + '. 上次登陆时间：' + ldate);
      }
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
  $rootScope.$on('$locationChangeStart', function(event, next) {
    $rootScope.pageLoading = true;
  });
  $rootScope.$on('$locationChangeSuccess', function(event, next) {
    $rootScope.pageLoading = false;
  });

  $rootScope.ansi2html = ansi2html;

  getServerLocation();
  getUser();

  notify.config({
    duration: 60000,
    template: "/page/globals/notify-template.html"
  });
});
