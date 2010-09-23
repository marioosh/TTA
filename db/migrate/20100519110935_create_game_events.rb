class CreateGameEvents < ActiveRecord::Migration
  def self.up
    create_table :game_events do |t|
      t.integer   :game_id
      t.integer   :user_id
      t.text      :description
      t.timestamp :created_at
    end

    add_index :game_events, :game_id
    add_index :game_events, :user_id
  end

  def self.down
    drop_table :game_events
  end
end