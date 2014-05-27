angular.module('kassa').factory('StateService', [
  '$q'
  ($q)->
    STATE_ERROR = 0
    STATE_SUCCESS = 1
    STATE_CHANGING = 2
    STATE_DEFAULT = 3
    class StateHandler
      __isInState: (matchState)=> @currentState == matchState
      __setToState: (state)=> @currentState = state
      isError:  => @__isInState(STATE_ERROR)
      isSuccess:  => @__isInState(STATE_SUCCESS)
      isChanging:  => @__isInState(STATE_CHANGING)
      isDefault:  => @__isInState(STATE_DEFAULT)
      handleStateChanges: (promise)=>
        setToSuccess = (resp)=>
          @__setToState(STATE_SUCCESS) unless @__isInState(STATE_DEFAULT)
          resp
        setToError = (resp)=>
          @__setToState(STATE_ERROR) unless @__isInState(STATE_DEFAULT)
          $q.reject(resp)

        @__setToState(STATE_CHANGING)
        promise.then(setToSuccess, setToError)
      reset: => @__setToState(STATE_DEFAULT)

    handlers = {}
    {
      getHandler: (key)-> handlers[key] ||= new StateHandler()
    }
])