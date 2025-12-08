class Run < ApplicationRecord
  belongs_to :user
  validates :duration, :distance, :status, :start_point, presence: true
end
