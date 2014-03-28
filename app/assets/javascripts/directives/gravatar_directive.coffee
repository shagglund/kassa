#= require gravtastic

angular.module('kassa').directive('gravatar', [
  '$parse'
  ($parse)->
    linker = ($scope, $element, $attrs)->
      email = size = null
      setGravatarSrc = (email, size)->
        email = "" unless email?
        size ||= 22
        $element.attr('src', Gravtastic(email, default: 'mm', size: size))
        $element.css('min-width', size + 10)
        $element.css('min-height', size + 10)

      updateEmail = (newEmail)->
        return if newEmail == email
        email = newEmail
        setGravatarSrc(email, size)
        email

      updateSize = (newSize)->
        return if newSize == size
        size = newSize
        setGravatarSrc(email, size)
        size

      $scope.$watch($attrs.gravatar, updateEmail)
      $scope.$watch($attrs.gravatarSize, updateSize)

    restrict: 'A', terminal: true, link: linker, scope: false
])