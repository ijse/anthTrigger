/*
		APPS CONTENT TABLE
	----------------------------
	
	<!-- ======== GLOBAL SCRIPT SETTING ======== -->
	01. Sidebar Menu Setting
		- handleSidebarMenu();
	02. Slimscroll Auto Detect Setting
		- handleSlimScroll();
	03. Bootstrap Tooltip & Popover Activate Setting
		- handleTooltip();
		- handlePopover();
	04. Footer Scroll to Top Button Setting
		- handleScrolToTop();
	
	<!-- ======== PLUGINS SETTING ======== -->
	05. Chart Plugins Setting
		- handleSparkline();
		- handleDashboardSparkline();
		- handleInteractiveChart();
		- handleBasicChart();
		- handleLiveUpdatedChart();
		- handleStackedChart();
		- handleTrackingChart();
		- handleBarChart();
		- handleInteractivePieChart();
		- handleDonutChart();
	06. Calendar Setting
		- handleDashboardCalendar();
		- handleCalendarDemo();
	07. Vector Map Setting
		- handleDashboardVectorMap();
		- handleVectorMapExample();
		- handleGoogleMapSetting();
	08. Gritter Notification Setting
		- handleGritter();
		- handleDashboardNotification();
	09. Form Plugins Setting
		- handleFormMaskedInput();
		- handleFormColorPicker();
		- handleFormDatePicker();
		- handleFormTimePicker();
		- handleFormPasswordStrenthIndicator();
		- handleFormComboBox();
		- handleFormSelectWithSearch();
		- handleFormDualListBox();
		- handleBootstrapWizards();
		- handleFormWysihtml5();
	10. Isotopes Setting
	
	<!-- ======== APPLICATION SETTING ======== -->
	11. Application Controller
*/

var red    = '#e5603b',
    blue   = '#618fb0',
    green  = '#56bc76',
    yellow = '#eac85e',
    dark   = '#333333',
    grey   = '#aaaaaa',
    semiDark = 'rgba(0,0,0,0.2)';

/* 01. Sidebar Menu Setting
------------------------------------------------ */
var handleSidebarMenu = function() {
	"use strict";
	$('#sidebar ul li.has-sub > a').click(function(e) {
		e.preventDefault();
		$('#sidebar ul.dropdown-menu').slideUp(200);
		if($(this).next('ul.dropdown-menu').is(':hidden')) {
			$(this).next('ul.dropdown-menu').slideToggle(200);
		}
	});
};


/* 02. Slimscroll Auto Detect Setting
------------------------------------------------ */
var handleSlimScroll = function() {
	"use strict";
	$('[data-scrollbar=true]').each( function() {
		var dataHeight = $(this).attr('data-height');
		$(this).slimScroll({height: dataHeight, alwaysVisible: true});
	});
};


/* 03. Bootstrap Tooltip & Popover Activate Setting
------------------------------------------------ */
var handleTooltip = function() {
	"use strict";
	$('[data-toggle=tooltip]').tooltip('hide');
};
var handlePopover = function() {
	"use strict";
	$('[data-toggle=popover]').popover('hide');
};


/* 04. Footer Scroll to Top Button Setting
------------------------------------------------ */
var handleScrollToTop = function() {
	"use strict";
	$('#scrollTop > a').click(function(e) {
		e.preventDefault();
		$('html, body').animate({
			scrollTop: $("body").offset().top
		}, 500);
	});
};


