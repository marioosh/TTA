class CreateGameCards < ActiveRecord::Migration
  def self.up
    create_table :game_cards do |t|
      t.integer :game_id
      t.integer :card_id
      t.integer :player_id
      t.string  :type

      t.integer :yellow_tokens, :null => false, :default => 0
      t.integer :blue_tokens, :null => false, :default => 0
      t.integer :position

      t.boolean :active, :default => false
    end

    add_index :game_cards, [:game_id, :card_id], :unique => true
    add_index :game_cards, :player_id
    add_index :game_cards, :type
  end

  def self.down
    drop_table :game_cards
  end
end