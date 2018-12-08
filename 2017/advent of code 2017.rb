#!/usr/bin/env ruby

require 'set'
require 'matrix'

def day_1_puzzle1
  s = "237369991482346124663395286354672985457326865748533412179778188397835279584149971999798512279429268727171755461418974558538246429986747532417846157526523238931351898548279549456694488433438982744782258279173323381571985454236569393975735715331438256795579514159946537868358735936832487422938678194757687698143224139243151222475131337135843793611742383267186158665726927967655583875485515512626142935357421852953775733748941926983377725386196187486131337458574829848723711355929684625223564489485597564768317432893836629255273452776232319265422533449549956244791565573727762687439221862632722277129613329167189874939414298584616496839223239197277563641853746193232543222813298195169345186499866147586559781523834595683496151581546829112745533347796213673814995849156321674379644323159259131925444961296821167483628812395391533572555624159939279125341335147234653572977345582135728994395631685618135563662689854691976843435785879952751266627645653981281891643823717528757341136747881518611439246877373935758151119185587921332175189332436522732144278613486716525897262879287772969529445511736924962777262394961547579248731343245241963914775991292177151554446695134653596633433171866618541957233463548142173235821168156636824233487983766612338498874251672993917446366865832618475491341253973267556113323245113845148121546526396995991171739837147479978645166417988918289287844384513974369397974378819848552153961651881528134624869454563488858625261356763562723261767873542683796675797124322382732437235544965647934514871672522777378931524994784845817584793564974285139867972185887185987353468488155283698464226415951583138352839943621294117262483559867661596299753986347244786339543174594266422815794658477629829383461829261994591318851587963554829459353892825847978971823347219468516784857348649693185172199398234123745415271222891161175788713733444497592853221743138324235934216658323717267715318744537689459113188549896737581637879552568829548365738314593851221113932919767844137362623398623853789938824592"

  s += s[0, 1]
  sum = 0
  last = nil
  s.each_char do |c|
    if last == c
      sum += c.to_i
    end
    last = c
  end
  puts sum
end

def day_1_puzzle_2
  s = "237369991482346124663395286354672985457326865748533412179778188397835279584149971999798512279429268727171755461418974558538246429986747532417846157526523238931351898548279549456694488433438982744782258279173323381571985454236569393975735715331438256795579514159946537868358735936832487422938678194757687698143224139243151222475131337135843793611742383267186158665726927967655583875485515512626142935357421852953775733748941926983377725386196187486131337458574829848723711355929684625223564489485597564768317432893836629255273452776232319265422533449549956244791565573727762687439221862632722277129613329167189874939414298584616496839223239197277563641853746193232543222813298195169345186499866147586559781523834595683496151581546829112745533347796213673814995849156321674379644323159259131925444961296821167483628812395391533572555624159939279125341335147234653572977345582135728994395631685618135563662689854691976843435785879952751266627645653981281891643823717528757341136747881518611439246877373935758151119185587921332175189332436522732144278613486716525897262879287772969529445511736924962777262394961547579248731343245241963914775991292177151554446695134653596633433171866618541957233463548142173235821168156636824233487983766612338498874251672993917446366865832618475491341253973267556113323245113845148121546526396995991171739837147479978645166417988918289287844384513974369397974378819848552153961651881528134624869454563488858625261356763562723261767873542683796675797124322382732437235544965647934514871672522777378931524994784845817584793564974285139867972185887185987353468488155283698464226415951583138352839943621294117262483559867661596299753986347244786339543174594266422815794658477629829383461829261994591318851587963554829459353892825847978971823347219468516784857348649693185172199398234123745415271222891161175788713733444497592853221743138324235934216658323717267715318744537689459113188549896737581637879552568829548365738314593851221113932919767844137362623398623853789938824592"
  
  l = s.size
  sum = 0
  s[0, l].each_char.each_with_index do |c, i|
    o = s[i + l/2]
    sum += c.to_i if o == c
  end
  
  puts sum * 2
