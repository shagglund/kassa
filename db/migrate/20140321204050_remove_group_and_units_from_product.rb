class RemoveGroupAndUnitsFromProduct < ActiveRecord::Migration
  def change
    remove_column :products, :group
    remove_column :products, :unit
  end
end
