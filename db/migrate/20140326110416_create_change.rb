class CreateChange < ActiveRecord::Migration
  def up
    create_table :changes do |t|
      t.references :trackable, polymorphic: true, null: false
      t.references :doer
      t.json :change
      t.text :change_note
      t.string :type
      t.datetime :created_at
    end
    add_index :changes, [:doer_id, :trackable_id]
    add_index :changes, [:trackable_type, :trackable_id]
  end

  def down
    remove_index :changes, [:doer_id, :trackable_id]
    remove_index :changes, [:trackable_type, :trackable_id]
    drop_table :changes
  end
end
