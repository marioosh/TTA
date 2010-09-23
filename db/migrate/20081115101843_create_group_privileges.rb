class CreateGroupPrivileges < ActiveRecord::Migration
  def self.up
    create_table :group_privileges do |t|
      t.integer :group_id
      t.integer :privilege
    end
    
    add_index :group_privileges, [:group_id, :privilege], :unique => true, :name => "group_privilege"
  end

  def self.down
    drop_table :group_privileges
  end
end