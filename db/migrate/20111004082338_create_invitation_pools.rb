class CreateInvitationPools < ActiveRecord::Migration
  def self.up
    create_table :invitation_pools do |t|
      t.string :name
      t.integer :sender_id
      t.integer :total
      t.string :invite_token

      t.timestamps
    end
  end

  def self.down
    drop_table :invitation_pools
  end
end