end

def day_2
  s = <<-EOS
493	458	321	120	49	432	433	92	54	452	41	461	388	409	263	58
961	98	518	188	958	114	1044	881	948	590	972	398	115	116	451	492
76	783	709	489	617	72	824	452	748	737	691	90	94	77	84	756
204	217	90	335	220	127	302	205	242	202	259	110	118	111	200	112
249	679	4015	106	3358	1642	228	4559	307	193	4407	3984	3546	2635	3858	924
1151	1060	2002	168	3635	3515	3158	141	4009	3725	996	142	3672	153	134	1438
95	600	1171	1896	174	1852	1616	928	79	1308	2016	88	80	1559	1183	107
187	567	432	553	69	38	131	166	93	132	498	153	441	451	172	575
216	599	480	208	224	240	349	593	516	450	385	188	482	461	635	220
788	1263	1119	1391	1464	179	1200	621	1304	55	700	1275	226	57	43	51
1571	58	1331	1253	60	1496	1261	1298	1500	1303	201	73	1023	582	69	339
80	438	467	512	381	74	259	73	88	448	386	509	346	61	447	435
215	679	117	645	137	426	195	619	268	223	792	200	720	260	303	603
631	481	185	135	665	641	492	408	164	132	478	188	444	378	633	516
1165	1119	194	280	223	1181	267	898	1108	124	618	1135	817	997	129	227
404	1757	358	2293	2626	87	613	95	1658	147	75	930	2394	2349	86	385
  EOS
  
  puts(s.lines.sum do |l|
    l.split(/\s+/).map(&:to_i).sort.values_at(-1, 0).reduce(&:-)
  end)
  
#  s = "5 9 2 8\n9 4 7 3\n3 8 6 5"
  puts(s.lines.sum do |l|
    nums = l.split(/\s+/).map(&:to_i).sort
    ls = 0
    while num = nums.shift and nums.any?
      nums.each do |i|
        next if i == num
        d = i / num
        ls += d if d * num == i
      end
    end
    ls
  end)
end

def day_3
  i = 12
  a = [0, 0, 1]
  c = 1
  dir = -1
  while (n = a.size) <= i && false
    r = (1..Float::INFINITY).find {|o| (2*o - 1) ** 2 >= n}
    sq = (2*r - 1) ** 2
    if flip = (2 *r - 3)**2 + 1 == n
#      puts "flipping at n=#{n}"
      dir = 1
      c = 0
    elsif c % (r - 1) == 0
      dir *= -1
    end
    c += 1
    a << a.last + dir
    dir = -1 if flip
#    p [n, r, c, a.last]
  end
#  puts a.last
  
  sq = [0, 1]
  while sq.max < i
    n = sq.size
    if n ** (0.5) % 2 == 1
      
    end
    sq << n
  end
  puts sq
#  puts sq.max
end

def day_4
  passphrases = File.read("day4.txt").lines.map {|l| l.split(/\s+/) }
  puts(passphrases.count {|pf| !pf.sort.uniq! }) 

  puts(passphrases.count {|pf| !pf.map {|w| w.chars.sort.join }.sort.uniq! })
end

