# class GuardianNotificationsController < ApplicationController
#   before_action :client, :get_guardians, only: [:run_start_alert, :run_end_alert, :over_time_alert, :incident_alert]

#   def run_start_alert
#     @guardians.each do |guardian|
#       send_sms(guardian.phone_number,"#{current_user.name} a démarré une run à #{@run.start_point}, qui devrait durer #{@run.duration}minutes, jètes un oeil à tes notifs le moment venu pour savoir si tout est ok!")
#     end
#   end

#   def run_end_alert
#     @guardians.each do |guardian|
#       send_sms(guardian.phone_number,"#{current_user.name} a terminé sa run à #{@run.start_point}, merci d'avoir été son Guardian Angel!")
#     end
#   end

#   def over_time_alert
#     @guardians.each do |guardian|
#       send_sms(guardian.phone_number,"#{current_user.name} était sensé(e) terminer sa run à #{@run.start_point} il y'a 5 minutes mais n'a pas donné de nouvelles, passes lui un petit coup de fil pour vérifier que tout va bien!")
#     end
#   end

#   def incident_alert
#     @guardians.each do |guardian|
#       send_sms(guardian.phone_number,"#{current_user.name} t'envoie cette alerte depuis sa run à #{@run.start_point}, prends contact avec il/elle ou les secours si tu n'arrives plus à l'avoir")
#     end
#   end

#   private
#   # account_sid = TWILIO_ACCOUNT_SID
#   # auth_token = TWILIO_AUTH_TOKEN
#   # client_twilio_phone = TWILIO_PHONE_NUMBER
#   def get_guardians
#     @run = current_user.runs.find(params[:id])
#     @guardians = @run.guardians
#   end

#   def client
#     @account_sid = ENV['TWILIO_ACCOUNT_SID']
#     @auth_token = ENV['TWILIO_AUTH_TOKEN']
#     @client_twilio_phone = ENV['TWILIO_PHONE_NUMBER']
#     @client = Twilio::REST::Client.new @account_sid, @auth_token
#   end

#   def send_sms(phone_number, body)
#     client.messages.create(
#       from: @client_twilio_phone,
#       to: phone_number,
#       body: body
#     )
#   end
# end
