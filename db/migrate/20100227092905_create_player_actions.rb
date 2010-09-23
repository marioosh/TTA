class CreatePlayerActions < ActiveRecord::Migration
  def self.up
    create_table :player_actions do |t|
      t.integer :player_id
      t.integer :round
      
      # action details
      t.string  :type
      t.integer :actions
      t.integer :game_card_id
      t.integer :target_card_id
      
      t.timestamp :created_at
    end

    add_index :player_actions, [:player_id, :round]
  end
  
  def self.down
    drop_table :player_actions
  end
end
