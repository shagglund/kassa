class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :unit, :null => false
      t.string :name, :unique => true, :null => false
      t.float :price, :null => false
      t.float :alcohol_per_cent, :null => false
      t.integer :stock, :default => 0

      t.timestamps
    end
  end
end
