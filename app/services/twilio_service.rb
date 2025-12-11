class TwilioService
  def initialize
    @client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
    @from = ENV['TWILIO_PHONE_NUMBER']
  end

  def send_sms(to:, body:)
    @client.messages.create(
      from: @from,
      to: to,
      body: body
    )
  end

  def run_start_alert(run, user)
    run.guardians.each do |guardian|
      send_sms(
        to: guardian.phone_number,
        body: "#{user.name} a démarré une run à #{run.start_point}, qui devrait durer #{run.duration} minutes, jettes un oeil à tes notifs le moment venu pour savoir si tout est ok!"
      )
    end
  end

  def run_end_alert(run, user)
    run.guardians.each do |guardian|
      send_sms(
        to: guardian.phone_number,
        body: "#{user.name} a terminé sa run à #{run.start_point}, merci d'avoir été son Guardian Angel!"
      )
    end
  end

  def over_time_alert(run, user)
    run.guardians.each do |guardian|
      send_sms(
        to: guardian.phone_number,
        body: "#{user.name} était sensé(e) terminer sa run à #{run.start_point} il y'a 5 minutes mais n'a pas donné de nouvelles, passes lui un petit coup de fil pour vérifier que tout va bien!"
      )
    end
  end

  def incident_alert(run, user)
    run.guardians.each do |guardian|
      send_sms(
        to: guardian.phone_number,
        body: "#{user.name} t'envoie cette alerte depuis sa run à #{run.start_point}, prends contact avec il/elle ou les secours si tu n'arrives plus à l'avoir"
      )
    end
  end
end
