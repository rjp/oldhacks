require 'parseprem'

table = Hash.new { |h,k| h[k] = {:win=>0, :draw=>0, :lose=>0, :played=>0, :points=>0} }

games = parse_file('results.html')
games.reverse.each { |game|
# Birmingham 4-1 (HT 1-0) Blackburn
    all, home, hs, as, away = game.match(%r{(.*?) (\d+)-(\d+) \(.*?\) (.+)}).to_a
    if hs > as then
        table[home][:points] = table[home][:points] + 3
    elsif as > hs then
        table[away][:points] = table[away][:points] + 3
    else
        table[home][:points] = table[home][:points] + 1
        table[away][:points] = table[away][:points] + 1
    end
}
p table
