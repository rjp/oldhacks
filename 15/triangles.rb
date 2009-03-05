require 'rubygems'
require 'rmagick'

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

frame = 0
left = 50
right = 500-left
gc = Magick::Draw.new
gc.fill('#ffffff')

lines = Hash.new { |h,k| h[k] = [] }
    
	c="12101"
	a=left
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
                frame = frame + 1
                gc.stroke('#000000')
                gc.line(right+oa, ob, right+a, b)
                first = "#{na} #{nb}"
                lines[first].push "#{noa} #{nob}"
                lines[first].each { |second|
                    lines[second].each { |third|
                        lines[third].each { |fourth|
                            if fourth == first then
                                x = [first, second, third].sort.join(' ')
                                if done[x].nil? then
                                    m = triangles % 32
                                    n = m % 16
                                    p = m > 15 ? 15-n : n
                                    fill = sprintf("#%02x%02x%02x", 17*p, 255-17*p, (128+17*p)%255)
                                    points = "#{first} #{second} #{third} #{fourth}".split(' ')
                                    gc.polygon(*points)
                                    triangles = triangles + 1
                                end
                                done[x] = 1
                            end
                        }
                    }
                }
                $stderr.puts "#{frame},#{triangles}"
                canvas = Magick::Image.new(700, 200, Magick::HatchFill.new('white','white'))
                gc.draw(canvas)
                filename = sprintf("png/frame%04d.png", frame)
                canvas.write(filename)
            end
	        oa = a
	        ob = b
            noa = na
            nob = nb
	    end
        i = i + 1
	end
