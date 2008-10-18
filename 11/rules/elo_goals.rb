$initial_points = 1500

def desc
    "ELO rankings, SA=goals scored"
end

def elo(r, ro, scored)
    expected = 1.0/(1+10**((ro-r)/400.0))
    offset = 32*(scored-expected)
    return offset
end

def points(game, hi, ai)
    home, away, hs, as, date, hhs, ahs = game
    h = hi[:points]
    a = ai[:points]

	if hs != as then
	# should the losing team get no points for a loss?
	# or is that yet another ruleset?
	    nh = elo(h, a, hs-as)
   		na = elo(a, h, as-hs)
	else 
    	nh = elo(h, a, 0.5)
	    na = elo(a, h, 0.5)
	end
    return nh, 0, na, 0
end

def extra_bonus_points(game, hi, ai)
	return 0,0
end

def sort_table(table)
	proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }
end
