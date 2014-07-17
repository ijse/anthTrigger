
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
			templateUrl: '/page/partials/index.html',
			auth: true
		})
		.when('/shell_list', {
			templateUrl: '/page/shell_list/index.html',
			auth: true
		})
		.otherwise({
			redirectTo: "/",
			auth: true
		});
})
.run(function($rootScope, $location, $cookies) {
	function checkLogin() {
		console.log($cookies.user);
		return !!$cookies.user;
	}
	$rootScope.$on('$routeChangeStart', function(event, next) {
		if(next.auth && !checkLogin()) {
			location.href = '/page/login.html';
		}
	});
});
