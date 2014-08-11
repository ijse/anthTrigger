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
  'ui.codemirror',
  'ui.bootstrap'
  ])
.config(function($routeProvider, $httpProvider, $locationProvider) {

  $locationProvider.html5Mode(true).hashPrefix('!');

  // Check user session
  $httpProvider.defaults.headers.common['X-Requested-With'] = "XMLHttpRequest";
  $httpProvider.interceptors.push(function($q) {
    return {
      'response': function(resp) {
        if(resp.data.error === 'Not login') {
          location.href="/page/login.html";
        }
        return resp;
      }
    }
  })

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
.run(function($rootScope, $location, $cookies, $http, amMoment, begService, ansi2html, notify) {

  amMoment.changeLanguage('de');
  function getServerLocation() {
    $http
    .get('/whereAmI')
    .success(function(data) {
      $rootScope.SERVER_INFO = data;
    });

  }
  getServerLocation();

  function getUser() {
    if(!$cookies.uid) {
      return notify('请先登陆！');
    }

    $http
    .get('/user/find?id=' + $cookies.uid)
    .success(function(data) {
      if (data.success) {
        var ldate = moment(data.user.lastLoginAt).format('YYYY-MM-DD HH:mm:ss');
        $rootScope.CurrentUser = data.user;
        var nstr = '欢迎回来，' + data.user.name + '. 上次登录时间：' + ldate + ".";
        if(data.user.lastLoginIp) {
          nstr = nstr + "<br>上次登录IP地址：" + data.user.lastLoginIp;
        }
        notify(nstr);
      }

      // Check permissions after we have got current user infomation
      var viewPath = location.pathname;
      var NO = begService.beg(viewPath);
      if(NO) {
        location.href='/'
      }
    });
  }
  getUser();
  $rootScope.ReloadCurrentUser = getUser;


  function checkLogin() {
    return !!$cookies.user;
  }
  $rootScope.$on('$routeChangeStart', function(event, next) {
    if(!next) {
      return location.href = $location.url()
    }
    if (next.auth && !checkLogin()) {
      $location.url('/');
    }
  });
  $rootScope.$on('$locationChangeStart', function(event, next) {
    $rootScope.pageLoading = true;
  });
  $rootScope.$on('$locationChangeSuccess', function(event, next) {
    $rootScope.pageLoading = false;
  });

  $rootScope.ansi2html = ansi2html;


  notify.config({
    duration: 60000,
    template: "/page/globals/notify-template.html"
  });

  window.notify = notify

});