/* 05. Chart Plugins Setting
------------------------------------------------ */
var options = {
	height: '50px',
	width: '100%',
	fillColor: semiDark,
	lineWidth: 2,
	spotRadius: '4',
	highlightLineColor: blue,
	highlightSpotColor: blue,
	spotColor: false,
	minSpotColor: false,
	maxSpotColor: false
};
var handleSparkline = function() {
	"use strict";
	function renderSparkline() {
		var value = [50,30,45,40,50,20,35,40,50,70,90,40];
		options.type = 'line';
		options.lineColor = blue;
		$('#sparkline-line-chart').sparkline(value, options);
		
		options.type = 'bar';
		options.barColor = red;
		options.barWidth = 5;
		$('#sparkline-bar-chart').sparkline(value, options);
		
		value = [20,30,10,25];
		options.type = 'pie';
		options.width = 'auto';
		options.sliceColors = [red, blue, yellow, green];
		$('#sparkline-pie-chart').sparkline(value, options);
		
		value = [4,6,7,7,4,3,2,1,4,4,4,6,7,7,4,3,2,1,4,4];
		options.type = 'bullet';
		options.width = '100%';
		options.targetColor = red;
		options.performanceColor = green;
		options.rangeColors = [semiDark];
		$('#sparkline-bullet-chart').sparkline(value, options);
	}
	
	renderSparkline();
	
	$(window).on('resize', function() {
		renderSparkline();
	});
};

