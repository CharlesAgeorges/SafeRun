class Guardian < ApplicationRecord
  belongs_to :user
  has_many :guardian_notifications, dependent: :destroy
end
