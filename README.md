# Permissible
Adds WNW-style authorization into a Rails app.

[![Build Status](https://semaphoreci.com/api/v1/workingnotworking/wnw-permissible/branches/master/badge.svg)](https://semaphoreci.com/workingnotworking/wnw-permissible)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'wnw-permissible', :require => 'permissible'
```

And then execute:
```bash
$ bundle
```

Unfortunately the gem name "permissible" was already taken. :(

## Usage
In your `User` model (or any model you want to have roles and permissions) include the Permissible concern:

```ruby
class User < ApplicationRecord
  include Permissible
end
```

Now your `User` has roles, permissions and limits that you can check in your app. Create some roles and permissions:

```ruby
role = Role.create :name => 'admin'
permission = Permission.create :name => 'access_admin'
role.permissions << permission
```

```ruby
user = User.first
user.admin?             #=> true (with Rails logger warning)
user.can_access_admin?  #=> true
user.has_role? 'admin'  #=> true
user.role_names         #=> ['admin']
user.permissions        #=> [:access_admin]
```

### About Roles

Role checks take the form of `[role]?` where `[role]` is the name of your role, like `admin?`. A Rails logger warning is output when you check roles in this manner since it's a bad practice: you should check permissions that a user has, not their role. Permissions are fluid and can move from role to role, so really it shouldn't matter what their named roles are, it matters what they can do.

### About Permissions

Permission checks take the form of "can_[permission]?" where `[permission]` is the name you give to the permission. So if you have a permission with a name of "access_admin" then you check for that permission with `can_access_admin?`

Permissions are additive. If you have a permission, it returns `true`. If you don't have a permission, it returns false. If one role has a permission and the other does not, the user has that permission. There is no way for one role to force a permission to `false` if some other role provides it.

## Role Limits

In addition to permissions a role can also have limits on some aspect of your app. Consider a search engine where a guest can only perform 10 searches but an admin can perform an unlimited number.

First create an attribute in the `RoleLimit` model that contains the value:

```ruby
# db/migrate/201806131200000_create_role_limit_searches.rb
class CreateRoleLimitSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :role_limits, :searches, :string
  end
end
```

Note that the column is a `:string`. The value contained in the column will be serialized (in YAML) so that it can contain arbitrary data that Rails will convert back to native datatypes for us.

Now decorate `RoleLimit` to declare that your new attribute should be serialized:

```ruby
# app/decorators/role_limit_decorator.rb
RoleLimit.class_eval do
  serialize :searches
end
```

Now add `RoleLimit` records for your roles and see how they work:

```ruby
admin = Role.create :name => 'admin'
guest = Role.create :name => 'guest'
admin.role_limits.create :searches => Float::INFINITY
guest.role_limits.create :searches => 10

alice = User.create
alice.roles << admin
bob = User.create
bob.roles << guest

alice.limit(:searches) #=> Infinity
bob.limit(:searches) #=> 10
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
