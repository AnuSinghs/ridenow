require 'test_helper'

class JourneyMailerTest < ActionMailer::TestCase
  test "route_email" do
    mail = JourneyMailer.route_email
    assert_equal "Route email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
