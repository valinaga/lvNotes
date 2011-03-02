class AddStatusAndNextDateToLetters < ActiveRecord::Migration
  def self.up
    add_column :letters, :next_date, :datetime
    add_column :letters, :status, :string, :default => 'NEW'
    add_column :letters, :hashed, :string
  end

  def self.down
    remove_column :letters, :hashed
    remove_column :letters, :status
    remove_column :letters, :next_date
  end
end
