def points_for_home_win(hs, as, home, away)
	if away[:pos] < 11 then 
		return 4, 0, 0, 0    
	else
		return 2, 0, 0, 0
	end
end

def points_for_home_loss(hs, as, home, away)
	if home[:pos] < 11 then 
		return 0, 0, 4, 0
	else
		return 0, 0, 2, 0
	end
end

def points_for_draw(hs, as, home, away)
    return 1, 0, 1, 0
end

def extra_bonus_points(hs, as, home, away)
	return 0,0
end

def sort_table(table)
	proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }
end