def day_5
  s = [0, 3, 0, 1, -3].join("\n")
  s = "0\n2\n0\n-1\n0\n-4\n-5\n-5\n-4\n1\n-6\n-10\n-9\n-1\n-1\n1\n-15\n-15\n-13\n1\n-2\n-13\n-6\n-22\n-10\n-15\n-3\n-19\n1\n-26\n-18\n-13\n-15\n-15\n-10\n-4\n0\n-35\n-4\n-37\n-29\n-30\n-38\n-38\n-13\n-36\n-42\n-5\n-28\n-17\n-34\n-41\n0\n-41\n-36\n-46\n-7\n-51\n-49\n-47\n-45\n-30\n-58\n-33\n-22\n-38\n-49\n-37\n-44\n-53\n-18\n-66\n-46\n-47\n-58\n-22\n-34\n-41\n-13\n-41\n-30\n-34\n-15\n-38\n-60\n-61\n-73\n-20\n-62\n-48\n-19\n-40\n-69\n-86\n-75\n-9\n-29\n-2\n-48\n-96\n-46\n-89\n-76\n-34\n-65\n-38\n-69\n-5\n-12\n-54\n-72\n-87\n-23\n-82\n-12\n-24\n-16\n-115\n-83\n-3\n-109\n-72\n-42\n0\n-48\n-9\n-34\n-67\n-83\n-20\n-33\n-76\n-81\n0\n-16\n-106\n-58\n-91\n-102\n-123\n-135\n-85\n-109\n-61\n-70\n-103\n-43\n-104\n-119\n-75\n-129\n-104\n-87\n-95\n-63\n-1\n-118\n-49\n-71\n-34\n-129\n-52\n-103\n-98\n-132\n-119\n-50\n-36\n-35\n-24\n-98\n-139\n-58\n-25\n-93\n-82\n-87\n1\n-14\n-109\n-89\n-25\n-96\n-60\n-79\n-5\n-124\n-62\n-44\n-98\n-119\n-189\n-66\n-121\n-151\n-4\n-14\n-16\n-154\n-39\n-51\n-127\n-13\n-129\n-98\n-28\n-6\n-174\n-169\n-139\n-22\n-4\n-2\n-48\n-62\n-58\n-163\n-169\n-124\n-104\n-205\n-211\n-43\n2\n-135\n-41\n-88\n-208\n-28\n-124\n-172\n-223\n-76\n-98\n-146\n-55\n-209\n-197\n-134\n-93\n2\n-227\n-39\n-235\n-240\n-206\n-70\n-65\n-38\n-175\n-198\n-80\n-10\n-246\n-228\n-23\n-84\n-177\n-81\n-119\n-161\n-246\n-75\n-72\n-243\n-78\n-233\n-50\n-204\n-7\n-206\n-220\n-46\n-249\n-135\n-130\n-143\n-42\n-65\n-52\n-79\n-112\n-147\n-273\n-54\n-88\n-200\n-227\n-24\n-166\n-113\n-189\n-30\n-174\n-55\n-107\n-14\n-144\n-148\n-46\n-263\n-225\n-85\n-14\n0\n-197\n-10\n-6\n-93\n-153\n-302\n-176\n-182\n-251\n-213\n-9\n-221\n-111\n-39\n-134\n-214\n-155\n-321\n-212\n-2\n-207\n-298\n-124\n-28\n-78\n-213\n-194\n-111\n-159\n-171\n-240\n-175\n-99\n-63\n-162\n-115\n-147\n-265\n-153\n-325\n-19\n-134\n-49\n-240\n-322\n-79\n-61\n-66\n-127\n-292\n-282\n-49\n-114\n-89\n-16\n-353\n-181\n-151\n-72\n-290\n-313\n-279\n-351\n-111\n-220\n-172\n-98\n-28\n-223\n-58\n-51\n-194\n-138\n-143\n-308\n-123\n-28\n-347\n-87\n-115\n-295\n-148\n-116\n-108\n-267\n-51\n-346\n-215\n-44\n-379\n-309\n-237\n0\n-212\n-119\n-231\n-140\n-270\n-91\n-146\n-245\n-232\n-119\n-131\n-398\n-264\n-181\n-303\n-186\n-404\n-280\n-412\n-375\n-292\n-251\n-138\n-36\n-18\n-217\n-117\n-56\n-272\n-312\n-160\n-70\n-130\n-16\n-279\n-159\n-6\n-268\n-283\n-259\n-197\n-378\n-24\n-45\n2\n-390\n-50\n-246\n-233\n-294\n-231\n-364\n-316\n-189\n-231\n-74\n-288\n-286\n-25\n-317\n-371\n-434\n-249\n-54\n-151\n-234\n-95\n-158\n-335\n-362\n-28\n-438\n-103\n-173\n-332\n-97\n-444\n-459\n-255\n-295\n-26\n-120\n-2\n-152\n-432\n-191\n-63\n-313\n-465\n-1\n-228\n-468\n-331\n-231\n-123\n-403\n-479\n-441\n-19\n-75\n-264\n-483\n-371\n-277\n-343\n-52\n-160\n-489\n-182\n-338\n-461\n-233\n-459\n-291\n-54\n-61\n-352\n-276\n-206\n-290\n-456\n-81\n-14\n-331\n-385\n-241\n-149\n-421\n-24\n-12\n-297\n-93\n-412\n-478\n0\n-219\n-157\n-328\n-344\n-367\n-343\n-123\n-349\n-441\n-197\n-317\n-165\n-329\n-515\n-74\n-443\n-197\n-75\n-52\n-534\n-330\n-178\n-509\n-199\n-502\n-429\n-362\n-422\n-555\n-183\n-221\n-461\n-338\n-496\n-28\n-507\n-276\n-271\n-511\n-298\n-426\n-144\n-112\n-198\n-496\n-158\n-350\n-326\n-219\n-315\n-394\n-555\n-10\n-422\n-420\n-216\n-386\n-344\n-374\n-567\n-15\n-23\n-434\n-44\n-346\n-110\n-561\n-198\n-505\n-103\n-374\n-107\n-298\n-38\n-26\n-171\n-235\n-324\n-427\n-359\n-130\n-500\n-31\n-221\n-402\n-240\n-283\n-47\n-20\n-422\n-453\n-31\n-470\n-115\n-97\n-120\n-41\n-590\n-437\n-53\n-563\n-440\n-254\n-545\n-256\n-341\n-325\n-417\n-9\n2\n-442\n-370\n-317\n-404\n-498\n-340\n-402\n-506\n-381\n-484\n-582\n-274\n-157\n-325\n-445\n-200\n-56\n-324\n-31\n-448\n-407\n-460\n-84\n-44\n-387\n-515\n-206\n-617\n-322\n-168\n-340\n-553\n-629\n-407\n-344\n-166\n-619\n-313\n-222\n-139\n-199\n-93\n-474\n-246\n-165\n-503\n-636\n-40\n-298\n-629\n-294\n-73\n-438\n-628\n-632\n-464\n-512\n-496\n-683\n-406\n-241\n-41\n-251\n-95\n-264\n-565\n-183\n-256\n-634\n-436\n-660\n-256\n-528\n-405\n-4\n-184\n-513\n-338\n-476\n-393\n-449\n-373\n-585\n-197\n-334\n-165\n-161\n-559\n-424\n-203\n-1\n-234\n-511\n-562\n-234\n-324\n-339\n-422\n-269\n-399\n-249\n-61\n-630\n-648\n-37\n-190\n-196\n-478\n-150\n-264\n-40\n-409\n-600\n-253\n-708\n-130\n-463\n-568\n-292\n-10\n-350\n-280\n-617\n-25\n-218\n-310\n-72\n-484\n-741\n-701\n-284\n-654\n-442\n-679\n-718\n-360\n-488\n-563\n-192\n-282\n-342\n-368\n-95\n-213\n-511\n-767\n-194\n-216\n-574\n-496\n-770\n-145\n-652\n-203\n-26\n-74\n-564\n-533\n-605\n-236\n-183\n-170\n-755\n-98\n-174\n-478\n-476\n-194\n-167\n-439\n-724\n-605\n-364\n-213\n-35\n-67\n-378\n-452\n-59\n-340\n-663\n-762\n-506\n-650\n-223\n-785\n-53\n-32\n-241\n-214\n-274\n-602\n-308\n-182\n-367\n-351\n-327\n-157\n-526\n-424\n-229\n-66\n-669\n-571\n-538\n-240\n-379\n-528\n-667\n-401\n-832\n-524\n-651\n-91\n-102\n-27\n-586\n-128\n-836\n-35\n-653\n-809\n-109\n-70\n-707\n-387\n-351\n-41\n-7\n-149\n-10\n-614\n-181\n-560\n-24\n-257\n-305\n-303\n-91\n-848\n-249\n-401\n-624\n-265\n-751\n-752\n-367\n-554\n-715\n-419\n-449\n-570\n-62\n-568\n-203\n-341\n-751\n-657\n-347\n-751\n-639\n-742\n-307\n-861\n-706\n-487\n-644\n-612\n-390\n-474\n-565\n-174\n-263\n-377\n-307\n-383\n-390\n-484\n-722\n-806\n-874\n-247\n-570\n-221\n-51\n-215\n-641\n-534\n-427\n-277\n-647\n-912\n-787\n-834\n-270\n-607\n-354\n-593\n-740\n-25\n-222\n-500\n-494\n-940\n-442\n-592\n-938\n-904\n-580\n-20\n-938\n-671\n-199\n-677\n-917\n-903\n-206\n-411\n-917\n-424\n-300\n-889\n-501\n-100\n-117\n-315\n-678\n-664\n-579\n-749\n-636\n-949\n-642\n-968\n-343\n-628\n-190\n-700\n-705\n-339\n-240\n-216\n-628\n-917\n-724\n-481\n-900\n-74\n-291\n-234\n-934\n-642\n-874\n-594\n-955\n-951\n-341\n-463\n-706\n-735\n-556\n-681\n-985\n-285\n-604\n-44\n-153\n-14\n-78\n-958\n-44\n-338\n-765\n-787\n-487\n-441\n-518\n-772\n-632\n-70\n-74\n-630\n-362\n-533\n-684\n-328\n-407\n-193\n-727\n-230\n-454\n-141\n-568\n-802\n-326\n-725\n-464\n-880\n-990\n-34"

  ins = s.split("\n").map(&:to_i)
  
  i = 0
  c = 0
  while i >= 0 && i < ins.size
