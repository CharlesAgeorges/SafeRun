class GuardianNotificationsController < ApplicationController
  before_action :set_run

  def incident_alert
    TwilioService.new.incident_alert(@run, current_user)
    redirect_to @run, notice: "Alerte envoyée aux guardians"
  end

  def over_time_alert
    TwilioService.new.over_time_alert(@run, current_user)
  end

  private

  def set_run
    @run = current_user.runs.find(params[:id])
  end
end
