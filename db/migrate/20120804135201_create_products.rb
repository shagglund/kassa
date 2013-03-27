class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, unique: true, null: false
      t.text :description
      t.string :unit
      t.string :group, null: false
      t.string :type
      t.decimal :price, null: false, default: 0, precision: 6, scale: 2
      t.integer :stock, default: 0

      t.timestamps
    end
  end
end
