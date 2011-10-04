class AddAuthTokenToSender < ActiveRecord::Migration
  def self.up
    add_column :senders, :auth_token, :string
  end

  def self.down
    remove_column :senders, :auth_token
  end
end
