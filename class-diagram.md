# Makerspace Reservations: Class Diagram

The team's agreed design. GitHub draws the diagram below from its Mermaid source; `class-diagram.png` is the same diagram as an image.

```mermaid
---
config:
  layout: dagre
  rankSpacing: 110
  nodeSpacing: 70
  flowchart:
    rankSpacing: 110
    nodeSpacing: 70
  class:
    hideEmptyMembersBox: true
---
classDiagram
    class Maintainable {
        <<module>>
        # hours_since_service: Integer = 0
        + get_hours_since_service() Integer
        + log_use(hours: Integer)
        + needs_service?() Boolean
        + record_service()
    }
    class Machine {
        <<abstract>>
        # name: String
        + get_name() String
        + hourly_rate() Integer*
        + required_training() String*
        # service_interval() Integer*
    }
    class LaserCutter {
        - max_thickness_mm: Float
        + can_cut?(thickness_mm: Float) Boolean
        + hourly_rate() Integer
        + required_training() String
        # service_interval() Integer
        + to_s() String
    }
    class ThreeDPrinter {
        - filament: String
        + get_filament() String
        + hourly_rate() Integer
        + load_filament(filament: String)
        + required_training() String
        # service_interval() Integer
        + to_s() String
    }
    class Member {
        - certifications: Array~String~
        + email: String
        - name: String
        + TRAININGS: Array~String~$
        + certified_for?(training: String) Boolean
        + certify(training: String)
        + get_name() String
    }
    class Reservation {
        - hours: Integer
        - machine: Machine
        - member: Member
        - next_number: Integer = 1$
        - number: Integer
        - start_hour: Integer
        + cost() Integer
        + end_hour() Integer
        + get_hours() Integer
        + get_machine() Machine
        + get_member() Member
        + get_number() Integer
        + get_reservations_made() Integer$
        + get_start_hour() Integer
        + overlaps?(from_hour: Integer, to_hour: Integer) Boolean
        + to_s() String
        + validate_times(start_hour: Integer, hours: Integer)$
    }
    class Makerspace {
        - machines: Array~Machine~
        - members: Array~Member~
        - name: String
        - reservations: Array~Reservation~
        + add_machine(machine: Machine)
        + close_day()
        + enroll(member: Member)
        - find_conflict(machine: Machine, start_hour: Integer, hours: Integer) Reservation
        + get_name() String
        + post_schedule(board: ScheduleBoard)
        + reservations_for(member: Member) Array~Reservation~
        + reserve(member: Member, machine: Machine, start_hour: Integer, hours: Integer) Reservation
        + summary() String
    }
    class ScheduleBoard {
        - location: String
        + display(lines: Array~String~)
    }
    Maintainable <|.. Machine
    Machine <|-- LaserCutter
    Machine <|-- ThreeDPrinter
    Machine "*" --o "0..1" Makerspace : houses
    Makerspace "*" --> "*" Member : enrolls
    Makerspace "1" *-- "*" Reservation : schedules
    Reservation "*" --> "1" Machine : books
    Reservation "*" --> "1" Member : made by
    Makerspace ..> ScheduleBoard : posts to
```

## Reading the Mermaid source

- A `$` after a member marks it class-level; the drawn diagram shows it underlined.
- A `*` after a method marks it abstract; the drawn diagram shows it in italics. Every subclass must define it.
- `Array~String~` is drawn as `Array<String>`: an array of strings.
- `<<module>>` marks a Ruby module, and `<<abstract>>` a class that is never created itself, only its subclasses.
- A name in capitals is a constant: `TRAININGS` in `Member` is `Member::TRAININGS`.
- Inside each class, attributes and methods are each listed in alphabetical order.
