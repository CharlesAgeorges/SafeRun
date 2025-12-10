class GuardianNotificationsController < ApplicationController
  before_action :client, only: [:run_start_alert]

  def run_start_alert
    @run = current_user.runs.find(params[:id])
    @guardians = @run.guardians
    @guardians.each do |guardian|
      client.messages.create(
        from: @client_twilio_phone,
        to: guardian.phone_number,
        body: "#{current_user.name} a démarré une run #{@run.start_point}, qui devrait durer #{@run.duration}minutes, jètes un oeil à tes notifs le moment venu pour savoir si tout est ok!"
      )
    end
  end

  def run_end_alert

  end

  def over_time_alert

  end

  private
  # account_sid = TWILIO_ACCOUNT_SID
  # auth_token = TWILIO_AUTH_TOKEN
  # client_twilio_phone = TWILIO_PHONE_NUMBER


  def client
    @account_sid = ENV['TWILIO_ACCOUNT_SID']
    @auth_token = ENV['TWILIO_AUTH_TOKEN']
    @client_twilio_phone = ENV['TWILIO_PHONE_NUMBER']
    @client = Twilio::REST::Client.new @account_sid, @auth_token
  end

end
