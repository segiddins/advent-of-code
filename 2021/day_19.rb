#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../aoc'

$input = File.read(__FILE__.sub(/\.rb\z/, '.txt'))
$input = DATA.read
$lines = $input.split("\n")

PI = Math::PI

def rotate(pitch, roll, yaw, pt)
  cosa = Math.cos(yaw)
  sina = Math.sin(yaw)

  cosb = Math.cos(pitch)
  sinb = Math.sin(pitch)

  cosc = Math.cos(roll)
  sinc = Math.sin(roll)

  axx = cosa * cosb
  axy = cosa * sinb * sinc - sina * cosc
  axz = cosa * sinb * cosc + sina * sinc

  ayx = sina * cosb
  ayy = sina * sinb * sinc + cosa * cosc
  ayz = sina * sinb * cosc - cosa * sinc

  azx = -sinb
  azy = cosb * sinc
  azz = cosb * cosc

  px, py, pz = pt

  [
    axx * px + axy * py + axz * pz,
    ayx * px + ayy * py + ayz * pz,
    azx * px + azy * py + azz * pz,
  ].map(&:round)
end

# def rotate(rotation, point)
#   [0, 1, 2].map { |idx| rotation[idx] * point[idx]}
# end

Pt3 = Struct.new(:x, :y, :z) {}

def part1
  scanners = []
  $lines.each do |l|
    next if l.empty?
    next scanners << [] unless l =~ /(-?\d+),(-?\d+)(?:,(-?\d+))?/
    scanners.last << [$1.to_i, $2.to_i, $3.to_i]
  end
  scanners.each(&:sort!)

  mutual_md = ->(beacons) do
    beacons
      .permutation(2)
      .map do |(a, b)|
        [[a[0] - b[0], a[1] - b[1], a[2] - b[2]].map(&:abs).sort, [a, b].sort]
      end
      .sort
  end

  rotations = [PI / 2, PI, 0, 3 * PI / 2].*(3).permutation(3).uniq.sort
  bvs = [[0, 0, 1], [0, 1, 0], [1, 0, 0]]
  rotations =
    rotations
      .map { |r| [r, bvs.map { |bv| rotate(*r, bv) }] }
      .each_with_object({}) do |(rotation, impact), inverse|
        inverse[impact] ||= rotation
      end
      .values

  graph = Hash.new { |h, k| h[k] = [] }
  0.upto(scanners.length.pred) { |k| graph[k] }

  path = {}
  positions = Array.new(scanners.size)
  positions[0] = [0, 0, 0]

  loop do
    break unless (v = graph.find { |k, a| k != 0 and a.empty? })
    idx = v.first

    vr =
      rotations.find do |r|
        (
          mutual_md[scanners[0]].map(&:first) &
            mutual_md[scanners[idx].map { |d| rotate(*r, d) }].map(&:first)
        ).size >= 12
      end
    scanners[idx].map! { |d| rotate(*vr, d) }

    rotated = mutual_md[scanners[idx]]
    matches =
      mutual_md[scanners[0]]
        .map { |(k, v)| [k, v, rotated.find { |(k1, _v1)| k1 == k }&.last] }
        .reject { |(_, _, v)| v.nil? }
    pp matches.map { |(_, v1, v2)| [v1, v2].map(&:last) }.size

    graph[0] << idx
    graph[idx] << 0

    path[[0, idx]] = vr

    pp graph
    pp path

    break
  end
end

def part2
  nil
end

pp part1
pp part2

__END__
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
