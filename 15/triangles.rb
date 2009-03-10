require 'rubygems'
require 'rmagick'

lookups = 0
optim_lookups = 0
optim_lines = Hash.new { |h,k| h[k] = {} }

counter = Hash.new(0)

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

width=100
clean_canvas = Magick::Image.new(width, width) { self.background_color = 'white' }

done = {}
limit = ARGV[0].to_i || 400

frame = 0
left = 150
right = (width/2)
gc = Magick::Draw.new
gc.fill('#ff8888')

lines = Hash.new { |h,k| h[k] = [] }
    
	c="12101"
	a=left
	b=100.0
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
	        r = r + 2.0943951023932 * (e-1)
	        a = a + d * Math.cos(r)
	        b = b + d * Math.sin(r)
            na = round(a)
            nb = round(b)
            if a != oa and b != ob then
                frame = frame + 1
                gc.stroke('#000000')
                gc.line(right+oa, ob, right+a, b)
#               gc.line(oa, ob, a, b)
#puts "l=#{frame} (#{oa}, #{ob}) (#{a}, #{b}) [(#{noa}, #{nob}) (#{na}, #{nb})]"
# we have a line from noa,nob to oa,ob
# if there's a line ending at noa,nob which starts at X,Y and a line starting at oa,ob ending at X,Y, triangle!
                l_start = "#{noa} #{nob}"
                l_end = "#{na} #{nb}"

                optim_lines[l_start][l_end] = 1
                optim_lines[l_end][l_start] = 1

                oo = optim_lines[l_start].keys
                op = optim_lines[l_end].keys
                tr = oo & op
                if tr != [] then
                    puts "z #{l_start} #{tr} #{l_end}"
                end

                # look for lines touching this point
                optim_lines[l_start].each { |k,v|
                    puts "x #{l_start}: #{k}"
                    optim_lookups = optim_lookups + 1
                    if optim_lines[k][l_end] == 1 then
                        puts "y #{l_start} #{k} #{l_end}"
                    end
                }

                first = "#{na} #{nb}"
                lines[first].push ["#{noa} #{nob}", frame, noa, nob]
                lines[first].each { |second, si, sx, sy|
                    lines[second].each { |third, thi, thx, thy|
                        lines[third].each { |fourth, fi, fx, fy|
                            lookups = lookups + 1
                            if fourth == first then
                                x = [first, second, third].sort.join(' ')
                                if done[x].nil? then
                                    order = [[first, fi, fx, fy], [second, si, sx, sy], [third, thi, thx, thy]].sort_by {|xx,yy,aa,bb| yy}
# calculate the cross product for clockwise/anti
									cc = 0
									0.upto(order.size-1) { |ii|
									    j = (ii+1) % order.size
									    k = (ii+2) % order.size
line = "#{order[ii][2]} #{order[ii][3]} #{order[j][2]} #{order[j][3]}"
counter[line] = counter[line] + 1
									    z = (order[j][2] - order[ii][2]) * (order[k][3] - order[j][3])
									    z = z - (order[j][3] - order[ii][3]) * (order[k][3] - order[j][3])
									    if z < 0 then cc = cc - 1; else cc = cc + 1; end
									}
                                    triangles = triangles + 1
		                            if cc > 0 then gc.fill('#ff4444'); else gc.fill('#44ff44'); end
                                    points = [fx, fy, sx, sy, thx, thy, fx, fy]
                                    gc.stroke('#888888')
                                    gc.polygon(*points)
perimeter = 0
counter.each { |h,k|
    if k == 1 then
        perimeter = perimeter + 1
    end
}
puts "DATA,#{frame},#{triangles},#{cc},#{perimeter},#{lookups},#{optim_lookups}"
                                end
                                done[x] = 1
                            end
                        }
                    }
                }
                $stderr.puts "#{frame},#{triangles}"
                if 0 and triangles == limit then # or (frame > 193 and frame < 196) or (frame > 219 and frame < 222) then
                canvas = clean_canvas.dup
                x = Magick::Draw.new
                x.text(10, 20, "Lines: #{frame} Triangles: #{triangles}") {
                    self.font = "/cygdrive/c/WINDOWS/Fonts/arial.ttf"
                    self.font_size = 10
                    self.font_weight = 100
                }
                gc.draw(canvas)
                x.draw(canvas)
                filename = sprintf("png/frame%04d.png", frame)
                canvas.write(filename) { self.depth = 8 }
                canvas.destroy!
                end
            end
	        oa = a
	        ob = b
            noa = na
            nob = nb
	    end
        i = i + 1
	end

puts "L=#{lookups} OL=#{optim_lookups}"
