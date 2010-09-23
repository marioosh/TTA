class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.string   :name
      t.string   :type
      t.integer  :min_players, :default => 0
      t.integer  :age
      t.text     :description

      t.integer  :variant_id, :default => 2
    end
  end

  def self.down
    drop_table :cards
  end
end