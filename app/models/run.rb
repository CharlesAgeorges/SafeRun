class Run < ApplicationRecord
  belongs_to :user

  geocoded_by :start_point, latitude: :start_point_lat, longitude: :start_point_lng
  after_validation :geocode, if: :will_save_change_to_start_point?

  validates :duration, :distance, :status, :start_point, presence: true
  has_many :positions, dependent: :destroy
  has_many :incidents, dependent: :destroy
  has_many :guardian_notifications, dependent: :destroy
  has_many :guardians, through: :guardian_notifications # ajout
  has_many :run_badges, dependent: :destroy
  has_many :badges, through: :run_badges

  # Vérifie si la run est publique (donc finie)
  scope :safe_run, -> {where(status: "ended", public: true)}

  # Attribution automatique des badges quand le run se termine a checker !
  after_update :award_badges_if_ended

  def real_duration
    return nil unless started_at && ended_at

    (ended_at - started_at).to_i - (paused_duration || 0)
  end

  def real_duration_formatted
    seconds = real_duration
    return nil unless seconds

    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    secs = seconds % 60

    if hours > 0
      "#{hours}h #{minutes}min #{secs}s"
    elsif minutes > 0
      "#{minutes}min #{secs}s"
    else
      "#{secs}s"
    end
  end

  def static_map_url(width: 300, height: 200)
    return nil if positions.count < 2

    coords = positions.order(:created_at).map { |position| [position.longitude, position.latitude] }

    geojson = {
      type: "Feature",
      properties: { "stroke" => "#1b146f", "stroke-width" => 5 },
      geometry: { type: "LineString", coordinates: coords }
    }

    encoded_geojson = URI.encode_www_form_component(geojson.to_json)

    "https://api.mapbox.com/styles/v1/mapbox/streets-v10/static/geojson(#{encoded_geojson})/auto/#{width}x#{height}?access_token=#{ENV['MAPBOX']}"
  end

  # Check si la run est visible
  def visible_to?(user)
    user == self.user || self.public?
  end

  private

  def award_badges_if_ended
    if saved_change_to_status? && status == "ended"
      BadgeAwardService.new(self).award_badges
    end
  end
end
