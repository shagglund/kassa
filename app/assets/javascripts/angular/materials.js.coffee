angular.module('kassa.materials', ['kassa.common'])
.service('Materials', (BaseService)->
  options = {id:'@id'}
  actions=
    index:
      method: 'GET'
    create:
      method: 'POST'
    update:
      method: 'PUT'
    destroy:
      method: 'DELETE'
  class Materials extends BaseService
    constructor: ()->
      super '/materials/:id', options, actions
    
    updateChanged: (material...)=>
      @_updateLocally mat for mat in material
      return

   _encode: (material)=>
      material

  return new Materials()
)
