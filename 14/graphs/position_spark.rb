require 'svg/svg'
require 'yaml'

history = YAML.load_file(ARGV[0])

teams = history.keys.sort
wscale = 3
height = teams.size

svg = SVG.new('4in', '8in')
teams.each_with_index { |team, i|
    y = (height+2)*i + height
    junk = history[team].shift
    points = []
    history[team].each_with_index { |hist, j|
        x = wscale*j + wscale
        yo = hist[0] - 10 
        points.push(x, y+yo)
    }
    if i%2==0 then
    svg << SVG::Rect.new(wscale, y-10, wscale*37, height) { self.style = SVG::Style.new(:fill => '#ffdddd')}
    else
    svg << SVG::Rect.new(wscale, y-10, wscale*37, height) { self.style = SVG::Style.new(:fill => '#ddffdd')}
    end
    svg << SVG::Polyline.new(SVG::Point[*points]) { self.style = SVG::Style.new(:stroke_width => '0.5',:fill =>'none', :stroke => 'black') }
    svg << SVG::Text.new(40*wscale, y+5, team)

}

print svg.to_s