var handleDashboardSparkline = function() {
	"use strict";
	function renderDashboardSparkline() {
		var value = [50,30,45,40,50,20,35,40,50,70,90,40];
		options.type = 'line';
		options.height = '33px';
		options.lineColor = red;
		options.highlightLineColor = red;
		options.highlightSpotColor = red;
		$('#sparkline-unique-visitor').sparkline(value, options);
		options.lineColor = yellow;
		options.highlightLineColor = yellow;
		options.highlightSpotColor = yellow;
		$('#sparkline-bounce-rate').sparkline(value, options);
		options.lineColor = green;
		options.highlightLineColor = green;
		options.highlightSpotColor = green;
		$('#sparkline-total-page-views').sparkline(value, options);
		options.lineColor = blue;
		options.highlightLineColor = blue;
		options.highlightSpotColor = blue;
		$('#sparkline-avg-time-on-site').sparkline(value, options);
		options.lineColor = grey;
		options.highlightLineColor = grey;
		options.highlightSpotColor = grey;
		$('#sparkline-new-visits').sparkline(value, options);
	}
	
	renderDashboardSparkline();
	
	$(window).on('resize', function() {
		$('#sparkline-unique-visitor').empty();
		$('#sparkline-bounce-rate').empty();
		$('#sparkline-total-page-views').empty();
		$('#sparkline-avg-time-on-site').empty();
		$('#sparkline-new-visits').empty();
		renderDashboardSparkline();
	});
};
var handleInteractiveChart = function () {
	"use strict";
	var data1 = [ 
		[1196472800000, 30], [1197154800000, 44], [1197241200000, 55], [1197414000000, 71], [1197846000000, 65], [1197932400000, 87], [1198537200000, 67], [1198623600000, 90],
		[1199228400000, 110], [1199314800000, 130], [1199487600000, 100], [1199919600000, 105], [1200092400000, 110], [1200178800000, 120], [1200610800000, 130], [1200870000000, 135],
		[1201302000000, 145], [1201561200000, 132], [1201993200000, 123], [1202079600000, 135], [1202252400000, 150], [1202684400000, 145], [1202943600000, 133], [1203621200000, 145], 
	];
	var data2 = [
		[1196472800000, 5],  [1197241200000, 6], [1197414000000, 10], [1197846000000, 12], [1198018800000, 18], [1198537200000, 20], [1198796400000, 25], 
		[1199228400000, 23], [1199487600000, 24], [1199919600000, 25], [1200178800000, 18], [1200610800000, 30], [1200870000000, 25], [1201302000000, 25], [1201561200000, 30], 
		[1202079600000, 27], [1202252400000, 20], [1202684400000, 18], [1202943600000, 31], [1203462000000, 23], [1203621200000, 30]
	];
	$.plot($("#interactive-chart"), [
			{
				data: data1, 
				label: "Page Views", 
				color: green,
				lines: { show: true, fill:false },
				points: { show: false },
				shadowSize: 0
			},
			{
				data: data2, 
				label: "Unique Visitor", 
				color: blue,
				lines: { show: true, fill:false },
				points: { show: false },
				shadowSize: 0
			}
		], 
		{
			xaxis: { mode: "time",ticks:15, tickDecimals: 0, tickLength: 0  },
			yaxis: { ticks:5, tickDecimals: 0, min: 0, tickColor: 'rgba(0,0,0,0.2)' },
			grid: { 
				hoverable: true, 
				clickable: true,
				borderColor: 'rgba(0,0,0,0.2)',
				tickColor: "#ddd",
				borderWidth: 0
			},
			legend: {
				backgroundColor: 'rgba(0,0,0,0.2)',
				labelBoxBorderColor: 'none',
				margin: 10,
				noColumns: 2
			}
		}
	);
	var previousPoint = null;
	$("#interactive-chart").bind("plothover", function (event, pos, item) {
		$("#x").text(pos.x.toFixed(2));
		$("#y").text(pos.y.toFixed(2));
		if (item) {
			if (previousPoint !== item.dataIndex) {
				previousPoint = item.dataIndex;
				$("#tooltip").remove();
				var y = item.datapoint[1].toFixed(2);
				
				var content = item.series.label + " " + y;
				showTooltip(item.pageX, item.pageY, content);
			}
		}
		else {
			$("#tooltip").remove();
			previousPoint = null;            
		}
	});
	function showTooltip(x, y, contents) {
		$('<div id="tooltip">' + contents + '</div>').css( {
			position: 'absolute',
			display: 'none',
			top: y - 55,
			left: x - 55,
			border: 'none',
			padding: '10px',
			color:'#fff',
			'font-size':'12px',
			'background-color': '#000',
			opacity: 0.8
		}).appendTo("body").fadeIn(200);
	}
};
var handleBasicChart = function () {
	"use strict";
	var d1 = [];
	for (var x = 0; x < Math.PI * 2; x += 0.25) {
		d1.push([x, Math.sin(x)]);
	}
	var d2 = [];
	for (var y = 0; y < Math.PI * 2; y += 0.25) {
		d2.push([y, Math.cos(y)]);
	}
	var d3 = [];
	for (var z = 0; z < Math.PI * 2; z += 0.1) {
		d3.push([z, Math.tan(z)]);
	}
	$.plot($("#basic-chart"), [
		{ label: "data 1",  data: d1, color: yellow},
		{ label: "data 2",  data: d2, color: red},
		{ label: "data 3",  data: d3, color: green}
	], {
		series: {
			lines: { show: true },
			points: { show: false }
		},
		xaxis: {
			tickLength: 0
		},
		yaxis: {
			min: -2,
			max: 2,
			tickColor: 'rgba(0,0,0,0.2)'
		},
		grid: {
			borderColor: 'none',
			borderWidth: 0
		},
		legend: {
			labelBoxBorderColor: 'none',
			backgroundOpacity: 0.4,
			color:'#fff',
			show: false
		}	
	});
};
var handleLiveUpdatedChart = function () {
	"use strict";
	var data = [], totalPoints = 300;
	function getRandomData() {
		if (data.length > 0) {
			data = data.slice(1);
		}
		while (data.length < totalPoints) {
			var prev = data.length > 0 ? data[data.length - 1] : 50;
			var y = prev + Math.random() * 10 - 5;
			if (y < 0) {
				y = 0;
			}
			if (y > 100) {
				y = 100;
			}
			data.push(y);
		}
		var res = [];
		for (var i = 0; i < data.length; ++i) {
			res.push([i, data[i]]);
		}
		return res;
	}
	var updateInterval = 30;
	$("#updateInterval").val(updateInterval).change(function () {
		var v = $(this).val();
		if (v && !isNaN(+v)) {
			updateInterval = +v;
			if (updateInterval < 1) {
				updateInterval = 1;
			}
			if (updateInterval > 2000) {
				updateInterval = 2000;
			}
			$(this).val("" + updateInterval);
		}
	});
	var options = {
		series: { shadowSize: 0, color: red, lines: { show: true, fill:true } }, // drawing is faster without shadows
		yaxis: { min: 0, max: 100, tickColor: semiDark },
		xaxis: { show: false },
		grid: {
			borderColor: 'none',
			borderWidth: 0
		}
	};
	var plot = $.plot($("#live-updated-chart"), [ getRandomData() ], options);
	function update() {
		plot.setData([ getRandomData() ]);
		plot.draw();
		setTimeout(update, updateInterval);
	}
	update();
};
var handleStackedChart = function () {
	"use strict";
	var d1 = [];
	for (var x = 0; x <= 10; x += 1) {
		d1.push([x, Math.random() * 30]);
	}
	var d2 = [];
	for (var y = 0; y <= 10; y += 1) {
		d2.push([y, Math.random() * 30]);
	}
	var d3 = [];
	for (var z = 0; z <= 10; z += 1) {
		d3.push([z, Math.random() * 30]);
	}
	var stack = 0, bars = true, lines = false, steps = false;
	
	function plotWithOptions() {
		$.plot($("#stacked-chart"), [ {data:d1, color: red},{data:d2, color: green},{data:d3, color: blue}], {
			series: {
				stack: stack,
				lines: { show: lines, fill: true, steps: steps },
				bars: { show: bars, barWidth: 0.5 }
			},
			yaxis: {
				tickColor: semiDark
			},
			grid: {
				borderColor: 'none',
				borderWidth: 0
			}
		});
	}

	plotWithOptions();
	
	$(".stackControls input").click(function (e) {
		e.preventDefault();
		stack = $(this).val() === "With stacking" ? true : null;
		plotWithOptions();
	});
	$(".graphControls input").click(function (e) {
		e.preventDefault();
		bars = $(this).val().indexOf("Bars") !== -1;
		lines = $(this).val().indexOf("Lines") !== -1;
		steps = $(this).val().indexOf("steps") !== -1;
		plotWithOptions();
	});
};
var handleTrackingChart = function () {
	"use strict";
	var sin = [], cos = [];
	for (var i = 0; i < 14; i += 0.1) {
		sin.push([i, Math.sin(i)]);
		cos.push([i, Math.cos(i)]);
	}

	var plot = $.plot($("#tracking-chart"),
	[ 
		{ data: sin, label: "sin(x) = -0.00", color: '#618fb0'},
		{ data: cos, label: "cos(x) = -0.00", color: '#333'} 
	], 
	{
		series: {
			lines: { show: true }
		},
		crosshair: { mode: "x" },
		grid: { hoverable: true, autoHighlight: false, borderColor: 'none', borderWidth: 0 },
		xaxis: { tickLength: 0 },
		yaxis: { min: -1.2, max: 1.2, tickColor: 'rgba(0,0,0,0.2)' },
		legend: {
			labelBoxBorderColor: 'none',
			backgroundOpacity: 0.4,
			color:'#fff',
			show: false
		}
	});
	var legends = $("#tracking-chart .legendLabel");
	legends.each(function () {
		$(this).css('width', $(this).width());
	});

	var updateLegendTimeout = null;
	var latestPosition = null;
	
	function updateLegend() {
		updateLegendTimeout = null;
		
		var pos = latestPosition;
		
		var axes = plot.getAxes();
		if (pos.x < axes.xaxis.min || pos.x > axes.xaxis.max ||
			pos.y < axes.yaxis.min || pos.y > axes.yaxis.max) {
			return;
		}
		var i, j, dataset = plot.getData();
		for (i = 0; i < dataset.length; ++i) {
			var series = dataset[i];

			for (j = 0; j < series.data.length; ++j) {
				if (series.data[j][0] > pos.x) {
					break;
				}
			}
			
			var y, p1 = series.data[j - 1], p2 = series.data[j];
			if (p1 === null) {
				y = p2[1];
			} else if (p2 === null) {
				y = p1[1];
			} else {
				y = p1[1] + (p2[1] - p1[1]) * (pos.x - p1[0]) / (p2[0] - p1[0]);
			}

			legends.eq(i).text(series.label.replace(/=.*/, "= " + y.toFixed(2)));
		}
	}
	
	$("#tracking-chart").bind("plothover",  function (event, pos) {
		latestPosition = pos;
		if (!updateLegendTimeout) {
			updateLegendTimeout = setTimeout(updateLegend, 50);
		}
	});
};
var handleBarChart = function () {
	"use strict";
	var data = [ ["January", 10], ["February", 8], ["March", 4], ["April", 13], ["May", 17], ["June", 9] ];
	$.plot("#bar-chart", [ {data: data, color: blue} ], {
		series: {
			bars: {
				show: true,
				barWidth: 0.6,
				align: "center"
			}
		},
		xaxis: {
			mode: "categories",
			tickLength: 0
		},
		yaxis: {
			tickColor: semiDark
		},
		grid: {
			borderColor: 'none',
			borderWidth: 0
		}
	});
};
var handleInteractivePieChart = function () {
	"use strict";
	var data = [];
	var series = 5;
	var colorArray = [red, yellow, green, blue, dark];
	for( var i = 0; i<series; i++)
	{
		data[i] = { label: "Series"+(i+1), data: Math.floor(Math.random()*100)+1, color: colorArray[i]};
	}
	$.plot($("#interactive-pie-chart"), data,
	{
		series: {
			pie: { 
				show: true
			}
		},
		grid: {
			hoverable: true,
			clickable: true
		},
		legend: {
			backgroundColor: semiDark,
			labelBoxBorderColor: 'none'
		}
	});
};
var handleDonutChart = function () {
	"use strict";
	var data = [];
	var series = 5;
	var colorArray = [red, yellow, green, blue, dark];
	for( var i = 0; i<series; i++)
	{
		data[i] = { label: "Series"+(i+1), data: Math.floor(Math.random()*100)+1, color: colorArray[i] };
	}
	
	$.plot($("#donut-chart"), data, 
	{
		series: {
			pie: { 
				innerRadius: 0.5,
				show: true
			}
		},
		grid:{borderWidth:0},
		legend: {
			backgroundColor: semiDark,
			labelBoxBorderColor: 'none'
		}
	});
};


