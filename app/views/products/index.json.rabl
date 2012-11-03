collection @products
attributes :id, :price, :stock, :name, :description, :unit, :group
child :materials => :materials do
  child :material do
    attributes :id, :name
  end
  attributes :id, :amount
end