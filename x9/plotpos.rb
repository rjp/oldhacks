require 'yaml'
require 'digest/md5'

infohash = YAML.load(File.new(ARGV[0]))
title = "League 2008/9: canspurswin"

puts <<HEADER
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
  "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="24cm" height="24cm" viewBox="0 0 400 400"
  xmlns="http://www.w3.org/2000/svg" version="1.1">
<title>#{title}</title>
<desc>League Positions vs Games Played</desc>
<rect x="1" y="1" width="398" height="398" fill="none" stroke="blue" />
HEADER

start=7
infohash.keys.each { |team|
    colour = Digest::MD5.hexdigest(team)[-6..-1]
    y = infohash[team][start] * 10 +3
    puts %Q{<text x="5" y="#{y}" font-size="8" fill="black">#{team}</text>}
    puts %Q{<path d="M #{start*10+10} #{y-3} }
    i=start
    puts infohash[team][start..37].map {|p|
        y = p * 10
        x = 10 + i * 10
        i = i + 1
        "L #{x} #{y}"
    }.join(' ')
    puts %Q{" stroke="##{colour}" fill="none"/>}



    start.upto(37) { |i|
        if i == 7 then
            $stderr.puts "#{team}/7 = #{infohash[team][i]}"
        end
        y = infohash[team][i] * 10
        x = 10 + i * 10
        puts %Q{<circle cx="#{x}" cy="#{y}" r="1.5" fill="##{colour}" stroke="##{colour}"/><!-- #{team}[#{i}]=#{infohash[team][i]} -->}
    }
}

puts <<FOOTER
</svg>
FOOTER
