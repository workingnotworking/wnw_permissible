class Authorization < ApplicationRecord
  belongs_to :authorizable, :polymorphic => true, :touch => true
  belongs_to :role

  validates :role,         :presence => true
  validates :authorizable, :presence => true
end
