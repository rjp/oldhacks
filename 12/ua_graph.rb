require 'svg/svg'


spans = Hash.new {|h,k| h[k] = []}
timeon = Hash.new(0)

min, max = 1000000000,-1

$stdin.readlines.each { |line|
	userid, on, off = line.split(' ')
	spans[userid].push([on, off])
	timeon[userid] = timeon[userid] + off - on
	if min < on then min = on; end
	if off > max then max = off; end
}

puts "range=#{min}-#{max}"
scale = (max-min)/800.0

spans.keys.sort_by {|k| timeon[k]}.each_with_index { |user, i|
	y = 4 + 2*i
	spans[user].each { |s,e|
		xs = 10 + (s-min)*scale
		xe = 10 + (e-min)*scale
		puts "(#{xs},#{y})-(#{xe},#{y})"
	}
}	
