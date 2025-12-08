class Run < ApplicationRecord
  belongs_to :user
  has_many :positions, :incidents, :guardian_notifications, dependent: :destroy
  has_many :badges, through: :run_badges
  # has_many :run_badges
end
