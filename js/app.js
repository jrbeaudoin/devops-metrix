angular.module('devops-metrix', ['ng', 'ngRoute', 'metrix.dashboard', 'metrix.project', 'metrix.help']).config([
  '$routeProvider', '$httpProvider', '$compileProvider', function($routeProvider, $httpProvider, $compileProvider) {
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(mailto|tel|http|https):/);
    $routeProvider.otherwise({
      redirectTo: '/dashboard'
    });
    return delete $httpProvider.defaults.headers.common['X-Requested-With'];
  }
]).run(function(dataGenerator) {
  return dataGenerator();
}).factory('dataGenerator', function($interval, $rootScope, randomNames) {
  return function() {
    var computeScore, createData, projects, randomGauss, randomGaussInt, randomInt, rnd_snd, updateData;
    rnd_snd = function() {
      return (Math.random() * 2 - 1) + (Math.random() * 2 - 1) + (Math.random() * 2 - 1);
    };
    randomInt = function(min, max) {
      return parseInt(Math.random() * (max - min) + min);
    };
    randomGauss = function(mean, stdev) {
      return rnd_snd() * stdev + mean;
    };
    randomGaussInt = function(mean, stdev) {
      return Math.round(randomGauss(mean, stdev));
    };
    $rootScope.projects = [];
    projects = $rootScope.projects;
    computeScore = function(project) {
      var score, timeSinceLastDeployed, weekInSeconds;
      score = 0;
      timeSinceLastDeployed = new Date() - project.deployedOn;
      weekInSeconds = 1000 * 5;
      switch (false) {
        case !(timeSinceLastDeployed < weekInSeconds):
          score = score + 5;
          break;
        case !(timeSinceLastDeployed < 2 * weekInSeconds):
          score = score + 4;
          break;
        case !(timeSinceLastDeployed < 3 * weekInSeconds):
          score = score + 3;
          break;
        case !(timeSinceLastDeployed < 4 * weekInSeconds):
          score = score + 2;
          break;
        case !(timeSinceLastDeployed < 6 * 4 * weekInSeconds):
          score = score + 1;
      }
      if (project.ci) {
        score = score + 2;
      }
      if (project.ci && project.ciStatus) {
        score = score + 1;
      }
      switch (false) {
        case !(project.coverage > 2 / 3):
          score = score + 2;
          break;
        case !(project.coverage > 1 / 3):
          score = score + 1;
      }
      return score;
    };
    createData = function() {
      var errors, i, project, visits, _i, _j, _len, _results;
      visits = [
        {
          "date": "1-May-14",
          "value": 582.13
        }, {
          "date": "30-Apr-14",
          "value": 583.98
        }, {
          "date": "27-Apr-14",
          "value": 603.00
        }, {
          "date": "26-Apr-14",
          "value": 607.70
        }, {
          "date": "25-Apr-14",
          "value": 610.00
        }, {
          "date": "24-Apr-14",
          "value": 560.28
        }, {
          "date": "23-Apr-14",
          "value": 571.70
        }, {
          "date": "20-Apr-14",
          "value": 572.98
        }, {
          "date": "19-Apr-14",
          "value": 587.44
        }, {
          "date": "18-Apr-14",
          "value": 608.34
        }, {
          "date": "17-Apr-14",
          "value": 609.70
        }, {
          "date": "16-Apr-14",
          "value": 580.13
        }, {
          "date": "13-Apr-14",
          "value": 605.23
        }, {
          "date": "12-Apr-14",
          "value": 622.77
        }, {
          "date": "11-Apr-14",
          "value": 626.20
        }, {
          "date": "10-Apr-14",
          "value": 628.44
        }, {
          "date": "9-Apr-14",
          "value": 636.23
        }, {
          "date": "5-Apr-14",
          "value": 633.68
        }, {
          "date": "4-Apr-14",
          "value": 624.31
        }, {
          "date": "3-Apr-14",
          "value": 629.32
        }, {
          "date": "2-Apr-14",
          "value": 618.63
        }, {
          "date": "30-Mar-14",
          "value": 599.55
        }, {
          "date": "29-Mar-14",
          "value": 609.86
        }, {
          "date": "28-Mar-14",
          "value": 617.62
        }, {
          "date": "27-Mar-14",
          "value": 614.48
        }, {
          "date": "26-Mar-14",
          "value": 606.98
        }, {
          "date": "23-Mar-14",
          "value": 596.05
        }, {
          "date": "22-Mar-14",
          "value": 599.34
        }, {
          "date": "21-Mar-14",
          "value": 602.50
        }
      ];
      errors = [
        {
          "date": "1-May-14",
          "value": .13
        }, {
          "date": "30-Apr-14",
          "value": .98
        }, {
          "date": "27-Apr-14",
          "value": .00
        }, {
          "date": "26-Apr-14",
          "value": .70
        }, {
          "date": "25-Apr-14",
          "value": .00
        }, {
          "date": "24-Apr-14",
          "value": .28
        }, {
          "date": "23-Apr-14",
          "value": .70
        }, {
          "date": "20-Apr-14",
          "value": .98
        }, {
          "date": "19-Apr-14",
          "value": .44
        }, {
          "date": "18-Apr-14",
          "value": .34
        }, {
          "date": "17-Apr-14",
          "value": 1.70
        }, {
          "date": "16-Apr-14",
          "value": 3.13
        }, {
          "date": "13-Apr-14",
          "value": 4.23
        }, {
          "date": "12-Apr-14",
          "value": .77
        }, {
          "date": "11-Apr-14",
          "value": .20
        }, {
          "date": "10-Apr-14",
          "value": .44
        }, {
          "date": "9-Apr-14",
          "value": .23
        }, {
          "date": "5-Apr-14",
          "value": .68
        }, {
          "date": "4-Apr-14",
          "value": .31
        }, {
          "date": "3-Apr-14",
          "value": .32
        }, {
          "date": "2-Apr-14",
          "value": .63
        }, {
          "date": "30-Mar-14",
          "value": .55
        }, {
          "date": "29-Mar-14",
          "value": .86
        }, {
          "date": "28-Mar-14",
          "value": .62
        }, {
          "date": "27-Mar-14",
          "value": .48
        }, {
          "date": "26-Mar-14",
          "value": .98
        }, {
          "date": "23-Mar-14",
          "value": .05
        }, {
          "date": "22-Mar-14",
          "value": .34
        }, {
          "date": "21-Mar-14",
          "value": .50
        }
      ];
      for (i = _i = 0; _i <= 10; i = ++_i) {
        projects.push({
          "id": i,
          "name": randomNames[i],
          "contributors": randomGaussInt(8, 3),
          "commits": randomInt(200, 10000),
          "deployedOn": new Date(),
          "ci": Math.random() > 0.1,
          "ciStatus": !(i % 4 === 0),
          "coverage": Math.min(Math.max(0, randomGauss(0.5, 0.4)), 1),
          "online": true,
          "visits": visits,
          "errors": errors
        });
      }
      _results = [];
      for (_j = 0, _len = projects.length; _j < _len; _j++) {
        project = projects[_j];
        _results.push(project.score = computeScore(project));
      }
      return _results;
    };
    createData();
    updateData = function() {
      var project, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = projects.length; _i < _len; _i++) {
        project = projects[_i];
        project.updated = false;
        if (Math.random() > 0.99) {
          project.commits += 1;
          if (Math.random() > 0.7) {
            project.ciStatus = Math.random() > 0.5;
          }
          project.coverage = Math.min(Math.max(0, project.coverage + randomGauss(0, 0.05)), 1);
          project.updated = true;
        }
        if (Math.random() > 0.995) {
          project.deployedOn = new Date();
          project.updated = true;
        }
        if (project.updated) {
          if (Math.random() > 0.4 && !project.online) {
            project.online = true;
          }
          if (Math.random() > 0.93 && project.online) {
            project.online = false;
          }
        }
        _results.push(project.score = computeScore(project));
      }
      return _results;
    };
    return $interval(function() {
      return updateData();
    }, 100);
  };
}).constant('randomNames', ["Venice", "Marjory", "Jeannine", "Anjanette", "Sharice", "Charlette", "Sanora", "Michaela", "Adrienne", "Lorie", "Arnette", "Hien", "Sima", "Drema", "Shakita", "Amie", "Josephine", "Christiana", "Cecil", "Simonne", "Brinda", "Jaime", "Elenore", "Larita", "Robert", "Nichelle", "Merrill", "Kerrie", "Milagros", "Shawanna", "Reginia", "Linette", "Reda", "Thaddeus", "Silas", "Edris", "Belen", "Valorie", "Artie", "Mariela", "Alonzo", "Laurice", "Lyndia", "Emilie", "Vada", "Pearlene", "Maura", "Love", "Lanita", "Kasha"]);

