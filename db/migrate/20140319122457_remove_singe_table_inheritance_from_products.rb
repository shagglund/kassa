class RemoveSingeTableInheritanceFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :type
    remove_column :product_entries, :combo_product_id
    rename_column :product_entries, :basic_product_id, :product_id
  end
end
