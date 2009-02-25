require 'yaml'
require 'digest/md5'

infohash = YAML.load($stdin)
title = "League 2008/9: points"
height = infohash.keys.size * 10 + 13
offset = 75
width = 1150

puts <<HEADER
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
  "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="24cm" height="5cm" viewBox="0 0 #{width} #{height}"
  xmlns="http://www.w3.org/2000/svg" version="1.1">
<title>#{title}</title>
<desc>League Points vs Games Played</desc>
<rect x="1" y="1" width="#{width-2}" height="#{height-2}" fill="none" stroke="blue" />
HEADER

start=1
infohash.keys.each { |team|
    data = infohash[team]
    first = data[0]
    colour = Digest::MD5.hexdigest(team)[-6..-1]
    y = first * 10 +3
    puts %Q{<text x="#{offset}" y="#{y}" font-size="8" fill="##{colour}" text-anchor="end">#{team}</text>}
    puts %Q{<text x="#{width-100}" y="#{data[-1]*10+3}" font-size="8" fill="##{colour}">#{team}</text>}
    puts %Q{<path d="M #{start*10+offset} #{y-3} L }
    i = 2
    x = data.shift
    puts data[1..-1].map {|p|
        y = p * 10
        x = i * 10
        i = i + 1
        "#{x+offset} #{y}"
    }.join(' ')
    puts %Q{" stroke="##{colour}" fill="none"/>}

    counter = 0
    start.upto(data.size-1) { |i|
        j=i+1
        y = data[i] * 10
        x = j * 10 + offset
        if i == data.size-1 then
            puts %Q{<circle cx="#{x}" cy="#{y}" r="2" fill="##{colour}" stroke="##{colour}" title="#{team}"/>}
        else 
            puts %Q{<path d="M #{x} #{y-1} L #{x} #{y+1}" fill="none" stroke="##{colour}"/>}
        end
        counter = counter + 1
    }
}

puts <<FOOTER
</svg>
FOOTER
