# PO CO wiele do jednego? Obrazki kart w innych jezykach!
class CardImage < ActiveRecord::Base
  belongs_to :card

  FILES_ROOT = 'public/images'
  image_column :file, :versions => { :mini => '90x140', :midi => '160x245' },
                       :root_dir => File.join(Rails.root, FILES_ROOT, 'cards'),
                       :tmp_dir => File.join(Rails.root, 'tmp/files'),
                       :web_root => '/images/cards'

  def file_store_dir(file = nil)
    return card.age_to_s
  end
end
