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
    unit :cl
    group :can
    description {Faker::Lorem.paragraph}
    name {Faker::Product.product}
    
    factory :product_with_materials do
      ignore { materials_count 5 }

      after :build do |product, evaluator|
        list = FactoryGirl.build_list :product_entry, evaluator.materials_count, product: product
        product.consists_of_materials << list
      end
      
      after :create do |p, e|
        p.consists_of_materials.each {|m| m.save!}
      end
    end
  end

  factory :product_entry do
    amount 2
    association :material, strategy: :build
    association :product, strategy: :build
  end

  factory :material do
    unit :cl
    group :can
    stock 24
    price 0.7
    name { Faker::Product.product_name }
  end

  factory :buy_entry do
    amount 2
    association :product, factory: :product_with_materials, strategy: :build
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
    
    after :create do |buy, evaluator|
      buy.consists_of_products.each {|p| p.save!}
    end
  end
end
