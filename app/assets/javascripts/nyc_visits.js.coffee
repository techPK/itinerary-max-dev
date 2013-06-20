# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

module = angular.module('demoApp',[])

module.directive 'input', ->
  require: '?ngModel',
  restrict: 'E',
  link: (scope, element, attrs, ngModel) ->
    if ( attrs.type="date" && ngModel ) 
      element.bind 'change', ->
        scope.$apply ->
          ngModel.$setViewValue(element.val())
    # alert "**** Testing 000****"



@ItenararyWhenCtrl = ($scope) ->
  initDate = new Date()
  $scope.days = []


  $scope.whenChanged = ->
    dayStep = new Date($scope.ItenararyMAX.daysFrom + ' 08:00:00')
    dayStop = new Date($scope.ItenararyMAX.daysTo + ' 22:00:00')
    unless (dayStep == 'Invalid Date') and (dayStop == 'Invalid Date')
      iCount = 0
      $scope.days = []
      while (iCount < 7) and (dayStep <= dayStop)
        timeDate = dayStep.toLocaleDateString()
        # dayStep.setHours(8,0)
        # timeStart = dayStep.toTimeString()
        # dayStep.setHours(22,0)
        # timeStop  = dayStep.toTimeString()
        $scope.days.push 
          date: timeDate
          timeStart: "08:00"
          timeStop:  "22:00"
        dayStep.setDate(dayStep.getDate() + 1)
        iCount++

  $scope.dateDelete = (index) ->
    # $scope.$apply = ->
    if index == ($scope.days.length - 1)
      $scope.days.pop()
    else
      $scope.days.splice(index,1)