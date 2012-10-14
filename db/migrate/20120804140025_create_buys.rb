class CreateBuys < ActiveRecord::Migration
  def change
    create_table :buys do |t|
      t.references :buyer, :null => false
      t.decimal :price, :null => false, :default => 0, :precision => 6, :scale => 2

      t.datetime :created_at
    end
    add_index :buys, :buyer_id
  end
end
