json.buys do
  json.array! @buys do |buy|
    json.partial! 'buys/buy', buy: buy
  end
end