json.products do
  json.cache! ['products', @products.map(&:updated_at).max] do
    json.array! @products do |product|
      json.partial! 'products/product', product: product
    end
  end
end