def pos_to_points(p)
	return (2+2*(p+3.5)/19.0).to_i
end

def points_for_home_win(hs, as, hp, ap)
	p = pos_to_points(ap)
    return p, 0, 0, 0
end

def points_for_home_loss(hs, as, hp, ap)
	p = pos_to_points(hp)
    return 0, 0, p, 0
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
