class Guardian < ApplicationRecord
  belongs_to :user
  has_many :guardian_notifications, dependent: :destroy
  has_many :runs, through: :guardian_notifications

  validates :name, presence: true
  validates :phone_number, presence: true,
            format: { with: /\A\+?[\d\s-]{10,}\z/, message: "Format Invalide" },
            uniqueness: { scope: :user_id, message: "Guardian déjà utilisé pour ce compte" }
end
