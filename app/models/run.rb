class Run < ApplicationRecord
  belongs_to :user
  validates :duration, :distance, :status, :start_point, presence: true
  has_many :positions, dependent: :destroy
  has_many :incidents, dependent: :destroy
  has_many :guardian_notifications, dependent: :destroy
  has_many :run_badges
  has_many :badges, through: :run_badges
end
