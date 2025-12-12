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
        body: "🏃 #{user.name} a démarré une run !\n\n📍 #{run.start_point}\n⏱️ Durée prévue : #{run.duration} minutes.\n\nOn te tient au courant quand c'est terminé 👍"
      )
    end
  end

  def run_end_alert(run, user)
    run.guardians.each do |guardian|
      send_sms(
        to: guardian.phone_number,
        body: "✅ #{user.name} a terminé sa run !\n\n📍 #{run.start_point}\n\nMerci d'avoir été son Guardian Angel 🛡️"
      )
    end
  end

  def over_time_alert(run, user)
    run.guardians.each do |guardian|
      send_sms(
        to: guardian.phone_number,
        body: "⚠️ #{user.name} devait terminer sa run il y a 5 minutes.\n\n📍 #{run.start_point}\n\nPasse-lui un coup de fil pour vérifier que tout va bien 📞"
      )
    end
  end

  def incident_alert(run, user)
    run.guardians.each do |guardian|
      send_sms(
        to: guardian.phone_number,
        body: "🚨 ALERTE de #{user.name} !\n\n📍 #{run.start_point}\n\nContacte-le/la ou appelle les secours si pas de réponse 🆘"
      )
    end
  end
end
