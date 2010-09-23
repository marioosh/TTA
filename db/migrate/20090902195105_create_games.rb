class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer   :user_id

      # current action and player
      t.integer   :current_action_id
      t.integer   :current_player_position
      t.integer   :active_player_position

      # game status
      t.integer   :status, :default => Game::Status::WAITING_FOR_PLAYERS
      t.integer   :round, :default => 0
      t.integer   :phase

      t.integer   :age, :default => 0

      # game config
      t.integer   :max_players, :default => 4
      t.integer   :max_time, :default => 0
      t.string    :type, :default => Game::Civilization::Full.to_s

      # privacy settings
      t.string    :description
      t.string    :password
      t.boolean   :ranking, :default => true

      # optimistic locking
      t.integer   :lock_version, :default => 0
      t.timestamps
    end

    add_index :games, :user_id
  end

  def self.down
    drop_table :games
  end
end