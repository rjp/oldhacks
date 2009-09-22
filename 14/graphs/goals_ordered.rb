require 'svg/svg'
require 'yaml'

history = YAML.load_file(ARGV[0])

teams = history.keys.sort_by {|i| history[i][-1][0] } # final position
wscale = 3
height = teams.size
goals_for = []
goals_against = []

svg = SVG.new('4in', '8in')
teams.each_with_index { |team, i|
    y = (height+2)*i + height
    junk = history[team].shift
    g_for = history[team][-1][6]
    g_against = history[team][-1][7]
    goals_for.push g_for
    goals_against.push g_against
}

left_scale = goals_against.max
right_scale = goals_for.max

teams.each_with_index { |team, i|
    y = (height+2)*i + height

    lx = 100 * goals_against[i] / left_scale
    rx = 100 * goals_for[i] / right_scale

    svg << SVG::Rect.new(150 - lx, y-10, lx, height) { self.style = SVG::Style.new(:fill => '#ffdddd')}
    svg << SVG::Rect.new(150, y-10, rx, height) { self.style = SVG::Style.new(:fill => '#ddffdd')}
    svg << SVG::Text.new(130, y+5, goals_against[i].to_s)
    svg << SVG::Text.new(160, y+5, goals_for[i].to_s)
    svg << SVG::Text.new(10, y+5, team)
}

print svg.to_s
