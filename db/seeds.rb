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

puts "Creating Runs"

puts "..."

puts "Runs created"

puts "..."

puts "Creating Guardians"

puts "..."

puts "Guardians added"

puts "..."

puts "Creating Badges"

puts "..."

puts "Amazing Badges Created"

puts "Seeds up and running, SafeRunning!"