/* 06. Calendar Setting
------------------------------------------------ */
function renderCalendar(headerButton) {
	"use strict";
	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();
	
	var calendar = $('#calendar').fullCalendar({
		header: headerButton,
		selectable: true,
		selectHelper: true,
		select: function(start, end, allDay) {
			var title = prompt('Event Title:');
			if (title) {
				calendar.fullCalendar('renderEvent',
					{
						title: title,
						start: start,
						end: end,
						allDay: allDay
					},
					true // make the event "stick"
				);
			}
			calendar.fullCalendar('unselect');
		},
		editable: true,
		events: [
			{
				title: 'Event',
				start: new Date(y, m, 1)
			},
			{
				title: 'Meeting',
				start: new Date(y, m, d, 10, 30),
				allDay: false
			},
			{
				title: 'Click for Google',
				start: new Date(y, m, 28),
				end: new Date(y, m, 29),
				url: 'http://google.com/'
			}
		]
	});
}
var handleDashboardCalendar = function () {
	"use strict";
	var buttonSetting = {left: '', center: 'title', right: ' today prev,next'};
	renderCalendar(buttonSetting);
};
var handleCalendarDemo = function () {
	"use strict";
	var buttonSetting = {left: '', center: 'title', right: ' today prev,next month,agendaWeek,agendaDay'};
	renderCalendar(buttonSetting);
};