angular.module('metrix.dashboard', ['ng', 'ngRoute']);

angular.module('metrix.help', ['ng']);

angular.module('metrix.project', ['ng', 'ngRoute']);

angular.module('metrix.dashboard').config([
  '$routeProvider', function($routeProvider) {
    return $routeProvider.when('/dashboard', {
      controller: 'dashboardController',
      templateUrl: 'dashboard/view/dashboard-view.html'
    });
  }
]);

angular.module('metrix.dashboard').controller('dashboardController', function($scope) {});

angular.module('metrix.dashboard').directive('metrixErrorLineChart', function($rootScope) {
  return {
    template: "<svg></svg>",
    link: function($scope, $element) {
      var defs, height, line, margin, parseDate, svg, width, x, xAxis, y, yAxis;
      parseDate = d3.time.format("%d-%b-%y").parse;
      margin = {
        top: 0,
        right: -30,
        bottom: 30,
        left: 0
      };
      height = $element[0].offsetHeight;
      width = $element[0].offsetWidth;
      svg = d3.select($element[0]).select("svg");
      defs = svg.append('svg:defs');
      svg.attr("width", width).attr("height", height).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
      x = d3.time.scale().range([0, width]);
      y = d3.scale.linear().range([height, 0]);
      xAxis = d3.svg.axis().scale(x).orient("bottom");
      yAxis = d3.svg.axis().scale(y).orient("left");
      line = d3.svg.line().x(function(d) {
        return x(d.date);
      }).y(function(d) {
        return y(d.value);
      });
      return $rootScope.$watch("currentProject", function(newVal) {
        var data;
        if (newVal != null) {
          data = newVal.errors;
          data.forEach(function(d) {
            return d.date = parseDate(d.date);
          });
          x.domain(d3.extent(data, function(d) {
            return d.date;
          }));
          y.domain(d3.extent(data, function(d) {
            return d.value;
          }));
          svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis);
          svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text("Error rate (%)");
          return svg.append("path").datum(data).attr("class", "line").attr("d", line);
        }
      });
    }
  };
});

