require_relative "lib/makerspace"
require_relative "lib/member"
require_relative "lib/laser_cutter"
require_relative "lib/three_d_printer"
require_relative "lib/schedule_board"

def dollars(cents)
  format("$%.2f", cents / 100.0)
end

cutter = LaserCutter.new("Glowforge Pro", 6)
printer = ThreeDPrinter.new("Prusa MK4", "PLA")
cutter.log_use(37) # hours since its last service, carried over from last week

board = ScheduleBoard.new("Lobby screen")
space = Makerspace.new("Tiger Makerspace", board)
space.add_machine(cutter)
space.add_machine(printer)

ana = Member.new("Ana Ruiz", "ana.ruiz@example.com")
ben = Member.new("Ben Okafor", "ben.okafor@example.com")
space.enroll(ana)
space.enroll(ben)
ana.certify("laser safety")
ana.certify("printer basics")
ben.certifications << "printer basics"

puts space.summary
puts "  #{cutter}: #{dollars(cutter.hourly_rate)}/hour"
puts "  #{printer}: #{dollars(printer.hourly_rate)}/hour"

puts
puts "Requests:"
requests = [
  [ana, [cutter], 9, 2],
  [ben, [printer], 9, 4],
  [ana, [cutter], 11, 1],
  [ben, [cutter], 13, 1],
  [ana, [printer], 12, 2]
]
booked = []
requests.each do |member, machines, start_hour, hours|
  reservation = space.add_reservation(Reservation.new(member, machines, start_hour, hours))
  booked << reservation
  puts "  Booked   #{reservation}"
rescue ArgumentError => e
  puts "  Refused  #{e.message}"
end
puts "Reservations made: #{booked.last.get_reservations_made}"

puts
anas = ana.get_reservations
puts "#{ana.get_name}: #{anas.map { |r| "R-#{r.get_number}" }.join(", ")}, " \
     "total #{dollars(anas.sum(&:cost))}"

puts
space.post_schedule

puts
space.close_day
puts "After closing:"
[cutter, printer].each do |machine|
  status = machine.needs_service? ? "needs service" : "OK"
  puts "  #{machine.get_name}: #{machine.get_hours_since_service} hours since service, #{status}"
end
cutter.record_service
puts "  #{cutter.get_name} serviced: #{cutter.get_hours_since_service} hours since service"
puts space.summary
