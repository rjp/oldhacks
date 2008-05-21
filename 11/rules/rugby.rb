def points_for_home_win(hs, as, h, a)
    v = [4, 0, 0, 0]
    if as.to_i+1 >= hs.to_i then v[3] = 1; end
    return *v
end

def points_for_home_loss(hs, as, h, a)
    v = [0, 0, 4, 0]
    if hs.to_i+1 >= as.to_i then v[1] = 1; end
    return *v
end

def points_for_draw(hs, as, h, a)
    return 2, 0, 2, 0
end

def extra_bonus_points(hs, as, h, a)
    hb, ab = 0, 0
    if hs.to_i >= 4 then hb = 1; end
    if as.to_i >= 4 then ab = 1; end
    return hb, ab
end

def sort_table(table)
	proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }
end
