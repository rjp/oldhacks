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
    loop do
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
                first = "#{na}:#{nb}"
                lines[first].push "#{noa}:#{nob}"
                lines[first].each { |second|
                    lines[second].each { |third|
                        lines[third].each { |fourth|
                            puts "C #{first} #{second} #{third} #{fourth}"
                            if fourth == first then
                                puts "T #{first} #{second} #{third}"
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
