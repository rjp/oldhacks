def desc
    "4pt for win, 2pt for draw, +1 for >4 goals, +1 for being within 1"
end

def points(game, hi, ai)
	home, away, hs, as, date, hhs, ahs = game

	p, q = 0, 0
	if hs > as then
   		if as+1 >= hs then q = 1; end
		return 4, 0, 0, q
	elsif as > hs then
   		if hs+1 >= as then p = 1; end
		return 0, p, 4, 0
	else
		return 2, 0, 2, 0
	end
end

def extra_bonus_points(game, hi, ai)
	home, away, hs, as, date, hhs, ahs = game
	
    hb, ab = 0, 0
    if hs >= 4 then hb = 1; end
    if as >= 4 then ab = 1; end
    return hb, ab
end
