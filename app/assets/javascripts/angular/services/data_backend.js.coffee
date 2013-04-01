class BaseModel
  constructor: (@dataService, @_attributes={}, @type)->
    @_updateLocally @_attributes

  save: ->
    if angular.equals(@attributes, @_attributes) and angular.isDefined(@_attributes.id)
      @status = 'nothing_changed'
      return
    action = if angular.isDefined(@attributes.id) then 'update' else 'create'
    s = =>
      @status = "#{action}_success"
    f = (response)=>
      @errors(response.data.errors)
      @status = "#{action}_failure"
    @dataService.execute(action, @type, @).then(s,f)

  cancelChanges: ->
    angular.copy @_attributes, @attributes
    @clearErrors()

  changed: (attr)->
    if angular.isDefined attr
      !angular.equals @attributes[attr], @_attributes[attr]
    else
      !angular.equals @attributes, @_attributes

  hasUnsavedChanges: (attr)->
    changed = @changed(attr)
    if changed
      @status = 'unsaved_changes'
    changed

  new: ->
    @dataService.new @type

  isNew: ->
    angular.isUndefined @attributes.id
  
  errors: (errors)->
    if angular.isDefined errors
      @_errors = errors
    else
      @_errors

  clearErrors: (field)->
    if angular.isUndefined(field)
      @_errors = undefined
    else if angular.isDefined(@_errors)
      @_errors[field] = undefined
    @status = ''

  _updateLocally: (attributes)->
    @_attributes = attributes
    @attributes = angular.copy(attributes)
    @id = attributes.id
    @status =''

class ComboProduct extends BaseModel
  constructor: (productService, attrs={consists_of_basic_products:[]})->
    super productService, attrs, 'combo_product'
    @formTemplateUrl = '/partials/products/combo_product_form'

  basic_products: ->
    mats = []
    for entry in @attributes.consists_of_basic_products
      do(entry)=>
        mats.push @dataService.find('basic_product', entry.basic_product_id)
    mats

  basic_product: (obj)->
    id = @_idByEntryBasicProductOrId obj
    @dataService.find('basic_product', id)

  firstBasicProduct: ->
    id = @_idByEntryBasicProductOrId @attributes.consists_of_basic_products[0]
    @dataService.find 'basic_product', id

  price: ->
    price = 0.0
    for entry in @attributes.consists_of_basic_products
      do(entry)=>
        basic_product = @dataService.find 'basic_products', entry.basic_product_id
        price += basic_product.attributes.price * entry.amount
    price.toFixed 2

  stock: ->
    stock = -1
    for entry in @attributes.consists_of_basic_products
      do(entry)=>
        basic_product = @dataService.find 'basic_products', entry.basic_product_id
        amount = Math.floor basic_product.attributes.stock/entry.amount
        stock = amount if stock == -1 or stock > amount
    stock

  hasGroup: (group)->
    @attributes.group == group

  addBasicProduct: (obj, amount=1)->
    id = @_idByEntryBasicProductOrId obj
    entry = _.find @attributes.consists_of_basic_products, (e)->
      e.basic_product_id == id
    return if angular.isDefined entry
    @attributes.consists_of_basic_products.push {amount: amount, basic_product_id: id}

  removeBasicProduct: (obj)->
    id = @_idByEntryBasicProductOrId obj
    _.find @attributes.consists_of_basic_products, (e,i,col)->
      if e.basic_product_id == id
        col.splice(i,1)
      true

  toRailsFormat: ->
    p=
      id: @attributes.id
      combo_product:
        id: @attributes.id
        description: @attributes.description
        name: @attributes.name
        group: @attributes.group
        consists_of_basic_products_attributes: @_mapBasicProductsForRails()
  
  _mapBasicProductsForRails: ->
    attrs = angular.copy(@attributes.consists_of_basic_products)
    for entry in @_attributes.consists_of_basic_products
      do (entry)->
        unless _.find(attrs, (e)-> e.id == entry.id)
          attrs.push({id: entry.id, _destroy: true})
    attrs

  #return the basic_product ID when either
  # 1) the obj is the id
  # 2) the obj is a combo_product basic_product entry (has a .basic_product_id)
  # 3) the obj is a basic_product (has an .id)
  _idByEntryBasicProductOrId: (obj)->
    return obj if angular.isNumber obj
    return obj.basic_product_id if angular.isNumber obj.basic_product_id
    return obj.attributes.id if angular.isNumber obj.attributes.id
    throw 'Object is not a basic_product, an combo_product basic_product entry or an id'

class BasicProduct extends BaseModel
  constructor: (d, a={})->
    if angular.isString a.price
      a.price = parseFloat(a.price)
    super d, a, 'basic_product'
    @formTemplateUrl = '/partials/products/basic_product_form'

  price: ->
    @attributes.price

  stock: ->
    @attributes.stock

  toRailsFormat: ->
    m=
      id: @attributes.id
      basic_product: @attributes

  _updateLocally: (attributes)->
    if angular.isString(attributes.price)
      attributes.price = parseFloat(attributes.price)
    super attributes

