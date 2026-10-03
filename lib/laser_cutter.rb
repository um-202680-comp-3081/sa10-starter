require_relative "machine"

class LaserCutter < Machine
  def initialize(name, max_thickness_mm)
    super(name)
    unless max_thickness_mm.is_a?(Numeric) && max_thickness_mm.positive?
      raise ArgumentError, "Max thickness must be a positive number"
    end
    @max_thickness_mm = max_thickness_mm
    @hours_since_service = 0
  end

  def can_cut?(thickness_mm)
    thickness_mm <= @max_thickness_mm
  end

  def get_hours_since_service
    @hours_since_service
  end

  def hourly_rate
    1500
  end

  def log_use(hours)
    raise ArgumentError, "Hours must be a positive integer" unless hours.is_a?(Integer) && hours.positive?
    @hours_since_service += hours
    nil
  end

  def needs_service?
    @hours_since_service >= service_interval
  end

  def record_service
    @hours_since_service = 0
    nil
  end

  def required_training
    "laser safety"
  end

  def to_s
    "#{@name} (laser cutter, cuts up to #{@max_thickness_mm} mm)"
  end

  private

  def service_interval
    40
  end
end
