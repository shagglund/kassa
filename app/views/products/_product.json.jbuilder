json.cache! ['product', product.id, product.updated_at] do
  json.id product.id
  json.price product.price
  json.name product.name
  json.description product.description
  json.available product.available
  json.buy_count product.buy_count
  json.last_bought_at product.last_bought_at
  json.created_at product.created_at
  json.updated_at product.updated_at
end