class Duet
  attr_reader :registers, :instruction_pointer, :program

  def initialize(program: "")
    @registers = Hash.new { |h,k| h[k] = 0 }
    @instruction_pointer = 0
    @program = program.split(/\n/).map { |line| line.split(/\s+/) }
  end

  def set(reg, value_or_reg)
    registers.store(reg, get(value_or_reg)).tap { advance }
  end

  def get(value_or_reg)
    if /^-?\d+$/ === value_or_reg.to_s
      value_or_reg.to_i
    else
      registers[value_or_reg]
    end
  end

  def add(reg, value_or_reg)
    registers.store(reg, get(reg) + get(value_or_reg)).tap { advance }
  end

  def mul(reg, value_or_reg)
    registers.store(reg, get(reg) * get(value_or_reg)).tap { advance }
  end

  def mod(reg, value_or_reg)
    registers.store(reg, get(reg) % get(value_or_reg)).tap { advance }
  end

  def snd(reg)
    freq = nil
    if freq = get(reg)
      @last_played_freq = freq
    end
    freq.tap { advance }
  end

  def rcv(reg)
    if get(reg) > 0
      raise TerminatedError
    else
      advance
      nil
    end
  end

  def jgz(reg, value_or_reg)
    if get(reg) > 0
      advance(get(value_or_reg))
    else
      advance
    end
  end

  def advance(offset = 1)
    @instruction_pointer += offset
  end

  def last_played_freq
    @last_played_freq
  end

  def run
    until finished?
      step
    end
  rescue TerminatedError => e
  end

  def finished?
    instruction_pointer >= program.length
  end

  def step
    instruction, *args = program[instruction_pointer]
    case instruction
    when "snd"
      snd(*args)
    when "set"
      set(*args)
    when "add"
      add(*args)
    when "mul"
      mul(*args)
    when "mod"
      mod(*args)
    when "rcv"
      rcv(*args)
    when "jgz"
      jgz(*args)
    end
  end
end
class TerminatedError < StandardError; end

require "rspec"
describe Duet do
  let(:duet) { Duet.new }

  describe "set" do
    specify "sets the value" do
      duet.set("a", 12)
      expect(duet.get("a")).to eq 12
    end
  end

  describe "snd" do
    specify "records the frequency of the sound" do
      duet.set("a", 12)
      duet.snd("a")
      expect(duet.last_played_freq).to eq 12
    end
  end

  describe "add" do
    specify "adds value to the given register" do
      duet.set("a", 1)
      duet.add("a", 5)
      expect(duet.get("a")).to eq 6
    end
  end

  describe "mul" do
    specify "multiplies given register by value" do
      duet.set("a", 3)
      duet.mul("a", 4)
      expect(duet.get("a")).to eq 12
    end
  end

  describe "mod" do
    specify "mods given register by value" do
      duet.set("a", 9)
      duet.mod("a", 4)
      expect(duet.get("a")).to eq 1
    end
  end

  describe "rcv" do
    specify "when value is non-zero" do
      duet.set("b", 10)
      duet.snd("b")
      duet.set("a", 1)
      expect { duet.rcv("a") }.to raise_error TerminatedError
      expect(duet.last_played_freq).to eq 10
    end

    specify "when value is zero" do
      duet.set("a", 0)
      duet.snd("a")
      expect(duet.rcv("a")).to be_nil
    end
  end

  describe "jgz" do
    specify "when value is non-zero" do
      duet.set("a", 1)
      expect { duet.jgz("a", 10) }.to change { duet.instruction_pointer }.by 10
    end
    specify "when value is zero" do
      duet.set("a", 0)
      expect { duet.jgz("a", 10) }.to change { duet.instruction_pointer }.by 1
    end

  end

  describe "the test case" do
    specify "runs correctly" do
      program = <<~PROGRAM
        set a 1
        add a 2
        mul a a
        mod a 5
        snd a
        set a 0
        rcv a
        jgz a -1
        set a 1
        jgz a -2
      PROGRAM

      duet = Duet.new(program: program)
      duet.run

      expect(duet.last_played_freq).to eq 4
    end
  end
end

class ThreadedDuet < Duet
  attr_reader :messages, :input, :output, :pid, :sent_messages

  def initialize(program: "", id:, input: [], output: [])
    super(program: program)
    registers.store("p", @pid = id)
    @input = input
    @output = output
    @signals = []
    @sent_messages = 0
  end

  def handle_signals
  end

  def rcv(reg)
    wait_for_input
    registers.store(reg, input.shift).tap { advance }
  end

  def snd(reg)
    output.push(get(reg)).tap do |message|
      @sent_messages += 1
      advance
    end
  end

  def waiting?
    @waiting == true
  end

  def finished?
    instruction_pointer >= program.length && !terminated?
  end

  def terminate!
    @terminated = true
  end

  def wait_for_input
    while input.empty?
      @waiting = true
      handle_signals
    end
  ensure
    @waiting = false
  end

  def handle_signals
    raise TerminatedError if terminated?
  end

  def terminated?
    @terminated == true
  end

  def step
    handle_signals
    super
  end

  def debug
    STDOUT.puts <<~DEBUG
      PID: #{} before step
      #{program[instruction_pointer].inspect}
      #{self.inspect}
    DEBUG
  end

