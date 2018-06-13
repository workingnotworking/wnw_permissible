class RoleLimit < ApplicationRecord
  serialize :sample

  belongs_to :role
end
