require 'test_helper'

class Permissible::Test < ActiveSupport::TestCase

  test "#method_missing should provide a `can_?` method to determine if a Permissible has permission" do
    assert users(:bob).can_access_admin?
    assert !users(:bob).can_foobar?
  end

  test "#method_missing should provide a method to determine if a Permissible has a given role" do
    assert users(:bob).admin?
    assert !users(:alice).admin?
  end

  test "#method_missing should bubble up a NameError if no role name matches" do
    assert_raises NameError do
      users(:bob).invalid_role_name?
    end
  end

  test "#respond_to? should include permission-formatted methods" do
    assert users(:alice).respond_to?(:can_do_this?)
    assert !users(:alice).respond_to?(:can_do_this)
  end

  test "#respond_to? should include role-formatted methods" do
    assert users(:bob).respond_to?("#{roles(:admin).name}?".to_sym)
    assert !users(:bob).respond_to?(:foobar?)
  end

  test "role checks should not affect built-in Rails attribute checks" do
    assert !users(:alice).active?
    assert users(:bob).active?
  end

  test "#permissions should provide a list of all permissions" do
    admin_permissions = roles(:admin).permissions.pluck(:name).collect(&:to_sym).sort

    assert_equal admin_permissions, users(:bob).permissions
  end

  test "#has_permission? should be able to check if a Permissible has a given permission" do
    assert users(:bob).has_permission?(:access_admin)
    assert !users(:alice).has_permission?(:access_admin)
  end

  test "#has_role? should be able to check if a Permissible has a given role" do
    assert users(:bob).has_role?('admin')
    assert !users(:alice).has_role?('admin')
  end

  test "#role_names returns the names of all the roles for a user" do
    assert_equal ['admin'], users(:bob).role_names
    assert_equal [], users(:alice).role_names
  end

  test "#limit returns the limit for a given attribute" do
    assert_equal role_limits(:admin_sample).sample, users(:bob).limit(:sample)
  end

end
