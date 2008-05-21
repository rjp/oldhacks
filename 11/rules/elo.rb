$initial_points = 1500
	
def elo(h, a, scored)
    r = h[:points]
    ro = a[:points]
    expected = 1.0/(1+10**((ro-r)/400.0))
    offset = 32*(scored-expected)
    return offset
end

def points_for_home_win(hs, as, h, a)
    nh = elo(h, a, 1)
    na = elo(a, h, 0)
    return nh, 0, na, 0
end

def points_for_home_loss(hs, as, h, a)
    nh = elo(h, a, 0)
    na = elo(a, h, 1)
    return nh, 0, na, 0
end

def points_for_draw(hs, as, h, a)
    nh = elo(h, a, 0.5)
    na = elo(a, h, 0.5)
    return nh, 0, na, 0
end

def extra_bonus_points(hs, as, h, a)
	return 0,0
end

def sort_table(table)
	proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }
end
