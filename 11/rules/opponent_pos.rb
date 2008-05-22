def desc
	"2pt for beating bottom 5, 4pt for top 5, otherwise 3pt"
end

def pos_to_points(team)
	p = team[:pos]
	return 6-(2+2*(p+3.5)/19.0).to_i
end

def points(game, hi, ai)
	home, away, hs, as, date, hhs, ahs = game 

	if hs > as then
		p = pos_to_points(ai[:pos])
		q = 0
	elsif as > hs then
		p = 0
		q = pos_to_points(hi[:pos])
	else
		p, q = 1, 1
	end

    return p, 0, q, 0
end

def extra_bonus_points(game, hi, ai)
	return 0,0
end

def sort_table(table)
	proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }
end
