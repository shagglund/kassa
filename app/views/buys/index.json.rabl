collection @buys
attributes :id, :price, :created_at
child :buyer => :buyer do
  attributes :id, :username
end
child :products => :products do
  attributes :id, :amount
  glue :product do
    attribute :name
  end
end