require File.dirname(__FILE__) + '/../test_helper'

class PrivilegeTest < ActiveSupport::TestCase
  fixtures :users, :groups, :group_privileges

  test "admin access" do
    assert users(:admin).has_privilege?(Privilege::ACCESS_ADMIN_MODULE)
    assert groups(:admins).has_privilege?(Privilege::ACCESS_ADMIN_MODULE)
    
    assert !users(:aaron).has_privilege?(Privilege::ACCESS_ADMIN_MODULE)
    assert !groups(:users).has_privilege?(Privilege::ACCESS_ADMIN_MODULE)
  end
end
