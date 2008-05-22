def desc
    "normal football rules"
end

def points(game, hi, ai)
    home, away, hs, as, date, hhs, ahs = game

    if hs > as then
        hi[:result] = 'W'
        ai[:result] = 'L'
        return points_for_home_win()
    elsif as > hs then
        ai[:result] = 'W'
        hi[:result] = 'L'
        return points_for_home_loss()
    else
        ai[:result] = 'D'
        hi[:result] = 'D'
        return points_for_draw()
    end
end
    
def points_for_home_win
    return 3, 0, 0, 0
end

def points_for_home_loss
    return 0, 0, 3, 0
end

def points_for_draw
    return 1, 0, 1, 0
end

def extra_bonus_points(game, hi, ai)
	return 0,0
end

def sort_table(table)
	proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }
end
