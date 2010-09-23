class AddBasicUsers < ActiveRecord::Migration
  def self.up
    u = User.new(
      :login => 'artur@jedlinski.pl',
      :password => 'test',
      :password_confirmation => 'test'
    )

    u.profile = Profile.new(
      :first_name => 'Administrator'
    )

    u.groups << Group.find_by_name('Administratorzy')
    u.groups << Group.find_by_name('Użytkownicy')
    u.save(false)

    u = User.new(
      :login => 'test@xpect.pl',
      :password => 'test',
      :password_confirmation => 'test'
    )

    u.profile = Profile.new(
      :first_name => 'Użytkownik',
      :last_name  => 'Testowy'
    )

    u.groups << Group.find_by_name('Użytkownicy')
    u.save
  end

  def self.down
    User.find_by_login('artur@jedlinski').destroy
    User.find_by_login('test@xpect.pl').destroy
  end
end