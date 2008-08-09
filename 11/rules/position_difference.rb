def points_for_home_win(hs, as, hp, ap)
	if hp > ap then 
		return 3, 0, 0, 0    
	else
		return 2, 0, 0, 0
	end
end

def points_for_home_loss(hs, as, hp, ap)
	if ap > hp then 
		return 0, 0, 4, 0
	else
		return 0, 0, 2, 0
	end
end

def points_for_draw(hs, as, hp, ap)
    return 1, 0, 1, 0
end

def extra_bonus_points(hs, as, hp, ap)
	return 0,0
end

def sort_table(table)
	proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }
end
