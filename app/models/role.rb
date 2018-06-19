class Role < ApplicationRecord
  has_many :role_permissions, :dependent => :destroy
  has_many :permissions,      :through => :role_permissions
  has_many :authorizations,   :dependent => :destroy
  has_many :role_limits,      :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true

  def limit(attribute)
    role_limits.pluck(attribute).max
  end

  def human_name
    name.split('_').last.titlecase
  end
end