#    c += 1
#    oi = i
#    i += ins[i]
#    ins[oi] += 1
  
    c += 1
    oi = i
    jmp = ins[i]
    i += jmp
    ins[oi] += jmp >= 3 ? -1 : 1
  end
  
  puts c
end

def day_6
  banks = [0, 2, 7, 0]
  banks = "5	1	10	0	1	7	13	14	3	12	8	10	7	12	0	6".split(/\s+/).map(&:to_i)
  seen = []
  seen_s = Set.new
  while seen_s.add?(banks.dup)
    seen << banks.dup
    redist, argmax = banks.each_with_index.max_by(&:first)
    banks[argmax] = 0
    redist.times do |r|
      br = (r + 1 + argmax) % banks.size
      banks[br] += 1
    end
  end
  puts seen.size
  puts seen.size - seen.index(banks)
end

def day_7
  require 'tsort'
  
  s = <<-EOS
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
  EOS
  
  s = File.read("day7.txt")
  
  program_ = Struct.new(:name, :weight, :dependents) do
    def total_weight
      @total_weight ||= weight + dependents.sum(&:total_weight)
    end
  end
  programs = Hash[s.lines.map do |l|
    _, name, weight, _, deps = *l.match(/(\w+) \((\d+)\)( -> (.*))?/)
    pr = program_.new(name, weight.to_i, deps.to_s.split(/, /))
    [name, pr]
  end]
  programs.each_value {|pr| pr.dependents.map! {|d| programs[d] } }
  
  sorted = TSort.tsort(
    lambda {|&b| programs.each_key(&b) },
    lambda {|n, &b|programs[n].dependents.each {|d| b[d.name] }}
  )
  
  bottom = programs[sorted.last]
  puts bottom.name
  
  walk = ->(node, b) { b[node]; node.dependents.each {|d| walk[d, b] } }
  walk[bottom, ->(n) {
    gb = n.dependents.group_by(&:total_weight)
    next if gb.size <= 1
    
    pr = gb.find {|k,v| v.size == 1}.last.last
    total = pr.total_weight
    other = gb.keys.find {|k| k != pr.total_weight }
    puts pr.weight - (total - other)
  }]
