# Seed de test : Sete (6 Quai Louis Pasteur) -> Usine Listel
# Usage: rails runner db/seeds/runs_test.rb

user = User.find_by(email: "test@mail.com") || User.first
abort "Aucun utilisateur. Cree d'abord un utilisateur." unless user

puts "Creation du run Sete -> Listel pour #{user.email}..."

run = Run.create!(
  user: user,
  duration: 2400,
  distance: 6.0,
  status: "ended",
  start_point: "6 Quai Louis Pasteur, 34200 Sete",
  start_point_lat: 43.40695835292269,
  start_point_lng: 3.698956726932721,
  started_at: 1.day.ago,
  ended_at: 1.day.ago + 40.minutes
)

# Points GPS extraits de Google Maps (parcours reel)
positions = [
  [43.40695835292269, 3.698956726932721],
  [43.40412040121782, 3.6968935456275074],
  [43.400442857590306, 3.696260836693909],
  [43.396065490242236, 3.6951604733311294],
  [43.3931848447357, 3.691770943630418],
  [43.39257635946037, 3.687393100241184],
  [43.39370792369188, 3.6797832920534015],
  [43.39270446212765, 3.673598486619685],
  [43.39398547397298, 3.666032750712067],
  [43.39314214423847, 3.6601270695131274],
  [43.391905058503326, 3.6571162648743303],
  [43.390261031981105, 3.6528265659828664],
  [43.38862763674436, 3.649183260217165],
  [43.38491229940384, 3.643865208938418],
  [43.38186019950345, 3.638709013304566],
  [43.37841139120095, 3.633508488031345],
  [43.37690581273485, 3.630820080925525]
]

positions.each { |lat, lng| run.positions.create!(latitude: lat, longitude: lng) }

puts "Run ##{run.id} cree avec #{positions.length} positions"
puts "URL: /runs/#{run.id}"
