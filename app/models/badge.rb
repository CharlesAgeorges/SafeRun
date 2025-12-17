class Badge < ApplicationRecord
  has_many :run_badges
  has_many :runs, through: :run_badges

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
