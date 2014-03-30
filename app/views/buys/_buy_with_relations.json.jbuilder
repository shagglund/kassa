json.buy do
  json.partial! 'buys/buy', buy: buy
end
json.buyer do
  json.partial! 'users/user', user: buy.buyer
end
json.products do
  json.partial! 'products/list', products: buy.products
end