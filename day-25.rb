require "rspec"

class TuringMachine
  attr_reader :tape, :cursor, :state_transitions
  attr_accessor :state, :steps

  def initialize(blueprint)
    @cursor = 0
    @tape = {}
    @state_transitions = {}
    parse_blueprint(blueprint)
  end

  def checksum
    @tape.count { |k,v| v == 1 }
  end

  def execute
    steps.times do |i|
      state_transitions.fetch(state).call(self)
    end
  end

  def read
    tape.fetch(cursor, 0)
  end

  def write(value)
    tape.store(cursor, value)
  end

  def move(direction)
    case direction
    when "right" then @cursor += 1
    when "left"  then @cursor -= 1
    end
  end

  private

  def parse_blueprint(blueprint)
    lines = blueprint.split(/\n/)
    self.state = lines.shift.match(/Begin in state ([A-Z])\./)[1]
    self.steps = lines.shift.match(/Perform a diagnostic checksum after (\d+) steps\./)[1].to_i

    while !lines.empty?
      lines.shift
      state = lines.shift.match(/In state ([A-Z]):/)[1]
      state_proc = build_proc(lines.shift(8))
      @state_transitions.store(state, state_proc)
    end
  end

  def build_proc(lines)
    lines.shift
    zero_new_value      = lines.shift.match(/Write the value ([01])\./)[1].to_i
    zero_move_direction = lines.shift.match(/Move one slot to the (right|left)./)[1]
    zero_next_state     = lines.shift.match(/Continue with state ([A-Z])./)[1]

    lines.shift
    one_new_value       = lines.shift.match(/Write the value ([01])\./)[1].to_i
    one_move_direction  = lines.shift.match(/Move one slot to the (right|left)./)[1]
    one_next_state      = lines.shift.match(/Continue with state ([A-Z])./)[1]

    ->(machine) {
      if machine.read == 0
        machine.write(zero_new_value)
        machine.move(zero_move_direction)
        machine.state = zero_next_state
      else
        machine.write(one_new_value)
        machine.move(one_move_direction)
        machine.state = one_next_state
      end
    }
  end
end

describe TuringMachine do
  let(:blueprint) do
    <<-BLUEPRINT
Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
    BLUEPRINT
  end

  specify "execute" do
    machine = TuringMachine.new(blueprint)
    expect { machine.execute }.to change { machine.checksum }.to 3
  end
end

blueprint = <<-BLUEPRINT
Begin in state A.
Perform a diagnostic checksum after 12172063 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state C.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state D.

In state C:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state D.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the right.
    - Continue with state C.

In state D:
  If the current value is 0:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the right.
    - Continue with state E.

In state E:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state C.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state F.

In state F:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state E.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
BLUEPRINT

return if /rspec$/ === $PROGRAM_NAME

machine = TuringMachine.new(blueprint)
machine.execute
puts machine.checksum


