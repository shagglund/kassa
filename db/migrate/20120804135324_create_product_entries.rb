class CreateProductEntries < ActiveRecord::Migration
  def change
    create_table :product_entries do |t|
      t.integer :amount, :default => 0
      t.references :basic_product, :null => false
      t.references :combo_product, :null => false

      t.timestamps
    end
    add_index :product_entries, :basic_product_id
    add_index :product_entries, :combo_product_id
  end
end
