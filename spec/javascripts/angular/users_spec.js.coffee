describe 'Module kassa.users', ->
  beforeEach ->
    module 'kassa.users'
  describe 'Users service', ->
    user = undefined
    beforeEach ->
      user = Factory.build 'user'
        
    describe '#findByUsername', ->
      it 'returns the user with matching username', inject (Users)->
        Users._add user
        expect(Users.findByUsername(user.username)).toBe user

    describe '#updateChanged', ->
      it 'updates the changes in a single user', inject (Users)->
        copy = angular.copy user
        copy.balance += 1
        Users._add user
        Users.updateChanged copy
        expect(Users.findById(user.id)).toBe copy

      it 'updates the changes in multiple users', inject (Users)->
        users = (Factory.build 'user' for i in [0..2])
        copies = (angular.copy user for user in users)
        copy.balance += 1 for copy in copies
        Users._add users...
        Users.updateChanged copies...
        expect(user.balance).toBe copies[i].balance for user, i in Users.entries()

    describe '#_encode', ->
      it 'returns an transformed object with only changeable data in rails format', inject (Users)->
        allowed = ['id','first_name','last_name','email','username','balance']
        encoded = Users._encode user
        expect(encoded.id).toBe user.id
        expect(encoded.user).toBeDefined()
        expect(allowed).toContain prop for prop of encoded.user when encoded.user.hasOwnProperty(prop)

    describe 'BaseService inheritance', ->
      it 'is an instance of BaseService', inject (BaseService, Users)->
        expect(Users instanceof BaseService).toBeTruthy()
      
      it 'has an #index method', inject (Users)->
        expect(Users.index).toBeDefined()

      it 'has a #create method', inject (Users)->
        expect(Users.create).toBeDefined()

      it 'has an #update method', inject (Users)->
        expect(Users.update).toBeDefined()

      it 'does not have a #destroy method', inject (Users)->
        expect(Users.destroy).not.toBeDefined()

