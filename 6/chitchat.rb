require 'time'

day_start = Time.parse(ARGV[1]).to_i
day_end = day_start + 86400

slots = Array.new(288)
blocks = Array.new(1440)
colourmap = Hash.new()

colours = [ 
    [0.0,0.0,1.0], [1.0,0.0,0.0], [1.0,1.0,0.0],
    [1.0,0.0,1.0], [0.0,1.0,1.0], [0.0,1.0,0.0]
]


# colours = ['red', 'blue', 'green', 'purple', 'yellow', 'orange']
cindex = 0

File.open(ARGV[2]).readlines.each { |i| 
	next unless i =~ /\d+ ..:.. (<|\*)/

	ts, hm, who, who2, junk = i.gsub(/[<>]/,'').split(' ', 5)

	break if ts.to_i >= day_end
	next if ts.to_i < day_start

	if (who == '*') then who = "<#{who2}>"; end
    who.gsub!(/[<>@ ]/, '')

	hours, minutes = hm.split(':')

	offset = 12*hours.to_i + (minutes.to_i/5)
	daymin = 60*hours.to_i + minutes.to_i

    if colourmap[who].nil? then
        colourmap[who] = colours[cindex]
        cindex = (cindex + 1) % colours.size
    end

	if (slots[offset].nil?) then slots[offset] = []; end
	if (blocks[daymin].nil?) then blocks[daymin] = []; end
	blocks[daymin].push [60*hours.to_i+minutes.to_i, colourmap[who], 2*offset, 2*slots[offset].size]
	slots[offset].push [hm, colourmap[who]]
}
max = -1
slots.each { |i| unless (i.nil?) then if (i.size > max) then max = i.size; end; end }

height = 20+max*2

$todraw = []

Shoes.app :width => 576, :height => height do
	minutes = 360 
	index = 0

	animate(15) do
		if minutes < 1441 then
		clear do
				h = minutes / 60
				m = minutes % 60

				stack do
					para sprintf '%02d:%02d', h, m
				end
	
				unless blocks[minutes].nil? then
					blocks[minutes].each {|i|
						m, c, x, y = *i
						$todraw.push [x, height-y-8, c]
					}
				end

				$todraw.each { |i|
					x, y, c = *i
					nostroke
                    if c.is_a?(Array) then
    					fill rgb(*c)
                    else
                        fill c
                    end
					rect x, y, 2, 2
				}
					
			minutes = minutes + 1
		end
		end
	end
end