end

def day_8
  s = <<-EOS
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
  EOS
  s = File.read("day8.txt")
  
  _inst = Struct.new(:register, :change, :lhs, :cond, :rhs)
  
  instructions = s.lines.map do |l|
    register, inc, change, _, lhs, cond, rhs = l.split(/\s+/)
    change = change.to_i * (inc == 'dec' ? -1 : 1)
    
    _inst.new(register, change, lhs, cond, rhs.to_i)
  end
  
  vars = Hash[instructions.map {|i| [i.register, 0 ]}]
  max = 0
  instructions.each do |i|
    vars[i.register] += i.change if vars[i.lhs].send(i.cond, i.rhs)
    max = [max, vars[i.register]].max
  end
  
  puts vars.values.max
  puts max
end

def day_9
  score_string = -> (s) do
    level = 0
    score = 0
    garbage = false
    cancel = false
    garbage_count = 0
    s.each_char do |c|
      next cancel = false if cancel
      if garbage
        case c
        when '>' then garbage = false
        when '!' then cancel = true 
        else garbage_count += 1
        end
        
        next
      end
        
      
      case c
      when '<' then garbage = true
      when '{' then level += 1
      when '}' then score += level; level -= 1
      end
    end
    [score, garbage_count]
  end
  
  {
    "{}" => 1,
    "{{{}}}" => 6,
    "{{},{}}" => 5,
    "{{{},{},{{}}}}" => 16,
    "{<a>,<a>,<a>,<a>}" => 1,
    "{{<ab>},{<ab>},{<ab>},{<ab>}}" => 9,
    "{{<!!>},{<!!>},{<!!>},{<!!>}}" => 9,
    "{{<a!>},{<a!>},{<a!>},{<ab>}}" => 3,
  }.each do |s, e|
    g = score_string[s].first
    next if g == e
    abort "#{s.inspect} => expected #{e}, got #{g}"
  end
  
  puts score_string[File.read("day9.txt")]
  
  {
    "<>" => 0,
    "<random characters>" => 17,
    "<<<<>" => 3,
    "<{!>}>" => 2,
    "<!!>" => 0,
    "<!!!>>" => 0,
    '<{o"i!a,<{i<a>' => 10,
  }.each do |s, e|
    g = score_string[s].last
    next if g == e
    abort "#{s.inspect} => expected #{e}, got #{g}"
  end
