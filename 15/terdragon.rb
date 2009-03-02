Shoes.app :width => 500, :height => 500 do
	c="12101"
	a=50
	b=50
	r=5.5
	i=0
	oa=50
	ob=50
    xp = []
    yp = []
    off = 0
stroke rgb(0,0,0)
    stack do 
    animate(30) do
#    loop do
	    e = c[i % c.size] - 48
#    puts "frame #{i} c=#{c} e=#{e}"
	    d = (e==1) ? 8 : 0
	    if i < 7 then
	        c = c.split("1").join("12101")
#            puts "c is #{c}"
	    else
	        r = r + 2.094 * (e-1)
	        a = a + d * Math.cos(r)
	        b = b + d * Math.sin(r)
            append do
    	        line oa, ob, a, b
            end
#printf "line (%d,%d) (%d,%d)\n", oa, ob, a, b
	        oa = a
	        ob = b
	    end
        i = i + 1
	end
    end
end
