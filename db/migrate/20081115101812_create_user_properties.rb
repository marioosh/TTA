class CreateUserProperties < ActiveRecord::Migration
  def self.up
    create_table :user_properties do |t|
      t.integer  :user_id
      t.string   :name, :limit => 20
      t.text     :value
    end
    add_index :user_properties, [:user_id, :name], :unique => true
  end

  def self.down
    drop_table :user_properties
  end
end