end

def knot_hash(list, lengths)
  pos = 0
  skip = 0

  64.times do
    lengths.each do |l|
      list = list.rotate(pos)
      list[0, l] = list[0, l].reverse
      list = list.rotate(-pos)
      pos += l + skip
      skip += 1
    end
  end
  
  list.each_slice(16).map {|b| b.reduce(&:^).to_s(16).rjust(2, '0') }.join
end

def day_10
  list = (0..255).to_a
  lengths = "88,88,211,106,141,1,78,254,2,111,77,255,90,0,54,205".each_char.map(&:ord) + [17, 31, 73, 47, 23]
  
  
  list = knot_hash(list, lengths)
  puts list
  
#  puts list.values_at(0, 1).reduce(&:*)
end

def day_11
  # left, up
  coords = {
    "ne" => Vector[-1, 1],
    "n" => Vector[0,2],
    "nw" => Vector[1,1],
    "sw" => Vector[1,-1],
    "s" => Vector[0,-2],
    "se" => Vector[-1,-1],
  }
  
  count_steps = ->(s) do
    locs = s.split(',').map {|c| coords[c] }.reduce([Vector[0,0]]) do |acc, elem|
      acc << acc.last + elem
    end
    locs.map {|l| l.map(&:abs).sum / 2 }
  end
  
  {
    "ne,ne,ne" => 3,
    "ne,ne,sw,sw" => 0,
    "ne,ne,s,s" => 2,
    "se,sw,se,sw,sw" => 3
  }.each do |s, e|
    g = count_steps[s].last
    next if g == e
    abort "#{s.inspect} => expected #{e}, got #{g}"
  end
  
  locs = count_steps[File.read("day11.txt")[0..-2]]
  puts locs.last, locs.max
