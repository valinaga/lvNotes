class AddStatusToSenders < ActiveRecord::Migration
  def self.up
    add_column :senders, :status, :string, :default => "NEW"
  end

  def self.down
    remove_column :senders, :status
  end
end
