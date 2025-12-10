class GuardianNotificationsController < ApplicationController
  def run_start_alert
    @run = current_user.runs.find(params[:run_id])
    @guardians = @run.guardians
    client.messages.create(
      from: "#{client_twilio_phone}",
      to: "#{@guardians.phone_number}",
      body: "#{current_user.name} started running in #{@run.start_point}, and is supposed to run for #{@run.duration}, look for news from them after the time went by!"
    )
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
  account_sid = TWILIO_ACCOUNT_SID
  auth_token = TWILIO_AUTH_TOKEN
  client_twilio_phone = TWILIO_PHONE_NUMBER
    @client = Twilio::REST::Client.new account_sid, auth_token
  end

end
