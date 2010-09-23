class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string  :first_name
      t.string  :last_name
      t.text    :description
      t.string  :remote_addr
      t.string  :remote_host
      t.integer :updated_by
      t.string  :locale, :length => 5, :default => I18n.default_locale.to_s

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end 