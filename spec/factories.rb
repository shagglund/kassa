FactoryGirl.define do
  sequence(:email){|i| "email#{i}@example.com"}
  sequence(:price){|i| (i + i / 100) % 100}
  sequence(:available){|i| i % 2 == 0}

  factory :user do
    username {Faker::Internet.user_name.truncate(16)}
    balance {Random.rand(1..100)}
    email
    password "password"
    admin false
    staff false
  end

  factory :product do
    description {Faker::Lorem.paragraph}
    name {Faker::Product.product}
    price
    available
  end

  factory :buy_entry do
    amount 2
    association :product, strategy: :build, available: true
    association :buy, strategy: :build

    before(:create) do |entry, evaluator|
      entry.product.save!
      entry.product_id = entry.product.id
      entry.buy.save!
      entry.buy_id = entry.buy.id
    end
  end

  factory :buy do
    association :buyer, factory: :user, strategy: :build
    price

    ignore do
      product_count 5
    end

    after :build do |buy, evaluator|
      list = FactoryGirl.build_list :buy_entry, evaluator.product_count, buy: buy
      buy.consists_of_products = list
    end

    before(:create) do |buy|
      buy.buyer.save!
      buy.buyer_id = buy.buyer.id
      buy.consists_of_products.each do |entry|
        entry.product.save!
        entry.product_id = entry.product.id
      end
    end
  end
end
