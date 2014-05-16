class RemoveLastProductCountFromBuys < ActiveRecord::Migration
  def change
    remove_column :buys, :last_product_count
  end
end
