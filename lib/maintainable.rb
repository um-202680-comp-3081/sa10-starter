# Tracks how many hours a machine has run since its last service.
# A class that includes it must define service_interval.
module Maintainable
  def get_hours_since_service
    @hours_since_service || 0
  end

  def log_use(hours)
    raise ArgumentError, "Hours must be a positive integer" unless hours.is_a?(Integer) && hours.positive?
    @hours_since_service = get_hours_since_service + hours
    nil
  end

  def needs_service?
    get_hours_since_service >= service_interval
  end

  def record_service
    @hours_since_service = 0
    nil
  end
end
