class CreateCardImages < ActiveRecord::Migration
  def self.up
    create_table :card_images do |t|
      t.integer  :card_id
      t.string   :file
      t.string   :locale, :length => 5, :default => I18n.default_locale.to_s
    end

    add_index :card_images, [:card_id, :locale], :unique => true
  end

  def self.down
    drop_table :card_images
  end
end