class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :group_privileges, :dependent => :destroy
  validates :name, :presence => true

  def has_privilege?(privilege)
    !privileges.index(privilege).nil?
  end

  def all_users
    User.find_by_sql <<-SQL
			select users.*
			from users, groups_users
			where users.id = groups_users.user_id
			and groups_users.group_id = #{self.id}
    SQL
  end

  def privileges
    self.group_privileges.map { |gp| gp.privilege  }
  end
end
