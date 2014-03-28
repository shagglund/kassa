json.buy do
  json.partial! 'buys/buy_with_root', buy: buy
end
json.buyer do
  json.partial! 'users/user', user: buy.user
end
json.products do
  products = buy.consists_of_products.map(&:product).uniq
  json.partial! 'products/list', products: products
end