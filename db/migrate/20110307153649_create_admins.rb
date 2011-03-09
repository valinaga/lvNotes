class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      t.string :username
      t.string :password
      t.string :email
      t.string :status, :default => 'ACTIVE'
      t.string :session_hash

      t.timestamps
    end
  end

  def self.down
    drop_table :admins
  end
end
