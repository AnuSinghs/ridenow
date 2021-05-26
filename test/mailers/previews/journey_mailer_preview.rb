# Preview all emails at http://localhost:3000/rails/mailers/journey_mailer
class JourneyMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/journey_mailer/route_email
  def route_email
    JourneyMailer.route_email
  end

end
