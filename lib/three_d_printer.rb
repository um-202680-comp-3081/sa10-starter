require_relative "maintainable"

class ThreeDPrinter
  include Maintainable

  def initialize(name, filament)
    raise ArgumentError, "Name must be a non-empty string" unless name.is_a?(String) && !name.strip.empty?
    @name = name
    load_filament(filament)
  end

  def get_filament
    @filament
  end

  def get_name
    @name
  end

  def hourly_rate
    400
  end

  def load_filament(filament)
    raise ArgumentError, "Filament must be a non-empty string" unless filament.is_a?(String) && !filament.strip.empty?
    @filament = filament
    nil
  end

  def required_training
    "printer basics"
  end

  def to_s
    "#{@name} (3D printer, loaded with #{@filament})"
  end

  private

  def service_interval
    200
  end
end