/* 07. Vector Map Setting
------------------------------------------------ */
var handleDashboardVectorMap = function() {
	"use strict";
	$('#vmap').vectorMap({
		map: 'world_en',
		backgroundColor: 'none',
		color: '#e3a21a',
		hoverOpacity: 0.7,
		selectedColor: '#000000',
		enableZoom: true,
		showTooltip: true,
		scaleColors: ['#cccccc', '#000000'],
		normalizeFunction: 'polynomial'
	});
	$('[data-map]').on('click', function(e) {
		e.preventDefault();
		var mapArea = $(this).attr('data-map');
		$('#vmap').empty();
		$('#vmap').vectorMap({
			map: mapArea,
			backgroundColor: 'none',
			color: '#e3a21a',
			hoverOpacity: 0.7,
			selectedColor: '#000000',
			enableZoom: true,
			showTooltip: true,
			scaleColors: ['#cccccc', '#000000'],
			normalizeFunction: 'polynomial'
		});
	});
};
var handleVectorMapExample = function () {
	"use strict";
	/*global sample_data */
	$('#world').vectorMap({
		map: 'world_en',
		backgroundColor: 'none',
		color: '#333333',
		hoverOpacity: 0.7,
		selectedColor: '#000000',
		enableZoom: true,
		showTooltip: true,
		values: sample_data,
		scaleColors: ['#cccccc', '#000000'],
		normalizeFunction: 'polynomial'
	});
	$('#germany').vectorMap({
		map: 'germany_en',
		backgroundColor: 'none',
		color: '#333333',
		hoverOpacity: 0.7,
		selectedColor: '#0088cc',
		enableZoom: true,
		showTooltip: true,
		values: sample_data,
		scaleColors: ['#0088cc', '#000000'],
		normalizeFunction: 'polynomial'
	});
	$('#usa').vectorMap({
		map: 'usa_en',
		backgroundColor: 'none',
		color: '#333333',
		hoverOpacity: 0.7,
		selectedColor: '#990000',
		enableZoom: true,
		showTooltip: true,
		values: sample_data,
		scaleColors: ['#990000', '#000000'],
		normalizeFunction: 'polynomial'
	});
	$('#russia').vectorMap({
		map: 'russia_en',
		backgroundColor: 'none',
		color: '#333333',
		hoverOpacity: 0.7,
		selectedColor: '#faa732',
		enableZoom: true,
		showTooltip: true,
		values: sample_data,
		scaleColors: ['#faa732', '#000000'],
		normalizeFunction: 'polynomial'
	});
	$('#europe').vectorMap({
		map: 'europe_en',
		backgroundColor: 'none',
		color: '#333333',
		hoverOpacity: 0.7,
		selectedColor: '#5bb75b',
		enableZoom: true,
		showTooltip: true,
		values: sample_data,
		scaleColors: ['#5bb75b', '#000000'],
		normalizeFunction: 'polynomial'
	});
};
var handleGoogleMapSetting = function() {
	"use strict";
	var map;
	function initialize() {
		/*global google */
		var mapOptions = {
			zoom: 8,
			center: new google.maps.LatLng(-34.397, 150.644),
			mapTypeId: google.maps.MapTypeId.ROADMAP
		};
		map = new google.maps.Map(document.getElementById('google-map'), mapOptions);
	}
	google.maps.event.addDomListener(window, 'load', initialize);
};


