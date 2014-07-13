
angular
.module('anthTrigger', [
	'ngRoute',
	'ngResource',
	'ui.bootstrap'
])
.config(function($routeProvider, $locationProvider) {

	$locationProvider.html5Mode(true).hashPrefix('!');

	$routeProvider
		// .when("/", {
		// 	redirectTo: "/index.html"
		// })
		.when('/shell_list', {
			templateUrl: '/page/shell_list/index.html'
		})
		.otherwise({
			redirectTo: "/"
		});
});
