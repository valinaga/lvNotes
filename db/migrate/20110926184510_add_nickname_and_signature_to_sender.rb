class AddNicknameAndSignatureToSender < ActiveRecord::Migration
  def self.up
    add_column :senders, :nickname, :string
    add_column :senders, :signature, :string
  end

  def self.down
    remove_column :senders, :signature
    remove_column :senders, :nickname
  end
end
