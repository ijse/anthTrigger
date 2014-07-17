
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
			auth: true
		})
		.when('/scripts/create', {
			templateUrl: '/page/scripts/add_scripts.html',
			auth: true
		})
		.otherwise({
			redirectTo: "/"
		});
})
.run(function($rootScope, $location, $cookies) {
	function checkLogin() {
		return !!$cookies.user;
	}
	$rootScope.$on('$routeChangeStart', function(event, next) {
		if(next.auth && !checkLogin()) {
			location.href = '/page/login.html';
		}
	});
});