end

def day_12
  s = <<-EOS
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
  EOS
  s = File.read("day12.txt")
  
  programs = Hash[s.lines.map do |l|
    _, pid, con = *l.match(/(\d+) <-> ([\d, ]+)/)
    con = con.split(', ')
    [pid.to_i, con.map(&:to_i)]
  end]
  
  all_seen = []
  until all_seen.sum(&:size) == programs.size
    seen = Set.new([programs.keys.-(all_seen.map(&:to_a).flatten).min])
    loop do
      seen_s = seen.size
      seen.to_a.each {|s| seen += programs[s] }
      break seen_s if seen_s == seen.size
    end
    all_seen << seen
  end
  p all_seen.first.size
  p all_seen.size
end

def day_13
  s = <<-EOS
0: 3
1: 2
4: 4
6: 4
  EOS
  s = File.read("day13.txt")
  
  layers = Hash[s.lines.map do |l|
    _, l, r = *l.match(/(\d+): (\d+)/)
    [l.to_i, r.to_i]
  end]
  0.upto(layers.keys.max) do |l|
    layers[l] ||= 0
  end
  
  0.upto(20000000) do |delay|
    scanners = Array.new(layers.size) {|i| layers[i].nonzero? && 0 }
    
    severity = 0
    caught = false
    layers.size.times do |pos|
      if scanners[pos] == 0 && layers[pos] > 0
#        warn "caught at #{pos}"
        severity += pos * layers[pos]
        caught = true unless pos == 0 && delay % (2 * layers[pos] - 2)  != 0
        break if caught
      end
      
      pos += delay

      scanners = scanners.each_with_index.map do |s, l|
        d = layers[l]
        next s if d.zero?
        
        cycle_length = 2 * d - 2
        [pos % cycle_length + 1, cycle_length - pos % cycle_length - 1].min
      end
    end
    
    # 1 ( 1): 0
    # 2 ( 2): 0, 1
    # 3 ( 4): 0, 1, 2, 1
    # 4 ( 6): 0, 1, 2, 3, 2, 1
    # 5 ( 8): 0, 1, 2, 3, 4, 3, 2, 1
    # 6 (10): 0, 1, 2, 3, 4, 5, 4, 3, 2, 1
    
    break puts delay unless caught
  end
end

def day_14
  key_string = "flqrgnkx"
  key_string = "vbqugkhl"
  
  rows = 0..127
  memory = rows.map do |r|
    hash = knot_hash((0..255).to_a, [key_string, r].join("-").each_char.map(&:ord) + [17,31,73,47,23])
#    p hash
    binary = hash.each_char.map {|c| c.to_i(16).to_s(2).rjust(4, '0') }.join.split('')
  end
  
#  puts memory.map(&:join)
  
  puts memory.sum {|l| l.count('1')}
  
  regions = 0
  seen = Set.new
  visit = ->(r, c) do
    break unless memory[r][c] == '1'
    break unless seen.add?([r,c])
    
    visit[r.pred, c] unless r.zero?
    visit[r, c.pred] unless c.zero?
    visit[r, c.succ] unless c >= 127
    visit[r.succ, c] unless r >= 127
  end
  memory.each_with_index do |line, r|
    line.each.each_with_index do |d, c|
      next if d != '1' || seen.include?([r,c])
      regions += 1
      visit[r, c]
    end
  end
  
  p regions
end

def day_15
#  a = 65
#  b = 8921
  
  a = 679
  b = 771
  
  avals = []
  bvals = []
  
  loop do
    lim = 5_000_000
    break if avals.count >= lim && bvals.count >= lim

    a = (a * 16807) % 2147483647
    b = (b * 48271) % 2147483647

    mod = 2 ** 16
    avals << a % mod if a % 4 == 0
    bvals << b % mod if b % 8 == 0
