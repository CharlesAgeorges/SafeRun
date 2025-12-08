class Badge < ApplicationRecord
  has_many :run_badges
  # has_many :runs, through: :run_badges
end
