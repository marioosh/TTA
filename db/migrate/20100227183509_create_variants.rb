class CreateVariants < ActiveRecord::Migration
  def self.up
    create_table :variants do |t|
      t.string :name
    end

    Variant.create(:name => 'Podstawowy zestaw kart')
    Variant.create(:name => 'Zestaw podstawowy + dodatek PL')
    Variant.create(:name => 'Zestaw podstawowy + dodatek CZ')

    # INSERT IGNORE INTO cards_variants (card_id, variant_id) SELECT id, 1 FROM `cards` WHERE !setup AND name NOT LIKE '%(PL)' AND name NOT LIKE '%(CZ)';
    # INSERT IGNORE INTO cards_variants (card_id, variant_id) SELECT id, 2 FROM `cards` WHERE !setup AND name NOT LIKE '%(CZ)';
    # INSERT IGNORE INTO cards_variants (card_id, variant_id) SELECT id, 3 FROM `cards` WHERE !setup AND name NOT LIKE '%(PL)';
  end

  def self.down
    drop_table :variants
  end
end