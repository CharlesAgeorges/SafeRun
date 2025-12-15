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



Dans SEED

puts "..."
puts "Creating Challenges"
puts "..."

# Création des badges pour challenges si pas déjà créés
semi_marathon_bronze = Badge.find_or_create_by!(
  name: "Semi Marathonien Bronze",
  description: "Récompense pour avoir couru un run supérieur à 20km"
)

endurant_bronze = Badge.find_or_create_by!(
  name: "Endurant Bronze",
  description: "Récompense pour avoir couru un run supérieur à 60 minutes"
)

# Création des challenges
Challenge.create!(
  name: "Courir plus de 20 km",
  description: "Complétez un run supérieur à 20 km",
  condition: "distance >= 20",
  badge: semi_marathon_bronze
)

Challenge.create!(
  name: "Endurance : 60 minutes",
  description: "Complétez un run supérieur à 60 minutes",
  condition: "duration >= 3600",
  badge: endurant_bronze
)

badge_fast5k = Badge.find_or_create_by!(
  name: "Sprinteur 5K Bronze",
  description: "A terminé un 5 km en dessous de 30 minutes"
)

badge_fast10k = Badge.find_or_create_by!(
  name: "Sprinteur 10K Bronze",
  description: "A terminé un 10 km en dessous de 60 minutes"
)

badge_morning = Badge.find_or_create_by!(
  name: "Morning Runner",
  description: "Terminé un run avant 7h du matin"
)

badge_night = Badge.find_or_create_by!(
  name: "Night Performer",
  description: "Terminé un run après 22h"
)

badge_consistency = Badge.find_or_create_by!(
  name: "Régulier Bronze",
  description: "Couru 3 fois dans la même semaine"
)

badge_altitude = Badge.find_or_create_by!(
  name: "Grimpeur Bronze",
  description: "Run avec +200m de dénivelé positif"
)

badge_city_runner = Badge.find_or_create_by!(
  name: "Urban Runner",
  description: "Run réalisé dans un espace urbain majeur"
)

badge_speed = Badge.find_or_create_by!(
  name: "Rapide Bronze",
  description: "Atteint une vitesse moyenne supérieure à 10 km/h"
)

badge_long_week = Badge.find_or_create_by!(
  name: "Long Runner Bronze",
  description: "Run supérieur à 12 km"
)

badge_marathon_training = Badge.find_or_create_by!(
  name: "Marathon Training Starter",
  description: "A couru 4 heures cumulées en 7 jours"
)

badge_two_runs_day = Badge.find_or_create_by!(
  name: "Double Effort",
  description: "2 runs le même jour"
)

badge_lunch_run = Badge.find_or_create_by!(
  name: "Midday Runner",
  description: "Run effectué entre 12h et 14h"
)

badge_weekend_warrior = Badge.find_or_create_by!(
  name: "Weekend Warrior",
  description: "Run effectué un samedi ou un dimanche"
)

badge_multi_city = Badge.find_or_create_by!(
  name: "Globe Runner",
  description: "A couru dans 3 villes différentes"
)

badge_fast1k = Badge.find_or_create_by!(
  name: "Kilomètre Express",
  description: "A couru 1 km en moins de 5 minutes"
)

puts "Creating 15 new Challenges"
puts "..."

Challenge.find_or_create_by!(
  name: "5K en moins de 30 minutes",
  description: "Compléter un run de 5 km en dessous de 30 min",
  condition: "distance >= 5 AND duration <= 1800",
  badge: badge_fast5k
)

Challenge.find_or_create_by!(
  name: "10K en moins de 60 minutes",
  description: "Compléter un run de 10 km en moins de 60 min",
  condition: "distance >= 10 AND duration <= 3600",
  badge: badge_fast10k
)

Challenge.find_or_create_by!(
  name: "Run avant 7h",
  description: "Démarrer un run avant 7h du matin",
  condition: "started_at.hour < 7",
  badge: badge_morning
)

Challenge.find_or_create_by!(
  name: "Run après 22h",
  description: "Démarrer un run après 22h",
  condition: "started_at.hour >= 22",
  badge: badge_night
)

Challenge.find_or_create_by!(
  name: "3 runs en 7 jours",
  description: "Courir 3 fois en une semaine",
  condition: "runs_per_week >= 3",
  badge: badge_consistency
)

Challenge.find_or_create_by!(
  name: "Dénivelé +200m",
  description: "Atteindre au moins 200 m de dénivelé positif",
  condition: "elevation_gain >= 200",
  badge: badge_altitude
)

Challenge.find_or_create_by!(
  name: "Urban Runner",
  description: "Courir dans une grande ville",
  condition: "location_type = 'urban'",
  badge: badge_city_runner
)

Challenge.find_or_create_by!(
  name: "Vitesse moyenne > 10 km/h",
  description: "Maintenir une vitesse moyenne supérieure à 10 km/h",
  condition: "distance / duration * 3600 >= 10",
  badge: badge_speed
)

Challenge.find_or_create_by!(
  name: "Run supérieur à 12 km",
  description: "Effectuer un run d’au moins 12 km",
  condition: "distance >= 12",
  badge: badge_long_week
)

Challenge.find_or_create_by!(
  name: "4 heures cumulées en 7 jours",
  description: "Cumuler 4h de course en 7 jours",
  condition: "weekly_duration >= 14400",
  badge: badge_marathon_training
)

Challenge.find_or_create_by!(
  name: "Deux runs dans la même journée",
  description: "Faire 2 runs le même jour",
  condition: "runs_in_day >= 2",
  badge: badge_two_runs_day
)

Challenge.find_or_create_by!(
  name: "Run de midi",
  description: "Courir entre 12h et 14h",
  condition: "started_at.hour BETWEEN 12 AND 14",
  badge: badge_lunch_run
)

Challenge.find_or_create_by!(
  name: "Weekend Warrior",
  description: "Courir un samedi ou un dimanche",
  condition: "weekday IN ('Saturday','Sunday')",
  badge: badge_weekend_warrior
)

Challenge.find_or_create_by!(
  name: "Courir dans 3 villes différentes",
  description: "Avoir enregistré un run dans 3 villes distinctes",
  condition: "unique_cities >= 3",
  badge: badge_multi_city
)

Challenge.find_or_create_by!(
  name: "1 km sous 5 minutes",
  description: "Réaliser 1 km sous les 5 minutes",
  condition: "best_km <= 300",
  badge: badge_fast1k
)

puts "17 additional challenges created"
