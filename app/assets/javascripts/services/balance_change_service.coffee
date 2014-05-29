angular.module('kassa').factory('BalanceChangeService',[
  '$http'
  '$q'
  ($http, $q)->
    #handle price as a float, not a string
    convertBalanceChange = (balanceChange, doers)->
      balanceChange.doer = _.find doers, (doer)-> doer.id == balanceChange.doerId

    convert = (resp)->
      balanceChanges = resp.data.balanceChanges
      doers = resp.data.doers
      _.forEach balanceChanges, (balanceChange)-> convertBalanceChange(balanceChange, doers)
      resp

    getFromResponse = (resp)-> resp.data.balanceChanges

    all = (user)->
      $q.when(user).then (resolvedUser)->
        $http.get("/users/#{resolvedUser.id}/balance_changes").then(convert).then(getFromResponse)

    {all}
])