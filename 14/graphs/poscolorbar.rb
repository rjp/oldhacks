require 'svg/svg'
require 'yaml'

history = YAML.load_file(ARGV[0])
$stderr.puts history['Chelsea'].inspect
teams = history.keys.sort
wscale = 10
height = teams.size

history = YAML.load_file(ARGV[2])

svg = SVG.new('4in', '8in')
teams.each_with_index { |team, i|
    short = team.gsub(/^(\S)(\S+)(\s|_)/, '\1').gsub(/[aeiou]/,'').upcase.gsub(/[^A-Z]/,'').gsub(/(.)\1\1(.)/,'\1\1\2')[0..2]
    y = 25*i+20
    junk = history[team].shift
    colours = []
    history[team].each_with_index { |hist, j|
        x = wscale*j + 50
        c1 = case hist[3] 
            when 'L': '#ffcccc'
            when 'D': '#ccccff'
            when 'W': '#ccffcc'
        end
        p = hist[0]
        ct = 255 * ((20.0 - p) / 20.0)
        c2 = sprintf("#%2x%2x%2x", ct, ct, ct)
        $stderr.puts "#{team} #{p}/20 = #{(20.0-p)/20.0} => #{ct} (c1=#{c1})"
        svg << SVG::Rect.new(x, y-9, wscale, 10) { self.style = SVG::Style.new(:fill => c1)}
        svg << SVG::Rect.new(x, y-19, wscale, 10) { self.style = SVG::Style.new(:fill => c2)}
    }
    svg << SVG::Text.new(5, y-3, short) { self.style = SVG::Style.new(:font_size => 6)}
}

print svg.to_s
