class CreateLetters < ActiveRecord::Migration
  def self.up
    create_table :letters do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :message_id
      t.datetime :sent

      t.timestamps
    end
  end

  def self.down
    drop_table :letters
  end
end
