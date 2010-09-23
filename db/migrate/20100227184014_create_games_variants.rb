class CreateGamesVariants < ActiveRecord::Migration
  def self.up
    create_table :games_variants, :id => false do |t|
      t.integer  :game_id
      t.integer  :variant_id
    end

    add_index :games_variants, [:game_id, :variant_id], :unique => true
  end

  def self.down
    drop_table :games_variants
  end
end