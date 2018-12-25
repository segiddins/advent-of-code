require 'strscan'

Group = Struct.new(:army, :units, :unit) do
  def effective_power
    unit.ap * units
  end

  def damage_to(g)
    at = unit.at
    if g.unit.immunities.include?(at)
      0
    elsif g.unit.weaknesses.include?(at)
      effective_power * 2
    else
      effective_power
    end
  end

  def take_damage(d)
    deaths = d / unit.hp
    self.units -= deaths
  end

  def select_target(groups)
    groups.reject { |g| g.army == army }.map { |g| [g, damage_to(g)] }.select {|g, d| d > 0}.max_by do |g, d|
      [
        d,
        g.effective_power,
        g.unit.initiative
      ]
    end&.first
  end
end
Unit = Struct.new(:hp, :weaknesses, :immunities, :ap, :at, :initiative)

def parse(s)
  s = StringScanner.new(s)
  h = {}

  ["Immune System", "Infection"].each do |t|
    s.skip(/#{t}:\n/)
    until s.skip(/^\n/) or s.eos?
      g = Group.new(t)
      (h[t] ||= []) << g
      u = Unit.new
      g.unit = u
      g.units = s.scan(/^\d+/).to_i
      s.skip(/ units each with /)
      u.hp = s.scan(/\d+/).to_i
      s.skip(/ hit points /)
      s.skip(/\(/)
      u.immunities = []
      u.weaknesses = []
      until s.match?(/(\) )?with/) 
        if s.skip(/immune to /)
          while w = s.scan(/\w+/)
            u.immunities << w.strip
            s.skip(/, /)
          end
          s.skip(/[,;] /)
        end
        if s.skip(/weak to /)
          while w = s.scan(/\w+/)
            u.weaknesses << w.strip
            s.skip(/, /)
          end
          s.skip(/[,;] /)
        end
      end
      s.skip(/\) /)
      s.skip(/with an attack that does /)
      u.ap = s.scan(/\d+/).to_i
      u.at = s.scan(/ \w+/).strip
      s.skip(/ damage at initiative /)
      u.initiative = s.scan(/\d+/).to_i
      s.skip(/\n/)
    end
  end

  h.values.flatten(1)
end

input = <<-EOS
Immune System:
17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3

Infection:
801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4
EOS

require 'set'

def fight(groups, debug: false)
  while groups.map(&:army).uniq.size > 1
    targets = groups.to_a.to_set
    enemies = groups.sort_by {|g| [-g.effective_power, -g.unit.initiative] }.map do |group|
      next unless target = group.select_target(targets)
      targets.delete(target)
      [group, target]
    end.compact

    raise "over (#{groups.pretty_inspect})" if enemies.empty?

    enemies.sort_by { |a,d| -a.unit.initiative }.each do |a, d|
      next unless groups.include?(a)
      d.take_damage(a.damage_to(d))
      groups.delete(d) if d.units <= 0
    end
  end
end

input = File.read(File.expand_path('day_24_input.txt', __dir__))
groups = parse(input)
fight(groups)
pp groups.sum(&:units)

25.upto(50000) do |boost|
  groups = parse(input)
  groups.each do |g|
    g.unit.ap += boost if g.army == "Immune System"
  end
  fight(groups) rescue next

  if groups.map(&:army).first == "Immune System"
    pp groups.sum(&:units)
    break
  end
end