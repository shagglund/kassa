FactoryGirl.define do

  factory :user do
    username Faker::Internet.user_name
    balance 0
    email {"#{username}@example.com"}
    password "password"
  end

  factory :product do
    unit :cl
    description Faker::Lorem.paragraph
    name Faker::Product.product
  end

  factory :product_entry do
    amount 1
    material {@default_material ||= create(:material)}
    product {@default_product ||= create(:product)}
  end

  factory :material do
    unit :cl
    alcohol_per_cent 4.5
    stock 1
    price 0.7
    name Faker::Product.product_name
  end

  factory :buy do
    buyer {@default_user ||= create(:user)}
  end

  factory :buy_entry do
    product {@default_product ||= create(:product)}
    buy {@default_buy ||= create(:buy)}
    amount 1
  end
end