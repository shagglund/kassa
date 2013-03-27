class CreateBuyEntries < ActiveRecord::Migration
  def change
    create_table :buy_entries do |t|
      t.references :buy, null: false
      t.references :product, null: false
      t.integer :amount, default: 1
    end
    add_index :buy_entries, :buy_id
  end
end
