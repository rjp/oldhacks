def desc
    "normal football rules, away goals count double"
end

def points(game, hi, ai)
    home, away, hs, as, date, hhs, ahs = game

    if hs > as*2 then
        hi[:result] = 'W'
        ai[:result] = 'L'
        hi[:homewin] = hi[:homewin] + 1
        return [points_for_home_win(), hs, as*2].flatten
    elsif as*2 > hs then
        ai[:result] = 'W'
        hi[:result] = 'L'
        return [points_for_home_loss(), hs, as*2].flatten
    else
        ai[:result] = 'D'
        hi[:result] = 'D'
        return [points_for_draw(), hs, as*2].flatten
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
