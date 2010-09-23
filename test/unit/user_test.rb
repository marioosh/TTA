require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :profiles, :users, :groups, :group_privileges

  test "should create user" do
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  test "should require profile" do
    assert_no_difference 'User.count' do
      u = create_user(:profile => false)
      assert !u.errors[:profile].empty?
    end
  end
  
  test "should require login" do
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert !u.errors[:login].empty?
    end
  end

  test "should require password" do
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert !u.errors[:password].empty?
    end
  end

  test "should require password confirmation" do
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert !u.errors[:password_confirmation].empty?
    end
  end

  test "should reset password" do
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin@example.com', 'new password')
  end

  test "should not rehash password" do
    users(:quentin).update_attributes(:login => 'quentin2@example.com')
    assert_equal users(:quentin), User.authenticate('quentin2@example.com', 'test')
  end

  test "should authenticate user" do
    assert_equal users(:quentin), User.authenticate('quentin@example.com', 'test')
  end

protected
  def create_user(options = {})
    record = User.new({ :login => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    record.profile = Profile.new(:first_name => 'Quire') if options[:profile].nil? || options[:profile] == true
    record.save
    record
  end
end
