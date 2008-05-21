def points_for_home_win(hs, as, h, a)
    return 2, 0, 0, 0
end

def points_for_home_loss(hs, as, h, a)
    return 0, 0, 4, 0
end

def points_for_draw(hs, as, h, a)
    return 1, 0, 1, 0
end

def extra_bonus_points(hs, as, h, a)
	return 0,0
end

def sort_table(table)
	proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }
end
