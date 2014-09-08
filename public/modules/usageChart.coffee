angular.module 'anthTrigger'
.directive 'uchart', ->

  {
    restrict: 'EA'
    scope: {
      amData: '='
    }

    link: (scope, elem, attrs)->

      chart = new AmCharts.AmSerialChart()

      AmCharts.makeChart(elem[0], {
        "type": "serial",
        "pathToImages": "http://cdn.amcharts.com/lib/3/images/",
        "categoryField": "date",
        "dataDateFormat": "YYYY-MM-DD",
        "gridAboveGraphs": true,
        "theme": "default",
        "categoryAxis": {
          "parseDates": true,
          "gridAlpha": 0.1,
        },
        "chartCursor": {
          "bulletsEnabled": true,
          "categoryBalloonAlpha": 0.66,
          "categoryBalloonDateFormat": "YYYY-MM-DD",
          "pan": true,
        },
        "trendLines": [],
        "graphs": [
          {
            "fillAlphas": 0.7,
            "id": "AmGraph-2",
            "lineAlpha": 0,
            "title": "graph 2",
            "type": "smoothedLine",
            "valueField": "count"
          }
        ],
        "guides": [],
        "valueAxes": [],
        "allLabels": [],
        "balloon": {},
        dataProvider: scope.amData
      })

      scope.$watch 'amData', (v)->
        return if not v
        chart.validateNow()

  }

