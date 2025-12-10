class Run < ApplicationRecord
  belongs_to :user

  geocoded_by :start_point, latitude: :start_point_lat, longitude: :start_point_lng
  after_validation :geocode, if: :will_save_change_to_start_point?

  validates :duration, :distance, :status, :start_point, presence: true
  has_many :positions, dependent: :destroy
  has_many :incidents, dependent: :destroy
  has_many :guardian_notifications, dependent: :destroy
  has_many :guardians, through: :guardian_notifications # ajout
  has_many :run_badges
  has_many :badges, through: :run_badges
end
