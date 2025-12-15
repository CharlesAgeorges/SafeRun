class BadgesController < ApplicationController
  def index
    # Récupérer tous les badges obtenus par l'utilisateur via ses runs terminés
    @earned_badges = Badge.joins(:runs)
                          .where(runs: { user_id: current_user.id, status: "ended" })
                          .select('badges.*, COUNT(runs.id) as runs_count')
                          .group('badges.id')
                          .order('badges.name')

    # IDs des badges déjà obtenus
    earned_badge_ids = @earned_badges.pluck(:id)

    # Badges à obtenir (tous les autres badges)
    @available_badges = Badge.where.not(id: earned_badge_ids).order(:name)
  end

  def show
    @badge = Badge.find(params[:id])
  end
end
