
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
		// .when("/", {
		// 	redirectTo: "/index.html"
		// })
		.when('/shell_list', {
			templateUrl: '/page/shell_list/index.html',
			auth: true
		})
		.otherwise({
			redirectTo: "/"
		});
})
.run(function($rootScope, $location, $cookies) {
	// function checkLogin() {
	// 	return !!$cookies.user;
	// }
	// $rootScope.$on('$routeChangeStart', function(event, next) {
	// 	if(next.auth && !checkLogin()) {
	// 		$location.path('/login');
	// 	}
	// });
});
