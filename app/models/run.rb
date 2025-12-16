require "open-uri"
require "json"

class Run < ApplicationRecord
  belongs_to :user

  geocoded_by :start_point, latitude: :start_point_lat, longitude: :start_point_lng
  after_validation :geocode, if: :will_save_change_to_start_point?

  validates :duration, :distance, :status, :start_point, presence: true

  has_many :positions, dependent: :destroy
  has_many :incidents, dependent: :destroy
  has_many :guardian_notifications, dependent: :destroy
  has_many :guardians, through: :guardian_notifications
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
    return nil unless (seconds = real_duration)

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

    coords = matched_coordinates
    return nil if coords.nil? || coords.empty?

    simplified = simplify_coordinates(coords, 50)
    geojson = {
      type: "Feature",
      properties: { "stroke" => "#1b146f", "stroke-width" => 5 },
      geometry: { type: "LineString", coordinates: simplified }
    }

    encoded = URI.encode_www_form_component(geojson.to_json)
    "https://api.mapbox.com/styles/v1/mapbox/streets-v10/static/geojson(#{encoded})/auto/#{width}x#{height}?access_token=#{ENV['MAPBOX']}"
  end

  def matched_coordinates
    raw_coords = positions.order(:created_at).map { |p| [p.longitude, p.latitude] }
    return raw_coords if raw_coords.length < 2

    coords_string = raw_coords.map { |c| c.join(",") }.join(";")
    radiuses = Array.new(raw_coords.length, "50").join(";")
    url = "https://api.mapbox.com/matching/v5/mapbox/walking/#{coords_string}?geometries=geojson&radiuses=#{radiuses}&overview=full&access_token=#{ENV['MAPBOX']}"

    begin
      data = JSON.parse(URI.open(url).read)
      return data.dig("matchings", 0, "geometry", "coordinates") || raw_coords if data["code"] == "Ok"

      Rails.logger.warn("[Map Matching] #{data['code']}: #{data['message']}")
      raw_coords
    rescue StandardError => e
      Rails.logger.error("[Map Matching] #{e.message}")
      raw_coords
    end
  end

  # Check si la run est visible
  def visible_to?(user)
    user == self.user || self.public?
  end

  private

  def simplify_coordinates(coords, max_points)
    return coords if coords.length <= max_points

    step = (coords.length - 1).to_f / (max_points - 1)
    (0...max_points).map { |i| coords[(i * step).round] }
  end

  def award_badges_if_ended
    BadgeAwardService.new(self).award_badges if saved_change_to_status? && status == "ended"
  end
end
