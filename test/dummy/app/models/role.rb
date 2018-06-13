class Role < ApplicationRecord
  has_many :role_permissions, :dependent => :destroy
  has_many :permissions, :through => :role_permissions
  has_many :authorizations, :dependent => :destroy
  has_many :role_limits, :dependent => :destroy
end
