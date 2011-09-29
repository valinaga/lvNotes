class AddLangToSender < ActiveRecord::Migration
  def self.up
    add_column :senders, :lang, :string
  end

  def self.down
    remove_column :senders, :lang
  end
end