/* 08. Gritter Notification Setting
------------------------------------------------ */
var handleGritter = function() {
	"use strict";
	$('#add-sticky').click( function() {
		$.gritter.add({
			title: 'This is a sticky notice!',
			text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tempus lacus ut lectus rutrum placerat. ',
			image: 'assets/img/envato/nature/scottwills_enchantedcreek.jpg',
			sticky: true,
			time: '',
			class_name: 'my-sticky-class'
		});
		return false;
	});
	$('#add-regular').click( function() {
		$.gritter.add({
			title: 'This is a regular notice!',
			text: 'This will fade out after a certain amount of time. Sed tempus lacus ut lectus rutrum placerat. ',
			image: 'assets/img/envato/nature/scottwills_enchantedcreek.jpg',
			sticky: false,
			time: ''
		});
		return false;
	});
	$('#add-max').click( function() {
		$.gritter.add({
			title: 'This is a notice with a max of 3 on screen at one time!',
			text: 'This will fade out after a certain amount of time. Sed tempus lacus ut lectus rutrum placerat. ',
			image: 'assets/img/envato/nature/scottwills_mossytree.jpg',
			sticky: false,
			before_open: function() {
				if($('.gritter-item-wrapper').length === 3) {
					return false;
				}
			}
		});
		return false;
	});
	$('#add-without-image').click(function(){
		$.gritter.add({
			title: 'This is a notice without an image!',
			text: 'This will fade out after a certain amount of time.'
		});
		return false;
	});
	$('#add-gritter-light').click(function(){
		$.gritter.add({
			title: 'This is a light notification',
			text: 'Just add a "gritter-light" class_name to your $.gritter.add or globally to $.gritter.options.class_name',
			class_name: 'gritter-light'
		});
		return false;
	});
	$('#add-with-callbacks').click(function(){
		$.gritter.add({
			title: 'This is a notice with callbacks!',
			text: 'The callback is...',
			before_open: function(){
				alert('I am called before it opens');
			},
			after_open: function(e){
				alert("I am called after it opens: \nI am passed the jQuery object for the created Gritter element...\n" + e);
			},
			before_close: function(e, manual_close){
				var manually = (manual_close) ? 'The "X" was clicked to close me!' : '';
				alert("I am called before it closes: I am passed the jQuery object for the Gritter element... \n" + manually);
			},
			after_close: function(e, manual_close){
				var manually = (manual_close) ? 'The "X" was clicked to close me!' : '';
				alert('I am called after it closes. ' + manually);
			}
		});
		return false;
	});
	$('#add-sticky-with-callbacks').click(function(){
		$.gritter.add({
			title: 'This is a sticky notice with callbacks!',
			text: 'Sticky sticky notice.. sticky sticky notice...',
			sticky: true,
			before_open: function(){
				alert('I am a sticky called before it opens');
			},
			after_open: function(e){
				alert("I am a sticky called after it opens: \nI am passed the jQuery object for the created Gritter element...\n" + e);
			},
			before_close: function(e){
				alert("I am a sticky called before it closes: I am passed the jQuery object for the Gritter element... \n" + e);
			},
			after_close: function(){
				alert('I am a sticky called after it closes');
			}
		});
		return false;
	});
	$("#remove-all").click(function(){
		$.gritter.removeAll();
		return false;
	});
	$("#remove-all-with-callbacks").click(function(){
		$.gritter.removeAll({
			before_close: function(e){
				alert("I am called before all notifications are closed.  I am passed the jQuery object containing all  of Gritter notifications.\n" + e);
			},
			after_close: function(){
				alert('I am called after everything has been closed.');
			}
		});
		return false;
	});
};
var handleDashboardNotification = function() {
	"use strict";
	setTimeout(function() {
		$.gritter.add({
			title: '<i class="icon-exclamation-sign text-info"></i> This is a sticky notice!',
			text: 'Lorem ipsum dolor sit amet, consectetur elit adipiscing. Sed tempus lacus ut lectus rutrum placerat.',
			sticky: true,
			time: '',
			class_name: 'my-sticky-class'
		});
	}, 3000);
	
	return false;
};


