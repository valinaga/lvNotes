class AddSpecialToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :special, :string
  end

  def self.down
    remove_column :messages, :special
  end
end
