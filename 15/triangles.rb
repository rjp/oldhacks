def round(v, r=0.5)
    scale = 1000000.0
    sv = v * scale
    sr = r * scale

    diff = sv % sr
    if diff < sr/2 then
        sv = sv - diff
    else
        sv = sv + (sr - diff)
    end
    return sv/scale
end

done = {}
limit = ARGV[0].to_i || 400

$stderr.puts <<SVGHEAD
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
  "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="8cm" height="8cm" viewBox="0 0 400 400"
  onload="init();" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns="http://www.w3.org/2000/svg" version="1.1" id="plotpos">
<title>Triangles</title>
<desc>Triangles</desc>
SVGHEAD

lines = Hash.new { |h,k| h[k] = [] }
    
	c="12101"
	a=50.0
	b=50.0
	r=5.5
	i=0
	oa=a
	ob=b
    na, nb, noa, nob = a, b, oa, ob
    xp = []
    yp = []
    off = 0
    triangles = 0
    loop do
        if triangles >= limit then break; end

	    e = c[i % c.size] - 48
	    d = (e==1) ? 8 : 0
	    if i < 7 then
	        c = c.split("1").join("12101")
	    else
	        r = r + 2.094 * (e-1)
	        a = a + d * Math.cos(r)
	        b = b + d * Math.sin(r)
            na = round(a)
            nb = round(b)
            if a != oa and b != ob then
                printf "R line (%g,%g) (%g,%g)\n", oa, ob, a, b
                printf "N line (%g,%g) (%g,%g)\n\n", noa, nob, na, nb
                first = "#{na} #{nb}"
                lines[first].push "#{noa} #{nob}"
                lines[first].each { |second|
                    lines[second].each { |third|
                        lines[third].each { |fourth|
                            puts "C #{first} #{second} #{third} #{fourth}"
                            if fourth == first then
                                x = [first, second, third].sort.join(' ')
                                if done[x].nil? then
                                    puts "T #{first} #{second} #{third}"
                                    m = triangles % 32
                                    n = m % 16
                                    p = m > 15 ? 15-n : n
                                    fill = sprintf("#%02x%02x%02x", 17*p, 255-17*p, (128+17*p)%255)
                                    $stderr.puts %Q{<path d="M #{first} L #{second} #{third} #{fourth}" stroke="black" fill="#{fill}"/><!-- #{x} -->}
                                    triangles = triangles + 1
                                end
                                done[x] = 1
                            end
                        }
                    }
                }
            end
	        oa = a
	        ob = b
            noa = na
            nob = nb
	    end
        i = i + 1
	end
    $stderr.puts "</svg>"
