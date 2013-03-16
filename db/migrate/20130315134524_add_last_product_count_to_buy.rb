class AddLastProductCountToBuy < ActiveRecord::Migration
  def change
    add_column :buys, :last_product_count, :integer
  end
end
