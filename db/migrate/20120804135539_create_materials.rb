class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :unit, :null => false
      t.string :name, :unique => true, :null => false
      t.decimal :price, :null => false, :default => 0, :precision => 6, :scale => 2
      t.integer :stock, :default => 0

      t.timestamps
    end
  end
end
