class Card < ActiveRecord::Base
  belongs_to :variant
  has_many :card_images
  has_many :card_properties
  # has_many :player_cards, :dependent => :destroy

  attr_accessor :next
  validates_presence_of :name, :age

  def image
    ci = card_images.find(:first)
    return ci.file if ci
  end

  def image=(file)
    file = File.new(file) if file.is_a?(String) && !file.blank?
    ci = card_images.find(:first) || card_images.create
    ci.file = file
    ci.save
  end

  def age_to_s
    return 'A' if self.age == 0
    return 'I' if self.age == 1
    return 'II' if self.age == 2
    return 'III' if self.age == 3
    return 'IV' if self.age == 4
  end

  def available_actions(type, phase, gc = nil)
    {}
  end
end