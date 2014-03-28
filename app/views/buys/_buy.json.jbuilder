json.cache! ['buy', buy.id] do
  json.id buy.id
  json.price buy.price
  json.created_at buy.created_at
end
json.consists_of_products do
  json.array! buy.consists_of_products do |entry|
    json.id entry.id
    json.amount entry.amount
    json.product do
      json.partial! 'products/product', product: entry.product
    end
  end
end

json.buyer do
  json.partial! 'users/user', user: buy.buyer
end