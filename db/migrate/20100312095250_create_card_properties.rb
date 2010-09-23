class CreateCardProperties < ActiveRecord::Migration
  def self.up
    create_table :card_properties do |t|
      t.integer :card_id
      t.string  :name
      t.string  :value
    end

    add_index :card_properties, [:card_id, :name], :unique => true
  end

  def self.down
    drop_table :card_properties
  end
end
