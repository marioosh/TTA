class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.integer     :game_id
      t.integer     :user_id
      t.integer     :position
      t.integer     :color,          :default => 0
      t.integer     :free_workers,   :default => 1
      t.integer     :yellow_tokens,  :default => 25
      t.integer     :blue_tokens,    :default => 18
      t.integer     :points_culture, :default => 0
      t.integer     :points_science, :default => 0

      t.timestamps
    end

    add_index :players, [:game_id, :user_id],  :unique => true, :name => "game_user"
    add_index :players, [:game_id, :position], :unique => true, :name => "game_position"
  end

  def self.down
    drop_table :players
  end
end
