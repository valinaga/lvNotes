class RemovePasswordFromSenders < ActiveRecord::Migration
  def self.up
    remove_column :senders, :password
  end

  def self.down
    add_column :senders, :password, :string
  end
end
