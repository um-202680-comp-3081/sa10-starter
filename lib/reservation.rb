class Reservation
  def self.validate_times(start_hour, hours)
    unless start_hour.is_a?(Integer) && start_hour.between?(0, 23)
      raise ArgumentError, "Start hour must be an integer from 0 to 23"
    end
    raise ArgumentError, "Hours must be a positive integer" unless hours.is_a?(Integer) && hours.positive?
    raise ArgumentError, "A reservation must end by 24:00" if start_hour + hours > 24

    nil
  end

  def initialize(member, machines, start_hour, hours)
    raise ArgumentError, "A reservation needs at least one machine" if machines.empty?
    self.class.validate_times(start_hour, hours)

    @next_number = 1
    @member = member
    @machines = machines
    @start_hour = start_hour
    @hours = hours
    @number = @next_number
    @next_number += 1
  end

  def cost
    @machines.sum { |machine| @hours * machine.hourly_rate }
  end

  def end_hour
    @start_hour + @hours
  end

  def get_hours
    @hours
  end

  def get_machines
    @machines.dup
  end

  def get_member
    @member
  end

  def get_number
    @number
  end

  def get_reservations_made
    @next_number - 1
  end

  def get_start_hour
    @start_hour
  end

  def overlaps?(from_hour, to_hour)
    from_hour <= end_hour && @start_hour <= to_hour
  end

  def to_s
    names = @machines.map(&:get_name).join(" + ")
    times = "#{@start_hour}:00-#{end_hour}:00"
    format("R-%d  %-10s  %-13s  %-11s  $%.2f",
           @number, @member.get_name, names, times, cost / 100.0)
  end
end
