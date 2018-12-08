import re
from datetime import datetime
import pprint

class Day1(object):
  def part1():
    with open('day1_part1.txt') as f:
      data = f.read()
      i = 0
      for line in data.splitlines():
        i += int(line)
      print(i)
      
  def part2():
    with open('day1_part1.txt') as f:
      data = f.read()
      freqs = set([0])
      freq = 0
      while True:
        for line in data.splitlines():
          freq += int(line)
          if freq in freqs:
            print(freq)
            return
          freqs.add(freq)
    
class Day2(object):
  def distance(id1, id2):
    if id1 == id2: return 0
    head1, *tail1 = id1
    head2, *tail2 = id2
    if head1 != head2:
      return 1 + Day2.distance(tail1, tail2)
    return Day2.distance(tail1, tail2)
  
  def checksum(box_ids):
    two_count = 0
    three_count = 0
    for box_id in box_ids:
      counts = {}
      for char in box_id:
        if char not in counts:
          counts[char] = 0
        counts[char] += 1
      inv_counts = {2:0,3:0}
      for (letter, count) in counts.items():
        if count in inv_counts:
          inv_counts[count] += 1
      if inv_counts[2] > 0: two_count += 1
      if inv_counts[3] > 0: three_count += 1
    return two_count * three_count
      
    
  def part1():
    with open('day2_part1.txt') as f:
      box_ids = [l for l in f]
      print(Day2.checksum(box_ids))
      
  def part2():
    with open('day2_part1.txt') as f:
      print(Day2.distance('abcde', 'abcdd'))
      box_ids = [l for l in f]
      for box_id1 in box_ids:
        for box_id2 in box_ids:
          if Day2.distance(box_id1, box_id2) is 1:
            print(box_id1, box_id2)
            return
    
class Day3(object):
  class Rectangle(object):
    def __init__(self, x, y, width, height):
      self.x = x
      self.y = y
      self.width = width
      self.height = height
      
    def overlaps(self, other):
      return not (self.y + self.height > other.y or self.y < other.y + other.height or self.x + self.width > other.x or self.x < other.x + other.width)
      
    @property
    def all_points(self):
      for x in range(self.x, self.x + self.width):
        for y in range(self.y, self.y + self.height):
          yield (x, y)

  class Claim(object):
    def __init__(self, id, rect):
      self.id = id
      self.rect = rect
    
  def parse_claim(line):
    match = re.match('#(\d+) @ (\d+),(\d+): (\d+)x(\d+)', line)
    id, x, y, width, height = match.groups()
    return Day3.Claim(id, Day3.Rectangle(int(x), int(y), int(width), int(height)))
    
  def part1():
    with open('day3_part1.txt') as f:
      claims = [Day3.parse_claim(l) for l in f]
      
      points = {}
      for claim in claims:
        for point in claim.rect.all_points:
          if not point in points:
            points[point] = list()
          points[point].append(claim)
          
      print(len([x for x in points.values() if len(x) >= 2]))
      
  def part2():
    with open('day3_part1.txt') as f:
      claims = [Day3.parse_claim(l) for l in f]
      
      points = {}
      for claim in claims:
        for point in claim.rect.all_points:
          if not point in points:
            points[point] = list()
          points[point].append(claim)
          
      for claim in claims:
        if any([len(points[point]) > 1 for point in claim.rect.all_points]):
          continue
        print(claim.id)
        
class Day4(object):
  class Sleep(object):
    def __init__(self, guard_id):
      self.guard_id = guard_id
      
    @property
    def duration(self):
      return self.end - self.start

  def part1():
    with open('day4.txt') as f:
      sleeps = []
      sleeps_by_guard = {}
      sleep = None
      for line in f:
        match = re.match('\[(\d+)-(\d+)-(\d+) (\d+):(\d+)\] Guard #(\d+) begins shift', line)
        if match:
          sleep = Day4.Sleep(match[6])
          sleeps.append(sleep)
          if not sleep.guard_id in sleeps_by_guard:
            sleeps_by_guard[sleep.guard_id] = []
          sleeps_by_guard[sleep.guard_id].append(sleep)
        else:
          match = re.match('\[(\d+)-(\d+)-(\d+) (\d+):(\d+)\] (falls asleep|wakes up)', line)
          if match:
            stamp = datetime(year=int(match[1]),month=int(match[2]),day=int(match[3]),hour=int(match[4]),minute=int(match[5]))
            if match[6] is 'falls asleep':
              sleep.start = stamp
            else:
              sleep.end = stamp
    
Day4.part1()
