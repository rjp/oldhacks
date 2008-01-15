require 'time'

$day_start = Time.parse(ARGV[1]).to_i
$day_end = $day_start + 86400

$slots = Array.new(288)
$blocks = Array.new(1440)
$colourmap = Hash.new()

$colours = [ 
    [0.0,0.0,1.0], [1.0,0.0,0.0], [1.0,1.0,0.0],
    [1.0,0.0,1.0], [0.0,1.0,1.0], [0.0,1.0,0.0],
    [0.5,0.5,0.5], [0.5,1.0,0.5], [1.0,0.5,0.5]
]

# colours = ['red', 'blue', 'green', 'purple', 'yellow', 'orange']
$cindex = 0

def parse_file(filename)

File.open(filename).readlines.each { |i| 
	next unless i =~ /\d+ ..:.. (<|\*)/

	ts, hm, who, who2, junk = i.gsub(/[<>]/,'').split(' ', 5)

	break if ts.to_i >= $day_end
	next if ts.to_i < $day_start

	if (who == '*') then who = "<#{who2}>"; end
    who.gsub!(/[<>@ ]/, '')

	hours, minutes = hm.split(':')

	offset = 12*hours.to_i + (minutes.to_i/5)
	daymin = 60*hours.to_i + minutes.to_i

    if $colourmap[who].nil? then
        $colourmap[who] = [$cindex, $colours[$cindex]]
        $cindex = ($cindex + 1) % $colours.size
    end

	if ($slots[offset].nil?) then $slots[offset] = []; end
	if ($blocks[daymin].nil?) then $blocks[daymin] = []; end
	$blocks[daymin].push [60*hours.to_i+minutes.to_i, $colourmap[who][1], 2*offset, 2*$slots[offset].size]
	$slots[offset].push [hm, $colourmap[who][1]]
}

    return $blocks, $slots, $colourmap
end

Shoes.app :width => 576, :height => 150 do
    height = 150
	minutes = 360 
	index = 0

    blocks, slots, users = parse_file(ARGV[2])
    
    timecount = nil
    stack do
        flow do 
            timecount = para '00:00'
            users.sort_by{|v| v[1][0]}.each { |i|
                para i[0], :stroke => rgb(*(i[1][1]))
            }
        end
    end

	animate(15) do
		if minutes < 1440 then
			h = minutes / 60
			m = minutes % 60

			timecount.replace (sprintf '%02d:%02d', h, m)
	
			unless blocks[minutes].nil? then
				blocks[minutes].each {|i|
					m, c, x, y = *i
                    append do
	                    nostroke
	                    fill rgb(*c)
	                    rect x, height-y-8, 2, 2
                    end
        		}
	    	end
			minutes = minutes + 1
		end
	end
end
