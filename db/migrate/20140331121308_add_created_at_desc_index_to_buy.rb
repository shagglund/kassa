class AddCreatedAtDescIndexToBuy < ActiveRecord::Migration
  def up
    add_index :buys, :created_at, order: :desc
  end

  def down
    remove_index :buys, :created_at
  end
end
