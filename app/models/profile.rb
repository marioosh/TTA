class Profile < ActiveRecord::Base
  has_one    :user, :dependent => :nullify
  validates_presence_of :first_name, :message => 'Wpisz swoje imię / nick.'

  def name
    [first_name, last_name].compact.join(' ')
  end
end
