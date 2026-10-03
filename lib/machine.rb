# A machine members can reserve. Each kind of machine is a subclass.
class Machine
  def initialize(name)
    raise ArgumentError, "Name must be a non-empty string" unless name.is_a?(String) && !name.strip.empty?
    @name = name
  end

  def get_name
    @name
  end

  def hourly_rate
    raise NotImplementedError, "#{self.class} must define hourly_rate"
  end

  def required_training
    raise NotImplementedError, "#{self.class} must define required_training"
  end

  private

  def service_interval
    raise NotImplementedError, "#{self.class} must define service_interval"
  end
end