#    a.to_s(2).rjust(16, '0').end_with? b.to_s(2).rjust(16, '0')[-16, 16]
  end
  
  puts(avals.zip(bvals).count do |l, r|
    l == r
  end)
end

def day_16
  programs = ('a'..'p').to_a
  
  dance = "s1,x3/4,pe/b"
  dance = File.read("day16.txt")
  
  move_ = Struct.new(:type, :lhs, :rhs) do
    def move(programs)
      if :spin == type
#        programs[-lhs..-1] + programs[0..-rhs]
        programs.rotate(-lhs)
      elsif :exchange == type
        programs[lhs], programs[rhs] = programs[rhs], programs[lhs]
        programs
      elsif :partner == type
        l_ind = programs.index(lhs)
        r_ind = programs.index(rhs)
        programs[l_ind], programs[r_ind] = rhs, lhs
        programs
      end
    end
    
    def self.parse(move)
      case move
      when /^s(\d+)/
        size = $1.to_i
        new(:spin, size, size.succ)
      when /^x(\d+)\/(\d+)/
        l = $1.to_i
        r = $2.to_i
        new(:exchange, l, r)
      when /^p(\w+)\/(\w+)/
        l = $1
        r = $2
        new(:partner, l, r)
      end
    end
  end
  
  dance = dance.split(',').map! {|m| move_.parse(m) }
  
  ends = [programs.join]
  1_000_000_000.times do |i|
    dance.each do |move|
      programs = move.move(programs)
    end
    ends << programs.join
    break if ends.first == ends.last
  end
  
#  puts ends[1]
  
  puts ends[1_000_000_000 % ends.size.pred]
end

def day_17
  steps = 394
  
  buffer = [0]
  pointer = 0
  2017.times do |i|
#    puts i if i % 100000 == 0
#    pointer = (pointer + steps + 1) % i.succ
#    buffer.insert(pointer.succ, i.succ)
    buffer.rotate!(steps)
    buffer << i.succ
  end
  p buffer.first
  
  val_1 = nil
  pos = 0
  (1..50_000_000).each do |i|
    pos = (pos + steps) % i
    val_1 = i if pos.zero?
    pos += 1
  end
  p val_1
end

def day_18
  inst_ = Struct.new(:name, :register, :rhs) do
    def get_rhs(registers, rhs = self.rhs)
      rhs.is_a?(Numeric) ? rhs : registers[rhs]
    end
    
    def execute(registers, adv_inst_ptr, rcv)
      case name
      when :set
        registers[register] = get_rhs(registers)
      when :snd
        registers[name] = get_rhs(registers, register)
      when :add
        registers[register] += get_rhs(registers)
      when :mul
        registers[register] *= get_rhs(registers)
      when :mod
        registers[register] %= get_rhs(registers)
      when :rcv
        return unless get_rhs(registers, register).nonzero?
        rcv.call registers[:snd].to_s
      when :jgz
        return unless get_rhs(registers, register) > 0
        adv_inst_ptr[get_rhs(registers)]
      end
    end
    
    def self.parse(line)
      line =~ /^(\w+) ([-\w]+)( ([-\w]+))?/
      name, lhs, rhs = $1, $2, $4
      lhs = lhs.to_i if lhs =~ /\d/
      rhs = rhs.to_i if rhs =~ /\d/
      new(name.to_sym, lhs, rhs)#.tap {|i| p [line, i]}
    end
  end
    
  s = <<-S
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
  S
  s = File.read("day18.txt")
    
  program = s.lines.map {|l| inst_.parse(l) }
  registers = Hash.new {|h,k| h[k] = 0 }
  instp = 0
  loop do
    rcv = nil
    program[instp].execute(registers, ->(p) { instp += p - 1}, ->(r) { rcv = r })
    break puts rcv if rcv
    instp += 1
  end
end