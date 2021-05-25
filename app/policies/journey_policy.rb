class JourneyPolicy
  attr_reader :user, :journey

  def initialize(user, journey)
    @user = user
    @journey = journey
  end

  def edit?
    update?
  end

  def update?
    journey.user == user
  end

  # def destroy?
  #   record.user == user
  # end
end
