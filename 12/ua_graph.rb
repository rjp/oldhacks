require 'svg/svg'
require 'time'

spans = Hash.new {|h,k| h[k] = []}
timeon = Hash.new(0)

min, max = 1000000000,-1

$stdin.readlines.each { |line|
	userid, on, off = line.split(' ')
	on = on.to_i; off = off.to_i
	spans[userid].push([on, off])
	timeon[userid] = timeon[userid] + off - on
	if on < min then min = on; end
	if off > max then max = off; end
}

puts "range=#{min}-#{max}"
scale = 800.0/(max-min)

# work out weekends and highlight?

colours = %w{red blue green magenta cyan}
col_index = 0

svg = SVG.new('8in', '4in')
spans.keys.sort_by {|k| timeon[k]}.reverse.each_with_index { |user, i|
	y = 4 + 3*i
	puts "plotting #{user} at y=#{y}, s=#{scale}"
	spans[user].each { |s,e|
		xs = 10 + (s-min)*scale
		xe = 10 + (e-min)*scale
		puts "(#{xs},#{y})-(#{xe},#{y})"
		svg << SVG::Line.new(xs, y, xe, y) { self.style = SVG::Style.new(:stroke_width => '2', :fill => 'none', :stroke => colours[col_index]) }
	}
	col_index = (col_index + 1) % colours.size
}	
$stderr.puts svg.to_s
