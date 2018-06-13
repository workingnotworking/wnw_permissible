class Authorization < ApplicationRecord
  belongs_to :authorizable, :polymorphic => true
  belongs_to :role
end
