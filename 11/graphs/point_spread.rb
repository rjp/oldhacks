require 'svg/svg'
require 'yaml'

history = YAML.load_file(ARGV[0])

teams = history.keys.sort
wscale = 3

svg = SVG.new('4in', '6in')
all_points = []
teams.each_with_index { |team, i|
	final = history[team].last
	points = final[1]	
	all_points.push(points)
}

sorted_points = all_points.sort
min, max = sorted_points.first, sorted_points.last

o = []
sorted_points.sort.each { |points|
	y = 200-(200*(points-min)/(max-min)) +15
    svg << SVG::Line.new(10, y, 50, y) { self.style = SVG::Style.new(:stroke_width => '0.5',:fill =>'none', :stroke => 'black') }
	o.push([points, y])
}

print svg.to_s
