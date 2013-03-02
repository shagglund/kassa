describe 'Module kassa.users', ->
  describe 'Users service', ->
    users = undefined
    user = undefined
    beforeEach ->
      module 'kassa.users'
      inject ($injector)->
        users = $injector.get 'Users'
      user = Factory.build 'user'

    describe '#updateChanged', ->
      it 'updates the changes in a single user', ->
        copy = angular.copy user
        copy.balance += 1
        users._add user
        users.updateChanged copy
        expect(users.findById(user.id)).toBe copy

      it 'updates the changes in multiple users from an array', ->
    
    describe '#_encode', ->
      it 'returns an transformed object with only changeable data in rails format', ->
        allowed = ['first_name','last_name','email','username','balance']
        encoded = users._encode user
        expect(encoded.id).toBe user.id
        expect(encoded.user).toBeDefined()
        expect(allowed).toContain prop for prop of encoded.user when encoded.user.hasOwnProperty(prop)

    describe 'BaseService inheritance', ->
      it 'is an instance of BaseService', inject (BaseService)->
        expect(users instanceof BaseService).toBeTruthy()
      
      it 'has an #index method', ->
        expect(users.index).toBeDefined()

      it 'has a #create method', ->
        expect(users.create).toBeDefined()

      it 'has an #update method', ->
        expect(users.update).toBeDefined()

      it 'does not have a #destroy method', ->
        expect(users.destroy).not.toBeDefined()

