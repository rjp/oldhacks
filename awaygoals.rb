def gen_scores
    games = []
    0.upto(25) { |goals|
        0.upto(goals) { |home|
            games.push [home, goals-home]
        }
    }
    return games
end

leg1 = gen_scores
leg2 = leg1.clone

block_size = 1

Shoes.app :height => block_size*leg1.size, :width => block_size*leg1.size do
  stack :margin => 10 do
	leg1.each_with_index { |s,i1|
        t1, t2 = *s
	    leg2.each_with_index { |l,i2|
            l2, l1 = *l
            if (t1+l1 == t2+l2) then
                colour = [0.5,0.5,0.5] # draw
                if (t2 > l1) then
                   colour = [1.0,0.0,0.0] # T2 wins on away goals
                elsif (l1 > t2) then
                   colour = [0.0,0.0,1.0] # T1 wins on away goals
                end
            elsif (t1+l1 > t2+l2) then # T1 wins outright
                colour = [1.0,0.8,1.0]
            else 
                colour = [1.0,1.0,0.8] # or maybe T2 wins outright
            end
            # puts "#{result} L1:#{t1}-#{t2} L2:#{l1}-#{l2} T1:#{t1+l1} T2:#{t2+l2} #{colour.inspect}"
            stroke rgb(*colour)
            fill rgb(*colour)
            rect block_size*i1, block_size*i2, block_size, block_size
	    }
	}
  end
end
