class CreateSenders < ActiveRecord::Migration
  def self.up
    create_table :senders do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :senders
  end
end
