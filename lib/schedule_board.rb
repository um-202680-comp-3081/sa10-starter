# The screen in the lobby that shows the day's reservations.
class ScheduleBoard
  def initialize(location)
    raise ArgumentError, "Location must be a non-empty string" unless location.is_a?(String) && !location.strip.empty?
    @location = location
  end

  def display(lines)
    puts "+-- #{@location} " + "-" * 40
    lines.each { |line| puts "| #{line}" }
    puts "+" + "-" * (44 + @location.length)
    nil
  end
end
