class Coprocessor
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

  def mul(reg, value_or_reg)
    registers.store(reg, get(reg) * get(value_or_reg)).tap { advance }
  end

  def sub(reg, value_or_reg)
    registers.store(reg, get(reg) - get(value_or_reg)).tap { advance }
  end

  def jnz(reg, value_or_reg)
    if get(reg) != 0
      advance(get(value_or_reg))
    else
      advance
    end
  end

  def advance(offset = 1)
    @instruction_pointer += offset
  end

  def run(&block)
    until finished?
      step(&block)
    end
  rescue TerminatedError => e
  end

  def finished?
    instruction_pointer >= program.length
  end

  def step(&block)
    instruction, *args = program[instruction_pointer]
    block.call(instruction, args) if block_given?
    case instruction
    when "set"
      set(*args)
    when "mul"
      mul(*args)
    when "sub"
      sub(*args)
    when "jnz"
      jnz(*args)
    end
  end
end
class TerminatedError < StandardError; end

program = <<-PROGRAM
set b 65
set c b
jnz a 2
jnz 1 5
mul b 100
sub b -100000
set c b
sub c -17000
set f 1
set d 2
set e 2
set g d
mul g e
sub g b
jnz g 2
set f 0
sub e -1
set g e
sub g b
jnz g -8
sub d -1
set g d
sub g b
jnz g -13
jnz f 2
sub h -1
set g b
sub g c
jnz g 2
jnz 1 3
sub b -17
jnz 1 -23
PROGRAM

processor = Coprocessor.new(program: program)

mul_count = 0
processor.run do |instruction, args|
  mul_count += 1 if instruction == "mul"
end
puts mul_count
puts processor.get("h")

mul_count = 0
a, b, c, d, e, f, g, h = [0]*8
#a = 1
b = 65
c = b
if a != 0
  b = (b * 100) + 100_000
  c = b + 17000
end

loop do
  f = 1
  d = 2
  loop do
    e = 2
    loop do
      mul_count += 1
      if d * e == b
        f = 0
      end
      e = e + 1
      break if e == b
    end
    d = d + 1
    break if d == b
  end
  if f == 0
    h = h + 1
  end
  break if b == c
  b = b + 17
end

puts "My count: #{mul_count}"
puts "My h: #{h}"

require "prime"
b = 106500
c = 123500
h = 0
loop do
  h += 1 unless b.prime?
  break if b == c
  b += 17
end

puts "HHHHHH #{h}"
#
##processor = Coprocessor.new(program: program)
##processor.set("a", 1)
##processor.run
##puts processor.get("h")
#
## set b 65       #    b = 65
## set c b        #    c = b
## jnz a 2        #    if a != 0 jump a
## jnz 1 5        #    else jump b
## mul b 100      # a  b = b * 100
## sub b -100000  #    b = b + 100000
## set c b        #    c = b
## sub c -17000   #    c = c + 17000
## set f 1        # b  f = 1
## set d 2        #    d = 2
# set e 2        # e  e = 2
# set g d        # d  g = d (2)
# mul g e        #    g = g * e
# sub g b        #    g = g - b
# jnz g 2        #    if g != 0 jump c
# set f 0        #    f = 0
# sub e -1       # c  e = e + 1
# set g e        #    g = e
# sub g b        #    g = g - b
# jnz g -8       #    if g != 0 jump d
# sub d -1       #    d = d + 1
# set g d        #    g = d
# sub g b        #    g = g - b
# jnz g -13      #    if g != 0 jump e
# jnz f 2        #    if f != 0 jump f
# sub h -1       #    h = h + 1
# set g b        # f  g = b
# sub g c        #    g = g - c
# jnz g 2        #    if g != 0 jump g
# jnz 1 3        #    jump 3
# sub b -17      # g  b = b + 17
# jnz 1 -23      #    jump b
