require 'svg/svg'
require 'yaml'

history = YAML.load_file(ARGV[0])

teams = history.keys.sort
wscale = 3
legend = teams.size * 2

svg = SVG.new('4in', '4in')
teams.each_with_index { |team, i|
    y = 15*i + 15
    junk = history[team].shift
    svg << SVG::Line.new(wscale-1, y, (legend-2)*wscale+1, y) { self.style = SVG::Style.new(:stroke=>'black') }
    history[team].each_with_index { |hist, j|
        x = wscale*j + wscale
        case hist[3] 
            when 'W' 
                svg << SVG::Line.new(x, y, x, y-5) { self.style = SVG::Style.new(:fill => 'none', :stroke => 'black') }
            when 'L'
                svg << SVG::Line.new(x, y, x, y+5) { self.style = SVG::Style.new(:fill => 'none', :stroke => 'black') }
            else
                svg << SVG::Line.new(x, y-1, x, y+1) { self.style = SVG::Style.new(:fill => 'none', :stroke => 'black') }
        end
    }
    svg << SVG::Text.new(legend*wscale, y+5, team)

}

print svg.to_s
