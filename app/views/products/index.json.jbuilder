json.products do
  json.partial! 'products/list', products: @products
end