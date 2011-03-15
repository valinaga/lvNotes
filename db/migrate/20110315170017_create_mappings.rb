class CreateMappings < ActiveRecord::Migration
  def self.up
    create_table :mappings do |t|
      t.string :email
      t.string :fake_mail
      t.integer :sender_id
      t.timestamps
    end
  end

  def self.down
    drop_table :mappings
  end
end
