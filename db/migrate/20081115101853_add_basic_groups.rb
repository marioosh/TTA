class AddBasicGroups < ActiveRecord::Migration
  def self.up
    g = Group.create :name => 'Administratorzy'
    g.group_privileges.create(:privilege => Privilege::ACCESS_ADMIN_MODULE)
    g.group_privileges.create(:privilege => Privilege::ACCESS_MY_ACCOUNT)

    g = Group.create :name => 'Użytkownicy'
    g.group_privileges.create(:privilege => Privilege::ACCESS_MY_ACCOUNT)
    g.group_privileges.create(:privilege => Privilege::PLAY_GAMES)
  end

  def self.down
    Group.find_by_name('Użytkownicy').destroy
    Group.find_by_name('Administratorzy').destroy
  end
end
