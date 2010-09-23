class Privilege
  ACCESS_ADMIN_MODULE = 1
  ACCESS_MY_ACCOUNT = 2
  PLAY_GAMES = 3

  class AccessDenied < Exception
  end

  # You can use :only and :except
  def self.all_users(privilege)
    User.find_by_sql <<-SQL
      SELECT u.*
      FROM group_privileges gp
        JOIN groups_users gu ON gu.group_id = gp.group_id
        JOIN users u ON u.id = gu.user_id
      WHERE gp.privilege = #{privilege}
    SQL
  end
end
