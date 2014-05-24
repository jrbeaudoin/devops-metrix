angular.module('metrix.dashboard')

.directive 'metrixProjectsBubbles', ($rootScope) ->
  template: "<svg></svg>"
  link: ($scope, $element) ->
    getMaxFromNodes = (data, valueName = "value") ->
      maxValue = -Infinity
      for node in data
        maxValue = Math.max(maxValue, node.commits)
      return maxValue
    getScaleFactor = (data) ->
      # Get max value
      maxValue = getMaxFromNodes data
      # Create scaleFactor that will ensure circles will fit in the window
      return 5 * Math.sqrt(maxValue) / Math.min(window.innerWidth, window.innerHeight)

    node = []
    height = $element[0].offsetHeight
    width = $element[0].offsetWidth
    repulsion = 3000

    svg = d3.select($element[0]).select("svg")
    svg.attr("width", width).attr("height", height)
    force = d3.layout.force().gravity(0.5).friction(.1).size([
      width
      height
    ])

    update = (chartData) ->
      coords = []
      node.each (d) ->
        coords.push
          x: d.x
          y: d.y
        d.fixed = true

      #scaleFactor = getScaleFactor chartData
      scaleFactor = 100
      force.charge((d) ->
        - (d.commits / scaleFactor) * repulsion
      ).nodes(chartData)

      node.data(chartData).enter()
      node.data(chartData).exit().remove()
      circle.data(chartData)
      projectName.data(chartData)

      circle
      .transition().ease("cubic-in-out")
      .attr("r", (d) ->
        d.commits / scaleFactor
      )
      .style("fill", "gray")

      projectName.text (d) ->
        d.name

      node.each((d, i) ->
        d.fixed = false
        d.x = coords[i].x
        d.y = coords[i].y
      )
      force.start()

    chartData = $rootScope.projects

    force.chargeDistance(500)
    node = svg
    .selectAll(".node")
    .data(chartData)
    .enter()
    .append("g")
    .attr("class", "node")
    .call(force.drag)

    circle = node.append("circle")
    projectName = node
    .append("text")
    .attr("dy", "0em")
    .attr("x", 0)
    .attr("y", 0)

    update chartData

    force.on "tick", (e) ->
      node.attr "transform", (d) ->
        "translate(" + d.x + "," + d.y + ")"
