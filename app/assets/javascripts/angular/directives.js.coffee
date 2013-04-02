angular.module('kassa.directives', [])
.directive('chosen', ->
  directive= (scope, element, attrs)->
    triggerListUpdate = (newVal, oldVal)->
      #let chosen know the options changed
      element.trigger 'liszt:updated'
      #rerun to update the element, 
      #required if f.e the directive was just included in a dialog
      element.chosen()
      return
    chooseField= (newVal, oldVal)->
      element.val(newVal)
      triggerListUpdate(newVal, oldVal)
    scope.$watch attrs.chosen, triggerListUpdate, true
    scope.$watch attrs.ngModel, chooseField, true
      
  {restrict: 'A', scope:false, terminal:true, link: directive}
)
.directive('kassaAdmin', ['Session', (Session)->
  directive = (scope, element, attrs)->
    scope.session = Session
    scope.$watch 'session.currentUser', (user)->
      display = if angular.isDefined(user) and user.admin then '' else 'none'
      element.css('display', display)
  {restrict: 'AC', scope:true, link:directive}
])
