class Member
  TRAININGS = ["laser safety", "printer basics"].freeze

  attr_accessor :certifications
  attr_reader :email

  def initialize(name, email)
    raise ArgumentError, "Name must be a non-empty string" unless name.is_a?(String) && !name.strip.empty?
    @name = name
    @email = email
    @certifications = []
    @reservations = []
  end

  def add_reservation(reservation)
    @reservations << reservation
    nil
  end

  def certified_for?(training)
    @certifications.include?(training)
  end

  def certify(training)
    raise ArgumentError, "Training must be one of: #{TRAININGS.join(", ")}" unless TRAININGS.include?(training)
    @certifications << training unless certified_for?(training)
    nil
  end

  def get_name
    @name
  end

  def get_reservations
    @reservations.dup
  end
end
