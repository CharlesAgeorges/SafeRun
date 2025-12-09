class Incident < ApplicationRecord
  belongs_to :run
  validates :incident_detail, presence: true
end
