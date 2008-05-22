def desc
	"bonus point for beating a higher opponent"
end

def points(game, hi, ai)
	home, away, hs, as, date, hhs, ahs = game

	x, y = 0, 0

	if hs > as then
		p, q = 3, 0
		if hi[:pos] > ai[:pos] then x = 1; end
	elsif as > hs then
		p, q = 0, 3
		if ai[:pos] > hi[:pos] then y = 1; end
	else
		p, q = 1, 1
	end

	return p, x, q, y
end
