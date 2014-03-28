json.cache! ['buy', buy.id] do
  json.id buy.id
  json.price buy.price
  json.created_at buy.created_at
  json.buyer_id buy.buyer_id
  json.consists_of_products do
    json.array! buy.consists_of_products do |entry|
      json.id entry.id
      json.amount entry.amount
      json.product_id entry.product_id
    end
  end
end