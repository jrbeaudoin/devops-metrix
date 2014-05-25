angular.module('metrix.dashboard')

.directive 'metrixErrorLineChart', ($rootScope) ->
  template: "<svg></svg>"
  link: ($scope, $element) ->
    parseDate = d3.time.format("%d-%b-%y").parse

    margin = {top: 0, right: -30, bottom: 30, left: 0}
    height = $element[0].offsetHeight
    width = $element[0].offsetWidth

    svg = d3.select($element[0]).select("svg")
    defs = svg.append 'svg:defs'
    svg.attr("width", width).attr("height", height).append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    x = d3.time.scale()
    .range([0, width])

    y = d3.scale.linear()
    .range([height, 0])

    xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom")

    yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")

    line = d3.svg.line()
    .x( (d) -> x(d.date) )
    .y((d) -> y(d.value))

    $rootScope.$watch "currentProject", (newVal) ->
      if newVal?

        data = newVal.errors

        data.forEach( (d) ->
          d.date = parseDate(d.date)
        )

        x.domain(d3.extent(data, (d) ->
          d.date
        ))
        y.domain(d3.extent(data, (d) ->
          d.value
        ))

        svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis)

        svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Error rate (%)");

        svg.append("path")
        .datum(data)
        .attr("class", "line")
        .attr("d", line)
