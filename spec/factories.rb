FactoryGirl.define do
  sequence(:email){|i| "email#{i}@example.com"}
  factory :user do
    username {Faker::Internet.user_name.truncate(16)}
    balance 0
    email
    password "password"
    admin false
    staff false
  end

  factory :product do
    group "beer"
    description {Faker::Lorem.paragraph}
    name {Faker::Product.product}
   
  end
 
  factory :combo_product, parent: :product, class: 'ComboProduct' do
    ignore { products_count 5 }

    after :build do |product, evaluator|
      list = FactoryGirl.build_list :product_entry, evaluator.products_count, combo_product: product
      product.consists_of_basic_products << list
    end
  end

  factory :basic_product, parent: :product, class: 'BasicProduct' do
    unit "piece"
    stock 24
    price 0.7
  end

  factory :product_entry do
    amount 2
    association :combo_product, strategy: :build
    association :basic_product, strategy: :build
  end

  factory :buy_entry do
    amount 2
    association :product, factory: :basic_product, strategy: :build
    association :buy, strategy: :build
  end

  factory :buy do
    association :buyer, factory: :user, strategy: :build

    ignore do
      product_count 5
    end

    after :build do |buy, evaluator|
      list = FactoryGirl.build_list :buy_entry, evaluator.product_count, buy: buy 
      buy.consists_of_products << list
    end
  end
end
