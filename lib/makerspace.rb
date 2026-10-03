require_relative "reservation"

class Makerspace
  def initialize(name, board)
    raise ArgumentError, "Name must be a non-empty string" unless name.is_a?(String) && !name.strip.empty?
    @name = name
    @board = board
    @machines = []
    @members = []
    @reservations = []
  end

  def add_machine(machine)
    raise ArgumentError, "#{machine.get_name} is already in #{@name}" if @machines.include?(machine)

    @machines << machine
    nil
  end

  def add_reservation(reservation)
    member = reservation.get_member
    raise ArgumentError, "#{member.get_name} is not a member of #{@name}" unless @members.include?(member)

    reservation.get_machines.each do |machine|
      raise ArgumentError, "#{machine.get_name} is not in #{@name}" unless @machines.include?(machine)
      training = machine.required_training
      raise ArgumentError, "#{member.get_name} is not certified for #{training}" unless member.certified_for?(training)

      conflict = find_conflict(machine, reservation.get_start_hour, reservation.get_hours)
      if conflict
        raise ArgumentError, "#{machine.get_name} is already booked " \
                             "#{conflict.get_start_hour}:00-#{conflict.end_hour}:00 (R-#{conflict.get_number})"
      end
    end

    @reservations << reservation
    member.add_reservation(reservation)
    reservation
  end

  def close_day
    @reservations.each do |reservation|
      reservation.get_machines.each { |machine| machine.log_use(reservation.get_hours) }
    end
    @reservations.clear
    nil
  end

  def enroll(member)
    raise ArgumentError, "#{member.get_name} is already a member of #{@name}" if @members.include?(member)

    @members << member
    nil
  end

  def find_conflict(machine, start_hour, hours)
    @reservations.find do |reservation|
      reservation.get_machines.include?(machine) && reservation.overlaps?(start_hour, start_hour + hours)
    end
  end

  def get_name
    @name
  end

  def post_schedule
    @board.display(@reservations.sort_by { |r| [r.get_start_hour, r.get_number] }.map(&:to_s))
    nil
  end

  def summary
    "#{@name}: #{@machines.size} machines, #{@members.size} members, #{@reservations.size} reservations"
  end
end
