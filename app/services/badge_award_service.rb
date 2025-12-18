# Service pour attribuer automatiquement les badges aux runs
# Basé sur les conditions définies pour chaque badge
class BadgeAwardService
  def initialize(run)
    @run = run
    @user = run.user
  end

  def award_badges
    return [] unless @run.status == "ended"

    user_badge_ids = @user.runs.joins(:badges).pluck('badges.id').uniq

    awarded = []
    Badge.all.each do |badge|
      next if user_badge_ids.include?(badge.id)

      if badge_earned?(badge)
        @run.run_badges.create!(badge: badge)
        awarded << badge
        Rails.logger.info "Badge '#{badge.name}' attribué au run ##{@run.id}"
      end
    end
    awarded
  end

  private

  def badge_earned?(badge)
    case badge.name
    # Badges de distance
    when "Semi Marathonien Bronze"
      @run.distance >= 20
    when "Long Runner Bronze"
      @run.distance >= 12
    when "Sprinteur 5KM Bronze"
      @run.distance >= 5 && run_duration <= 1800
    when "Sprinteur 10KM Bronze"
      @run.distance >= 10 && run_duration <= 3600
    when "Kilomètre Express"
      best_km_time <= 300

    # Badges de durée
    when "Endurant Bronze"
      run_duration >= 3600

    # Badges de vitesse
    when "Rapide Bronze"
      average_speed >= 10

    # Badges horaires
    when "Runner du matin"
      @run.started_at.present? && @run.started_at.hour < 7
    when "Performeur de nuit", "Hibou de Nuit"
      @run.started_at.present? && @run.started_at.hour >= 22
    when "Runner du midi"
      @run.started_at.present? && @run.started_at.hour.between?(12, 14)

    # Badges hebdomadaires
    when "Guerrier du Week-End"
      @run.started_at.present? && @run.started_at.wday.in?([0, 6]) # 0=dimanche, 6=samedi

    # Badges de régularité (basés sur l'historique utilisateur)
    when "Régulier Bronze"
      runs_in_same_week >= 3
    when "Double Effort"
      runs_same_day >= 2
    when "Entraînement Marathon"
      weekly_duration >= 14400 # 4 heures en secondes

    # Badges de localisation
    when "Runner Urbain"
      urban_location?
    when "Runner du monde"
      unique_cities >= 3

    # Badges de dénivelé (nécessite un champ elevation_gain)
    when "Grimpeur Bronze"
      @run.respond_to?(:elevation_gain) && @run.elevation_gain >= 200

    else
      false
    end
  rescue => e
    Rails.logger.error "Erreur lors de la vérification du badge '#{badge.name}': #{e.message}"
    false
  end

  # Méthodes helpers pour calculs

  def run_duration
    # Utilise la durée réelle si disponible, sinon la durée planifiée
    @run.real_duration || @run.duration
  end

  def average_speed
    return 0 if run_duration.zero?
    (@run.distance / run_duration) * 3600 # km/h
  end

  def best_km_time
    # Approximation : temps moyen par km
    return Float::INFINITY if @run.distance.zero?
    run_duration / @run.distance
  end

  def runs_in_same_week
    return 0 unless @run.started_at.present?

    week_start = @run.started_at.beginning_of_week
    week_end = @run.started_at.end_of_week

    @user.runs.where(status: "ended")
         .where(started_at: week_start..week_end)
         .count
  end

  def runs_same_day
    return 0 unless @run.started_at.present?

    day_start = @run.started_at.beginning_of_day
    day_end = @run.started_at.end_of_day

    @user.runs.where(status: "ended")
         .where(started_at: day_start..day_end)
         .count
  end

  def weekly_duration
    return 0 unless @run.started_at.present?

    week_start = @run.started_at.beginning_of_week
    week_end = @run.started_at.end_of_week

    # Somme des durées réelles des runs de la semaine
    @user.runs.where(status: "ended")
         .where(started_at: week_start..week_end)
         .select { |run| run.real_duration.present? }
         .sum { |run| run.real_duration }
  end

  def urban_location?
    # Vérifier si la localisation contient des mots-clés urbains
    return false unless @run.start_point.present?

    urban_keywords = ["Paris", "Lyon", "Marseille", "Nice", "Toulouse", "Bordeaux", "Lille"]
    urban_keywords.any? { |keyword| @run.start_point.include?(keyword) }
  end

  def unique_cities
    # Compter le nombre de villes uniques dans les runs de l'utilisateur
    @user.runs.where(status: "ended")
         .pluck(:start_point)
         .map { |location| extract_city(location) }
         .compact
         .uniq
         .count
  end

  def extract_city(location)
    return nil unless location.present?

    # Extraire la ville (partie après la virgule si présente)
    parts = location.split(",")
    parts.length > 1 ? parts.last.strip : parts.first.strip
  end
end
