def desc
    "normal football rules, away goals count double"
end

def points(game, hi, ai)
    home, away, hs, as, date, hhs, ahs = game

    if hs > as*2 then
        hi[:result] = 'W'
        ai[:result] = 'L'
        hi[:homewin] = hi[:homewin] + 1
        return 3, 0, 0, 0, hs, as*2
    elsif as*2 > hs then
        ai[:result] = 'W'
        hi[:result] = 'L'
        return 0, 0, 3, 0, hs, as*2
    else
        ai[:result] = 'D'
        hi[:result] = 'D'
        return 1, 0, 1, 0, hs, as*2
    end
end
