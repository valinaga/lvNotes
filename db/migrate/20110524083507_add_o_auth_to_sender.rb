class AddOAuthToSender < ActiveRecord::Migration
  def self.up
    add_column :senders, :provider, :string
    add_column :senders, :uid, :string
  end

  def self.down
    remove_column :senders, :provider
    remove_column :senders, :uid
  end
end
