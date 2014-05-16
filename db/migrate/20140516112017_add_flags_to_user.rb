class AddFlagsToUser < ActiveRecord::Migration
  def up
    add_column :users, :bit_flags, :integer

    User.reset_column_information
    User.all.each do |user|
      user.active = true
      user.save!
    end
  end

  def down
    remove_column :users, :bit_flags
  end
end