angular.module('metrix.dashboard').directive('metrixLineChart', function($rootScope) {
  return {
    template: "<svg></svg>",
    link: function($scope, $element) {
      var defs, height, line, margin, parseDate, svg, width, x, xAxis, y, yAxis;
      parseDate = d3.time.format("%d-%b-%y").parse;
      margin = {
        top: 0,
        right: -30,
        bottom: 30,
        left: 0
      };
      height = $element[0].offsetHeight;
      width = $element[0].offsetWidth;
      svg = d3.select($element[0]).select("svg");
      defs = svg.append('svg:defs');
      svg.attr("width", width).attr("height", height).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
      x = d3.time.scale().range([0, width]);
      y = d3.scale.linear().range([height, 0]);
      xAxis = d3.svg.axis().scale(x).orient("bottom");
      yAxis = d3.svg.axis().scale(y).orient("left");
      line = d3.svg.line().x(function(d) {
        return x(d.date);
      }).y(function(d) {
        return y(d.value);
      });
      return $rootScope.$watch("currentProject", function(newVal) {
        var data;
        if (newVal != null) {
          data = newVal.visits;
          data.forEach(function(d) {
            return d.date = parseDate(d.date);
          });
          x.domain(d3.extent(data, function(d) {
            return d.date;
          }));
          y.domain(d3.extent(data, function(d) {
            return d.value;
          }));
          svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis);
          svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text("Visits");
          return svg.append("path").datum(data).attr("class", "line").attr("d", line);
        }
      });
    }
  };
});

