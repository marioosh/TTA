class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :login
      t.string    :crypted_password, :limit => 40
      t.string    :salt, :limit => 40
      t.integer   :profile_id

      t.boolean   :active, :default => true
      t.timestamps
    end

    add_index :users, :login, :unique => true
    add_index :users, :profile_id

  end

  def self.down
    drop_table :users
  end
end