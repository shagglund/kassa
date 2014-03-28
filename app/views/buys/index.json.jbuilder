json.buys do
  json.cache! cache_key_for_buys(@buys) do
    json.array! @buys do |buy|
      json.partial! 'buys/buy', buy: buy
    end
  end
end
json.buyers do
  buyers = @buys.map(&:buyer).uniq
  json.partial! 'users/list', users: buyers
end
json.products do
  products = @buys.map(&:products).flatten.uniq
  json.partial! 'products/list', products: products
end