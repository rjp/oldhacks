def desc
	"bonus point for away win"
end

def points(game, hi, ai)
	home, away, hs, as, date, hhs, ahs = game

	if hs > as then
    	return 3, 0, 0, 0
	elsif as > hs then
		return 0, 0, 3, 1
	else
		return 1, 0, 1, 0
	end
end
