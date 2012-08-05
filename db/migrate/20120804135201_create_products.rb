class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, :unique => true, :null => false
      t.string :description
      t.string :unit, :null => false

      t.timestamps
    end
  end
end
