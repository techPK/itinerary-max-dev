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
  $scope.ItenararyMAX = {}

  # $scope.ItenararyMAX.daysFrom = "#{initDate.getFullYear()}-#{initDate.getMonth() + 1}-#{initDate.getDate()}"
  # $scope.ItenararyMAX.daysTo = $scope.ItenararyMAX.daysFrom

  $scope.days = [
    {date: "#{initDate.getMonth() + 1}/#{initDate.getDate()}/#{initDate.getFullYear()}", timeStart: '08:00am', timeStop: '10:00pm'}
  ]
  

  $scope.whenChanged = ->
    dayStep = new Date($scope.ItenararyMAX.daysFrom)
    dayStop = new Date($scope.ItenararyMAX.daysTo)
    unless (dayStep == 'Invalid Date') and (dayStop == 'Invalid Date')
      iCount = 0
      $scope.days = []
      while (iCount < 7) and (dayStep <= dayStop)
        $scope.days.push {date: "#{dayStep.getMonth() + 1}/#{dayStep.getDate()}/#{dayStep.getFullYear()}", timeStart: '08:00am', timeStop: '10:00pm'}
        dayStep.setDate(dayStep.getDate() + 1)
        iCount++





