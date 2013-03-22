class RemoveUnitFromProduct < ActiveRecord::Migration
  def up
    remove_column :products, :unit
  end

  def down
    add_column :products, :unit, :null => false
  end
end
