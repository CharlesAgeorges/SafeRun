# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Erasing previous data"

Run.destroy_all
Guardian.destroy_all
Badge.destroy_all


puts "..."

puts "Creating User"

puts "..."

user = User.create!(email: "mail@mail.com") do |user|
  user.password = "secret"
  user.name = "Poutou Philippe"
  user.phone_number = "+33606060606"
end

puts "User Created"

puts "..."

puts "Creating Runs"

puts "..."

Run.create!(
  user: user,
  duration: 2100,
  distance: 6.5,
  status: "ended",
  start_point: "Jardin du Luxembourg, Paris",
  start_point_lat: 48.8462,
  start_point_lng: 2.3372,
  started_at: 2.days.ago,
  ended_at: 2.days.ago + 35.minutes
)

Run.create!(
  user: user,
  duration: 3000,
  distance: 9.0,
  status: "ended",
  start_point: "Bois de Vincennes, Paris",
  start_point_lat: 48.8325,
  start_point_lng: 2.4346,
  started_at: 4.days.ago,
  ended_at: 4.days.ago + 50.minutes
)

Run.create!(
  user: user,
  duration: 1800,
  distance: 5.0,
  status: "ended",
  start_point: "Parc de la Tête d'Or, Lyon",
  start_point_lat: 45.7772,
  start_point_lng: 4.8558,
  started_at: 1.week.ago,
  ended_at: 1.week.ago + 30.minutes
)

Run.create!(
  user: user,
  duration: 2400,
  distance: 7.5,
  status: "ended",
  start_point: "Promenade des Anglais, Nice",
  start_point_lat: 43.6942,
  start_point_lng: 7.2654,
  started_at: 3.days.ago,
  ended_at: 3.days.ago + 40.minutes
)

Run.create!(
  user: user,
  duration: 3600,
  distance: 10.0,
  status: "planned",
  start_point: "Champ de Mars, Paris",
  start_point_lat: 48.8556,
  start_point_lng: 2.2986,
  started_at: nil,
  ended_at: nil
)


puts "5 Runs created"

puts "..."

puts "Creating Guardians"

puts "1 Guardian created"

puts "..."

Guardian.create!(
  user: user,
  name: "Brendan Le Sage",
  phone_number: "+33612345678"
)



puts "Guardians added"

puts "..."

puts "Creating Badges"

puts "..."

Badge.create!(
  name: "Night Owl",
  description: "Completed a run after dark. You're not afraid of the night!"
)

puts "1 Badge created"

puts "Amazing Badges Created"

puts "Seeds up and running, SafeRunning!"
