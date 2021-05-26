class JourneyMailer < ApplicationMailer

  def route_email
    @journey = params[:journey]
    mail(to: @journey.user.email, subject: "Route for #{@journey.name} created!")
  end
end
