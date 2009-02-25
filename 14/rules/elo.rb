$initial_points = 1500

def desc
	"ELO rankings, avg=1500"
end
	
def elo(r, ro, scored)
	# TODO investigate the 400
    expected = 1.0/(1+10**((ro-r)/400.0))
    offset = 32*(scored-expected)
    return offset
end

def points(game, hi, ai)
	home, away, hs, as, date, hhs, ahs = game 
    h = hi[:points]
    a = ai[:points]

	if hs > as then 
		hscore = 1
        ascore = 0
	elsif as > hs then
		hscore = 0
        ascore = 1
	else
		hscore = 0.5
        ascore = 0.5
	end
		
    nh = elo(h, a, hscore)
    na = elo(a, h, ascore)

    return nh, 0, na, 0
end

def extra_bonus_points(game, hi, ai)
	return 0,0
end

def sort_table(table)
	proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }
end