angular.module('metrix.dashboard').directive('metrixProjectsBubbles', function($rootScope) {
  return {
    template: "<svg></svg>",
    link: function($scope, $element) {
      var bubbleBgColor, bubbleColor, bubbleFillLevel, bubbleId, bubbleName, bubbleOpacity, bubbleScore, bubbleSize, chartData, circle, circlesContainer, defs, fillCircle, force, getMaxFromNodes, getScaleFactor, gradient, height, node, nodeClick, projectName, projectScore, projetName, repulsion, svg, svgClick, update, width;
      bubbleId = function(node) {
        return node.id;
      };
      bubbleName = function(node) {
        return node.name;
      };
      bubbleScore = function(node) {
        return node.score;
      };
      bubbleSize = function(node) {
        return Math.sqrt(node.commits);
      };
      bubbleColor = function(node) {
        switch (node.ciStatus) {
          case true:
            return 'rgb(20,231,134)';
          case false:
            return 'rgb(236,24,75)';
        }
      };
      bubbleFillLevel = function(node) {
        switch (node.ci) {
          case true:
            return node.coverage;
          case false:
            return 0;
        }
      };
      bubbleBgColor = function(node) {
        return 'lightgray';
      };
      bubbleOpacity = function(node) {
        var maxAgeWithoutDeploy, now;
        now = new Date();
        maxAgeWithoutDeploy = 1000 * 30;
        return 1 - 0.8 * Math.min((now - node.deployedOn) / maxAgeWithoutDeploy, 1);
      };
      getMaxFromNodes = function(data) {
        var maxValue, node, _i, _len;
        maxValue = -Infinity;
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          node = data[_i];
          maxValue = Math.max(maxValue, bubbleSize(node));
        }
        return maxValue;
      };
      getScaleFactor = function(data) {
        var maxValue;
        maxValue = getMaxFromNodes(data);
        return maxValue / Math.min($('[metrix-projects-bubbles]').width(), $('[metrix-projects-bubbles]').height()) * Math.sqrt(data.length) * 4;
      };
      projetName = [];
      nodeClick = function(nodeClicked) {
        var nodeFound, nodeGroup, zoomScale;
        $scope.zoomed = true;
        $scope.project = nodeClicked;
        $rootScope.currentProject = $scope.project;
        force.stop();
        svg.selectAll(".node").classed("hidden", true);
        zoomScale = 3;
        nodeFound = node.filter(function(d) {
          if (d.id === nodeClicked.id) {
            zoomScale = 0.9 * Math.min(height, 0.5 * width) / bubbleSize(d);
          }
          return d.id === nodeClicked.id;
        });
        nodeGroup = nodeFound[0][0];
        svg.classed("zoom", true);
        d3.select(nodeGroup).classed("hidden", false).transition().duration(300).attr("transform", function() {
          return "translate(" + 0.5 * width + "," + 0 + ") scale(" + zoomScale + ")";
        }).select(".name").attr("dy", "1em");
        return d3.event.stopPropagation();
      };
      svgClick = function() {
        $scope.zoomed = false;
        $rootScope.currentProject = void 0;
        svg.classed("zoom", false);
        svg.selectAll(".node").classed("hidden", false);
        svg.selectAll(".name").attr("dy", "0.35em");
        return force.resume();
      };
      node = [];
      height = $element[0].offsetHeight;
      width = $element[0].offsetWidth;
      repulsion = 700;
      svg = d3.select($element[0]).select("svg");
      defs = svg.append('svg:defs');
      svg.attr("width", width).attr("height", height);
      force = d3.layout.force().gravity(0.5).friction(.1).size([width, height]);
      update = function(chartData) {
        var coords, scaleFactor;
        coords = [];
        node.each(function(d) {
          coords.push({
            x: d.x,
            y: d.y
          });
          return d.fixed = true;
        });
        scaleFactor = getScaleFactor(chartData);
        force.charge(function(d) {
          return -(bubbleSize(d) / scaleFactor) * repulsion;
        }).nodes(chartData);
        node.data(chartData).enter();
        node.data(chartData).exit().remove();
        circle.data(chartData);
        fillCircle.data(chartData);
        projectName.data(chartData);
        circle.transition().ease("cubic-in-out").attr("r", function(d) {
          return bubbleSize(d) / scaleFactor;
        }).style('fill', function(d) {
          return 'url(#gradient-' + bubbleId(d) + ')';
        }).style('opacity', bubbleOpacity);
        fillCircle.attr("r", function(d) {
          return (bubbleSize(d) - 8) / scaleFactor;
        }).style('fill', 'lightgray');
        projectName.text(bubbleName).attr("class", "name");
        node.each(function(d, i) {
          d.fixed = false;
          d.x = coords[i].x;
          return d.y = coords[i].y;
        });
        return force.start();
      };
      chartData = $rootScope.projects;
      force.chargeDistance(500);
      node = svg.selectAll(".node").data(chartData).enter().append("g").attr("class", "node").call(force.drag);
      svg.selectAll(".node").on("click", function(d) {
        if (d3.event.defaultPrevented) {
          return;
        }
        return nodeClick(d);
      });
      svg.on("click", svgClick);
      circlesContainer = node.append("g").attr("class", "circles-container");
      circle = circlesContainer.append("circle").style('fill', function(d) {
        return 'url(#gradient-' + bubbleId(d) + ')';
      });
      fillCircle = circlesContainer.append("circle").attr("class", "fill-circle");
      projectScore = circlesContainer.append('text').attr('x', 0).attr('y', 0).attr('class', 'project-score');
      projectName = node.append("text").attr("dy", "0.35em").attr("x", 0).attr("y", 0);
      gradient = defs.selectAll('linearGradient').data(chartData).enter().append('svg:linearGradient').attr('id', function(d) {
        return 'gradient-' + bubbleId(d);
      }).attr('x1', '0%').attr('y1', '100%').attr('x2', '0%').attr('y2', '0%');
      gradient.append('stop').attr('class', 'fg-stop').attr('offset', bubbleFillLevel).attr('stop-color', bubbleColor);
      gradient.append('stop').attr('class', 'bg-stop').attr('stop-color', bubbleBgColor);
      update(chartData);
      force.on("tick", function() {
        return node.attr("transform", function(d) {
          return "translate(" + d.x + "," + d.y + ")";
        });
      });
      return $rootScope.$watch('projects', function() {
        var foundNode, project, scaleFactor, updatedNodes, updatedProjects, _i, _len;
        chartData = $rootScope.projects;
        circle.data(chartData);
        scaleFactor = getScaleFactor(chartData);
        updatedProjects = $rootScope.projects.filter(function(project) {
          return project.updated;
        });
        updatedNodes = [];
        for (_i = 0, _len = updatedProjects.length; _i < _len; _i++) {
          project = updatedProjects[_i];
          foundNode = node.filter(function(d) {
            return d.id === project.id;
          });
          if (foundNode) {
            updatedNodes.push(foundNode[0][0]);
            d3.select(foundNode[0][0]).select(".fill-circle").transition("ease").duration(100).style('fill', 'white').transition("ease").duration(800).delay(100).style('fill', 'lightgray');
          }
        }
        circle.attr("r", function(d) {
          return bubbleSize(d) / scaleFactor;
        });
        circlesContainer.style('opacity', bubbleOpacity).classed("offline", function(d) {
          return !d.online;
        });
        gradient.selectAll('.fg-stop').attr('offset', bubbleFillLevel).attr('stop-color', bubbleColor);
        gradient.selectAll('.bg-stop').attr('offset', bubbleFillLevel);
        if ($scope.zoomed) {
          projectScore.text(function(d) {
            return bubbleScore(d) + "/10";
          }).attr('dy', function(d) {
            return 0.7 * bubbleSize(d) / scaleFactor;
          }).attr('font-size', function(d) {
            return (0.35 * bubbleSize(d) / scaleFactor) + 'px';
          });
          return projectName.style("font-size", function(d) {
            return 0.25 * bubbleSize(d) / scaleFactor + 'px';
          });
        } else {
          projectScore.text(bubbleScore).attr('dy', function(d) {
            return 0.6 * bubbleSize(d) / scaleFactor;
          }).attr('font-size', function(d) {
            return (0.5 * bubbleSize(d) / scaleFactor) + 'px';
          });
          return projectName.style("font-size", "1em");
        }
      }, true);
    }
  };
});

angular.module('metrix.project').config([
  '$routeProvider', function($routeProvider) {
    return $routeProvider.when('/project/:name', {
      controller: 'projectController',
      templateUrl: 'project/view/project-view.html'
    });
  }
]);

angular.module('metrix.project').controller('projectController', function($scope, $routeParams, $rootScope) {
  var foundProject;
  console.log($routeParams.name);
  foundProject = $rootScope.projects.filter(function(d) {
    return d.name === $routeParams.name;
  });
  if (foundProject) {
    $scope.project = foundProject[0];
  }
});