class Buy extends BaseModel
  constructor: (dataService, attrs={consists_of_products:[]})->
    if angular.isString attrs.price
      attrs.price = parseFloat(attrs.price)
    super dataService, attrs, 'buy'
  
  buyer: (buyer)->
    if angular.isDefined buyer
      @attributes.buyer_id = buyer.attributes.id
    else
      @dataService.find('user', @attributes.buyer_id)

  products: ->
    _.collect @attributes.consists_of_products, (e)=>
      e.product = @_findProduct(e.product_id)
      e

  add: (product, amount=1)->
    @attributes.consists_of_products.push {amount: amount, product_id: product.attributes.id}

  price: ->
    summer = (sum, entry)=>
      sum += entry.amount * @_findProduct(entry.product_id).price()
    _.inject @attributes.consists_of_products, summer, 0

  toRailsFormat: ->
    buy:
      buyer_id: @attributes.buyer_id
      consists_of_products_attributes: @attributes.consists_of_products
      
  _updateLocally: (attributes)->
    if angular.isString(attributes.price)
      attributes.price = parseFloat(attributes.price)
    super attributes

  _findProduct: (id)->
    p = @dataService.find('basic_product', id)
    p = @dataService.find('combo_product', id) if angular.isUndefined(p)
    p

class User extends BaseModel
  constructor: (d, attrs={})->
    if angular.isString attrs.balance
      attrs.balance = parseFloat(attrs.balance)
    super d, attrs, 'user'

  gravatarUrl: (size=16)->
    Gravtastic(@attributes.email, {default: 'mm', size: size})

  inDebt: ->
    @attributes.balance < 0

  toRailsFormat: ->
    u =
      id: @attributes.id
      user:
        id: @attributes.id
        username: @attributes.username
        email: @attributes.email
        balance: @attributes.balance
        admin: @attributes.admin
    if @isNew()
      u.user.password= @attributes.password
      u.user.password_confirmation= @attributes.password_confirmation
    u
  
  _updateLocally: (attributes)->
    if angular.isString(attributes.balance)
      attributes.balance = parseFloat(attributes.balance)
    super attributes
class DataService
  constructor: (@$q, @$resource, @$timeout)->
    basic_products=
      collection: {}
      array: []
      resource:  @$resource('/basic_products/:id', {id: '@id'}, @_actions('create','update','show', 'index', 'destroy'))
      modelConstructor: BasicProduct
      initialized: false
    combo_products=
      collection: {}
      array: []
      resource: @$resource('/combo_products/:id', {id: '@id'}, @_actions('create','update','show','index','destroy'))
      modelConstructor: ComboProduct
      initialized: false
    users=
      collection: {}
      array: []
      resource: @$resource('/users/:id', {id: '@id'}, @_actions('create','update','show','index'))
      modelConstructor: User
      initialized: false
    buys=
      collection: {}
      array: []
      resource: @$resource('/buys/:id', {id: '@id'}, @_actions('create','show', 'index'))
      modelConstructor: Buy
      initialized: false
    @_matchers=
      buy: buys
      buys: buys
      basic_product: basic_products
      basic_products: basic_products
      combo_product: combo_products
      combo_products: combo_products
      user: users
      users: users
      buyers: users
      buyer: users

  collection: (type, options={})->
    matcher = @_matchers[type]
    unless matcher.initialized
      @execute 'index', type, options
      matcher.initialized = true
    matcher.array

  find: (type, id)->
    @_matchers[type].collection[id]

  findOrFetch: (type, id)->
    item = @_matchers[type].collection[id]
    return item if angular.isDefined item
    @execute('show', type, {id: id}).then =>
      @_matchers[type].collection[id]

  new: (type)->
    new @_matchers[type].modelConstructor(@)

  execute: (action, type, item={})->
    s = (response, responseHeaders)=>
      @_handleSuccess action, type, item, response, responseHeaders
    @_defer(@_matchers[type].resource[action], @_convert(item)).then s
  
  _convert: (item)->
    return item.toRailsFormat() if angular.isFunction(item.toRailsFormat)
    return item.attributes if angular.isDefined(item.attributes)
    item

  _actions: (actions...)->
    acts = {}
    for action in actions
      do(action)->
        switch action
          when 'create' then acts.create = method: 'POST'
          when 'update' then acts.update = method: 'PUT'
          when 'show' then acts.show = method: 'GET'
          when 'index' then acts.index = method: 'GET'
          when 'destroy' then acts.destroy = method: 'GET'
    acts

  _defer: (actionFunc, options)->
    deferred = @$q.defer()
    actionFunc options, deferred.resolve, deferred.reject
    deferred.promise
  
  _handleSuccess: (action, type, sentItem, response, responseHeaders)=>
    if action == 'update'
      @_update type, sentItem.attributes
    else if action == 'destroy'
      @_destroy type, sentItem.attributes
    else
      @_update rType, values for own rType, values of response

  _update: (type, items)->
    matcher = @_matchers[type]
    return unless angular.isDefined(matcher)
    if angular.isArray items
      @_updateSingle matcher, item for item in items
    else
      @_updateSingle matcher, items
    matcher.array = _.toArray matcher.collection

  _updateSingle: (matcher, item)->
    model = matcher.collection[item.id]
    if angular.isUndefined(model)
      model = new matcher.modelConstructor(@, item)
    else
      model._updateLocally item
    matcher.collection[item.id] = model

  _destroy: (type, item)->
    delete @collection[type][item.id]

angular.module('kassa.services.data', ['ngResource'])
.service('DataService', ['$q', '$resource', ($q, $resource)->
  new DataService($q, $resource)
])
