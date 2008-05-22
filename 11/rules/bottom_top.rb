def desc
	"2pts for beating bottom half, 4pts for top half"
end

def points(game, hi, ai)
    home, away, hs, as, date, hhs, ahs = game

	if hs > as then
		hi[:result] = 'W'
		ai[:result] = 'L'
		if ai[:pos] < 11 then
			return 4, 0, 0, 0
		else
			return 2, 0, 0, 0
		end
	elsif as > hs then
		ai[:result] = 'W'
		hi[:result] = 'L'
		if hi[:pos] < 11 then 
			return 0, 0, 4, 0
		else
			return 0, 0, 2, 0
		end
	else
		ai[:result] = 'D'
		hi[:result] = 'D'
		return 1, 0, 1, 0
	end
end

def extra_bonus_points(game, hi, ai)
	return 0,0
end

def sort_table(table)
	proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }
end
