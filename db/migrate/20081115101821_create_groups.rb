class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.integer :parent_id
      t.integer :position, :default => 0

      t.timestamps
    end

    create_table :groups_users, :id => false do |t|
      t.integer :group_id
      t.integer :user_id
    end

    add_index :groups_users, [:group_id, :user_id], :unique => true, :name => "user_group"
  end

  def self.down
    drop_table :groups_users
    drop_table :groups
  end
end