/* 09. Form Plugins Setting
------------------------------------------------ */
var handleFormMaskedInput = function() {
	"use strict";
	$("#date").mask("99/99/9999");
	$("#phone").mask("(999) 999-9999");
	$("#tid").mask("99-9999999");
	$("#ssn").mask("999-99-9999");
	$("#pno").mask("aaa-9999-a");
	$("#pkey").mask("a*-999-a999");
};
var handleFormColorPicker = function () {
	"use strict";
	$('#colorpicker').colorpicker({format: 'hex'});
	$('#colorpicker-prepend').colorpicker({format: 'hex'});
	$('#colorpicker-rgba').colorpicker();
};
var handleFormDatePicker = function () {
	"use strict";
	$('#date-picker').datepicker();
	$('#date-picker-disabled').datepicker();
};
var handleFormTimePicker = function () {
	"use strict";
	$('#timepicker1').timepicker();
};
var handleFormPasswordStrenthIndicator = function() {
	"use strict";
	$('input[name="password"]').passwordStrength();
	$('input[name="password-visible"]').passwordStrength({targetDiv: '#passwordStrengthDiv2'});
};
var handleFormComboBox = function() {
	"use strict";
	$('.combobox').combobox();
};
var handleFormSelectWithSearch = function() {
	"use strict";
	$("#select-box").select2();
};
var handleFormDualListBox = function() {
	"use strict";
	$('.bootstrap-dual-list').bootstrapDualListbox();
};
var handleBootstrapWizards = function() {
	"use strict";
	$("#wizard").bwizard();
};
var handleFormWysihtml5 = function () {
	"use strict";
	$('#wysihtml5').wysihtml5();
};


