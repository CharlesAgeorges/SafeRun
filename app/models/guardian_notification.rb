class GuardianNotification < ApplicationRecord
  belongs_to :run
  belongs_to :guardian
end
