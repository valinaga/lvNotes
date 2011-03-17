class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      t.string :username
      t.string :email
      t.string :password_hash
      t.string :salt_hash
      t.string :status, :default => 'ACTIVE'
      t.string :session_hash
      t.date   :last_login_date
      t.string :last_login_ip
      t.timestamps
    end
  end

  def self.down
    drop_table :admins
  end
end
