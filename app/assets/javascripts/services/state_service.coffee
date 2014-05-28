angular.module('kassa').factory('StateService', [
  '$q'
  ($q)->
    STATE_ERROR = 0
    STATE_SUCCESS = 1
    STATE_CHANGING = 2
    STATE_DEFAULT = 3
    class StateHandler
      constructor: -> @__setToState(STATE_DEFAULT)
      __isInState: (matchState)=> @currentState == matchState
      __setToState: (state)=> @currentState = state
      isError:  => @__isInState(STATE_ERROR)
      isSuccess:  => @__isInState(STATE_SUCCESS)
      isChanging:  => @__isInState(STATE_CHANGING)
      isDefault:  => @__isInState(STATE_DEFAULT)
      reset: => @__setToState(STATE_DEFAULT)
      handleStateChanges: (promise)=>
        setToSuccess = (resp)=>
          @__setToState(STATE_SUCCESS)
          resp
        setToError = (resp)=>
          @__setToState(STATE_ERROR)
          $q.reject(resp)

        @__setToState(STATE_CHANGING)
        promise.then(setToSuccess, setToError)

    handlers = {}
    {
      getHandler: (key)-> handlers[key] ||= new StateHandler()
    }
])