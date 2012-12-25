# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Material.transaction do
#  materials = Material.create!([{name: 'Koff', unit: 'piece', group: 'can', price: 0.7, stock: 24},
#                   {name: 'Crowmoor', unit: 'piece', group: 'can', price: 1, stock: 24},
#                   {name: 'Somersby - Omena', unit: 'piece', group: 'can', price: 1, stock: 24},
#                   {name: 'Greippilonkero', unit: 'piece', group: 'can', price: 1, stock: 24},
#                   {name: 'Karpalolonkero', unit: 'piece', group: 'can', price: 1, stock: 24}])
#
#  materials.each do |material|
#    Product.create! name: material.name, unit: 'piece', group: 'can',
#                              :materials_attributes => [{amount: 1, material_id: material.id}]
#  end
#end

user = User.find_by_username('tester')
user.password= 'password'
user.save!