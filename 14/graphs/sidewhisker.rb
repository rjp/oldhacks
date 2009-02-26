require 'svg/svg'
require 'yaml'

history = YAML.load_file(ARGV[0])

teams = history.keys.sort
wscale = 3
right = wscale*42 + 3*wscale

svg = SVG.new('8in', '8in')
teams.each_with_index { |team, i|
    y = 15*i + 15
    junk = history[team].shift
#    svg << SVG::Line.new(wscale-1, y, 38*wscale+1, y) { self.style = SVG::Style.new(:stroke=>'#888888', :stroke_width=> 1) }
    svg << SVG::Line.new(right+wscale-1, y, right+38*wscale+1, y) { self.style = SVG::Style.new(:stroke=>'#888888', :stroke_width=> 1) }
    history[team].each_with_index { |hist, j|
        offset = case hist[5] 
		when 'H': 0
		when 'A': right
	end
	stroke = 'black'
        lx = wscale*j + wscale
        x = wscale*j + wscale + offset
        svg << SVG::Circle.new(lx, y, 0.5) { self.style = SVG::Style.new(:fill => '#888888', :stroke => 'none') }
        svg << SVG::Circle.new(lx+right, y, 0.5) { self.style = SVG::Style.new(:fill => '#888888', :stroke => 'none') }
        case hist[3] 
            when 'W' 
                svg << SVG::Circle.new(x, y-1, 1.5) { self.style = SVG::Style.new(:fill => '#448844', :stroke => 'none') }
                svg << SVG::Circle.new(x, y-2, 1.5) { self.style = SVG::Style.new(:fill => '#448844', :stroke => 'none') }
            when 'L'
                svg << SVG::Circle.new(x, y+2, 1.5) { self.style = SVG::Style.new(:fill => '#884444', :stroke => 'none') }
                svg << SVG::Circle.new(x, y+1, 1.5) { self.style = SVG::Style.new(:fill => '#884444', :stroke => 'none') }
            else
                svg << SVG::Circle.new(x, y, 1.5) { self.style = SVG::Style.new(:fill => '#444488', :stroke => 'none') }
        end
    }
    svg << SVG::Text.new(right+42*wscale, y+5, team)

}

print svg.to_s