/* 10. Isotopes Setting
------------------------------------------------ */
var handleIsotopesGallery = function() {
	"use strict";
	$(window).load(function(){
		var $container = $('#gallery');
		$container.isotope({
			resizable: false,
			masonry: {
				columnWidth: $container.width() / 5
			}
		});
		
		$(window).smartresize(function(){
			$container.isotope({
				masonry: { columnWidth: $container.width() / 5 }
			});
		});
		
		var $optionSets = $('#options .option-set'),
		$optionLinks = $optionSets.find('a');
		
		$optionLinks.click( function(){
			var $this = $(this);
			if ( $this.hasClass('active') ) {
				return false;
			}
			var $optionSet = $this.parents('.option-set');
			$optionSet.find('.active').removeClass('active');
			$this.addClass('active');
		
			var options = {},
			key = $optionSet.attr('data-option-key'),
			value = $this.attr('data-option-value');
			value = value === 'false' ? false : value;
			options[ key ] = value;
			$container.isotope( options );
			return false;
		});
	});
};


/* 11. Application Controller
------------------------------------------------ */
var App = function () {
	"use strict";
	var currentPage = '';
	
	return {
		//main function to initiate template pages
		init: function () {
			//global handlers
			handleSidebarMenu();
			handleSlimScroll();
			handleTooltip();
			handlePopover();
			handleScrollToTop();
			
			if (App.isPage('index')) {
				handleDashboardSparkline();
				handleDashboardVectorMap();
				handleDashboardCalendar();
				handleDashboardNotification();
				handleInteractiveChart();
				handleIsotopesGallery();
            }
			if (App.isPage('form-plugins')) {
				handleFormMaskedInput();
				handleFormColorPicker();
				handleFormDatePicker();
				handleFormTimePicker();
				handleFormPasswordStrenthIndicator();
				handleFormComboBox();
				handleFormSelectWithSearch();
				handleFormDualListBox();
			}
			if (App.isPage('ui-modal-notification')) {
				handleGritter();
			}
			if (App.isPage('form-wizards')) {
				handleBootstrapWizards();
			}
			if (App.isPage('form-wysiwyg')) {
				handleFormWysihtml5();
			}
			if (App.isPage('table-manage')) {
				handleFormWysihtml5();
			}
			if (App.isPage('charts')) {
				handleSparkline();
				handleInteractiveChart();
				handleBasicChart();
				handleLiveUpdatedChart();
				handleStackedChart();
				handleTrackingChart();
				handleBarChart();
				handleInteractivePieChart();
				handleDonutChart();
			}
			if (App.isPage('calendar')) {
				handleCalendarDemo();
			}
			if (App.isPage('maps')) {
				handleVectorMapExample();
				handleGoogleMapSetting();
			}
			if (App.isPage('gallery')) {
				handleIsotopesGallery();
			}
			if (App.isPage('user-profile')) {
				handleFormDatePicker();
			}
		},
        
        // Set Current Page
        setPage: function (name) {
			currentPage = name;
        },
        
        // Check Current Page
        isPage: function (name) {
			return currentPage === name ? true : false;
        }
    };
}();