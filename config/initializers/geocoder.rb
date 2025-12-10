Geocoder.configure(
  timeout: 5,
  lookup: :mapbox,
  api_key: ENV['MAPBOX'],
  units: :km,
)