end

describe ThreadedDuet do
  let(:threaded_duet) { ThreadedDuet.new(id: 0, input: input, output: output) }
  let(:input)  { [] }
  let(:output) { [] }

  before do
    Thread.abort_on_exception = true
  end

  after do
    Thread.abort_on_exception = false
  end

  describe "rcv" do
    specify "receives values from message queue" do
      input << 12
      thread = Thread.new { threaded_duet.rcv("x") }
      thread.join
      expect(threaded_duet.get("x")).to eq 12
    end

    specify "blocks until message is available" do
      thread = Thread.new { threaded_duet.rcv("x") }
      sleep 0.01
      expect(threaded_duet).to be_waiting

      input << 12

      sleep 0.01
      expect(threaded_duet).not_to be_waiting
      expect(threaded_duet.get("x")).to eq 12
    end

    specify "throws terminate if interrupted" do
      thread = Thread.new do
        expect { threaded_duet.rcv("x") }.to throw_symbol(:terminate)
      end
      threaded_duet.terminate!
    end
  end

  describe "snd" do
    specify "pushes value to output queue" do
      threaded_duet.set("a", 12)
      expect { threaded_duet.snd("a") }.to change { output }.to [12]
    end

    specify "increment send count" do
      threaded_duet.set("a", 12)
      expect { threaded_duet.snd("a") }.to change { threaded_duet.sent_messages }.by 1
    end

    specify "increment send count" do
      threaded_duet.set("a", 12)
      expect { threaded_duet.snd("a") }.to change { threaded_duet.sent_messages }.by 1
    end
  end

  describe "waiting" do
    specify "when not blocking" do
      expect(threaded_duet).not_to be_waiting
    end

    specify "when blocking" do
      t = Thread.new { threaded_duet.rcv("a") }
      sleep 0.01
      expect(threaded_duet).to be_waiting
    end
  end

  describe "terminate" do
    let(:program) { "rcv a" }
    specify "stops the program from running" do
      expect(threaded_duet).not_to be_terminated
      threaded_duet.terminate!
      expect(threaded_duet).to be_terminated
    end

    specify "stops waiting" do
      t = Thread.new do
        expect { threaded_duet.wait_for_input }.to raise_error TerminatedError
      end
      sleep 0.01
      expect(threaded_duet).to be_waiting
      threaded_duet.terminate!
      t.join
      expect(threaded_duet).not_to be_waiting
    end
  end

  describe "test interaction" do
    specify "does the thing" do
      program = <<~PROGRAM
        snd 1
        snd 2
        snd p
        rcv a
        rcv b
        rcv c
        rcv d
      PROGRAM

      mq0 = []
      mq1 = []

      d0 = ThreadedDuet.new(id: 0, input: mq0, output: mq1, program: program)
      d1 = ThreadedDuet.new(id: 1, input: mq1, output: mq0, program: program)

      t0 = Thread.new { d0.run }
      t1 = Thread.new { d1.run }

      loop do
        if d0.waiting? && d1.waiting? && mq0.empty? && mq1.empty?
          puts "DEADLOCK"
          d0.terminate!
          d1.terminate!
          break
        elsif d0.finished? && d1.waiting?
          puts "D1 DEADLOCKED"
          d1.terminate!
          break
        elsif d1.finished? && d0.waiting?
          puts "D2 DEADLOCKED"
          d0.terminate!
          break
        end
      end

      t0.join
      t1.join

      expect(d0.get("a")).to eq 1
      expect(d0.get("b")).to eq 2
      expect(d0.get("c")).to eq 1
      expect(d1.get("a")).to eq 1
      expect(d1.get("b")).to eq 2
      expect(d1.get("c")).to eq 0
      expect(d0.sent_messages).to eq 3
      expect(d1.sent_messages).to eq 3
    end
  end
end

return if /rspec$/ === $PROGRAM_NAME

program = <<~PROGRAM
set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 680
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19
PROGRAM

duet = Duet.new(program: program)
puts duet.run

# Part 2
mq0 = []
mq1 = []

d0 = ThreadedDuet.new(id: 0, input: mq0, output: mq1, program: program)
d1 = ThreadedDuet.new(id: 1, input: mq1, output: mq0, program: program)

t0 = Thread.new { d0.run }
t1 = Thread.new { d1.run }

loop do
  if d0.waiting? && d1.waiting? && mq0.empty? && mq1.empty?
    puts "DEADLOCK"
    d0.terminate!
    d1.terminate!
    break
  elsif d0.finished? && d1.waiting?
    puts "D1 DEADLOCKED"
    d1.terminate!
    break
  elsif d1.finished? && d0.waiting?
    puts "D2 DEADLOCKED"
    d0.terminate!
    break
  end
end

t0.join
t1.join

puts d1.sent_messages
