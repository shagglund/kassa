# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

materials = Material.create!([{name: 'Koff', unit: 'piece', price: 0.7, stock: 24},
                 {name: 'Crowmoor', unit: 'piece', price: 1, stock: 24},
                 {name: 'Somersby - Omena', unit: 'piece', price: 1, stock: 24},
                 {name: 'Greippilonkero', unit: 'piece', price: 1, stock: 24},
                 {name: 'Karpalolonkero', unit: 'piece', price: 1, stock: 24}])

materials.each do |material|
  Product.transaction do
    product = Product.create! name: material.name, unit: 'piece'
    ProductEntry.create! amount: 1, material_id: material.id, product_id: product.id
  end
end