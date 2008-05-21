def elo(r, ro, scored)
    expected = 1.0/(1+10**((ro-r)/400.0))
    return 32*(scored-expected)
end

def points_for_home_win(hs, as, hp, ap)
    return elo(hp, ap, 1), 0, elo(ap, hp, 0), 0
end

def points_for_home_loss(hs, as, hp, ap)
    return elo(hp, ap, 0), 0, elo(ap, hp, 1), 0
end

def points_for_draw(hs, as, hp, ap)
    return elo(hp, ap, 0.5), 0, elo(ap, hp, 0.5), 0
end

def extra_bonus_points(hs, as, hp, ap)
	return 0,0
end

def sort_table(table)
	proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }
end
