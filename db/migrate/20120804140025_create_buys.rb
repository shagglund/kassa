class CreateBuys < ActiveRecord::Migration
  def change
    create_table :buys do |t|
      t.references :buyer, :null => false

      t.datetime :created_at
    end
    add_index :buys, :buyer_id
  end
end
