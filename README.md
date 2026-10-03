# Makerspace Reservations — Starter Code

## Development Scenario

Your team is building the reservation system for the campus makerspace, where members book time on its laser cutter and 3D printer. Last week the team agreed on a design and drew it as a class diagram: [`class-diagram.md`](class-diagram.md).

One teammate wrote the first version of the code over a weekend, quickly and from memory. It runs, and most of what it prints looks right, but in places it drifted from the design. Before it can be merged, **the code has to match the diagram.**

> Professor's Note: This is a teaching tool, **not how a real reservation system works.** A real one would store reservations in a database, book by date and minute rather than by whole hour on one day, and send members confirmations. The design here is kept small on purpose.

## The Rules

These are the makerspace's rules. The code must follow them.

- **Money is in cents.** The laser cutter costs $15.00 an hour and the 3D printer $4.00 an hour. A reservation costs its hours times its machine's hourly rate.
- **To book a machine, a member must be enrolled in the makerspace and certified for that machine's training:** *laser safety* for a laser cutter, *printer basics* for a 3D printer.
- **Reservations are booked in whole hours on a single day:** each starts on the hour, from 0:00 to 23:00, and ends no later than 24:00.
- **A machine cannot be booked twice at once.** Back-to-back bookings are fine: a reservation that ends at 11:00 and one that starts at 11:00 do not overlap.
- **Reservations are numbered R-1, R-2, R-3, …** in the order they are made, across the whole makerspace. A request that is refused does not get a number.
- **At closing,** each reservation's hours are logged on its machine, and the day's reservations are cleared.
- **A laser cutter needs service every 40 hours of use,** and a 3D printer every 200.
- **Bad values are refused** with an `ArgumentError` that says what was wrong: a blank name, location, or filament; a training other than *laser safety* or *printer basics*; hours that are not a positive whole number; a thickness that is not a positive number; a reservation that starts outside 0 to 23 or runs past 24:00; or adding the same machine or member twice.

## Code Conventions

- **Getters are custom methods named `get_<attribute>`,** such as `get_name`, written out with `def`. This breaks Ruby's usual style on purpose: Ruby code normally writes `attr_reader :name` and calls the getter `name`. Here a getter's name says what it does and never matches the attribute it reads, so the code lines up with the class diagram.
- **`attr_accessor` is used only for public (`+`) attributes.** No `attr_reader` or `attr_writer`.

## Classes

| File | Class or module |
| ---- | --------------- |
| `lib/makerspace.rb` | `Makerspace`: the machines, members, and the day's reservations |
| `lib/reservation.rb` | `Reservation`: one member's booking of one machine |
| `lib/member.rb` | `Member`: a person who can book machines once certified |
| `lib/machine.rb` | `Machine`: the parent of every kind of machine |
| `lib/laser_cutter.rb` | `LaserCutter` |
| `lib/three_d_printer.rb` | `ThreeDPrinter` |
| `lib/maintainable.rb` | `Maintainable`: tracks hours of use between services |
| `lib/schedule_board.rb` | `ScheduleBoard`: the screen in the lobby that shows the day's reservations |

## Running It

```text
ruby demo.rb
```

`irb -r ./demo.rb` runs the demo, then leaves you in `irb` with every class loaded and the demo's objects gone (they were local to the file).
