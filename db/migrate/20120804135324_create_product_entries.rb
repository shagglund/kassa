class CreateProductEntries < ActiveRecord::Migration
  def change
    create_table :product_entries do |t|
      t.integer :amount, :default => 0
      t.references :product, :null => false
      t.references :material, :null => false

      t.timestamps
    end
    add_index :product_entries, :product_id
    add_index :product_entries, :material_id
  end
end
