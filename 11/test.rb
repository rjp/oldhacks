require 'parseprem'
require ARGV[0]

table = Hash.new { |h,k| h[k] = {:win=>0, :draw=>0, :lose=>0, :played=>0, :points=>0, :bonus=>0} }

games = parse_file('results.html')
games.reverse.each { |game|
# Birmingham 4-1 (HT 1-0) Blackburn
    all, home, hs, as, away = game.match(%r{(.*?) (\d+)-(\d+) \(.*?\) (.+)}).to_a
    if hs > as then
        hp, hb, ap, ab = points_for_home_win(hs, as, 0, 0)
        table[home][:points] = table[home][:points] + hp
        table[home][:bonus] = table[home][:bonus] + hb
        table[away][:points] = table[away][:points] + ap
        table[away][:bonus] = table[away][:bonus] + ab
    elsif as > hs then
        hp, hb, ap, ab = points_for_home_loss(hs, as, 0, 0)
        table[home][:points] = table[home][:points] + hp
        table[home][:bonus] = table[home][:bonus] + hb
        table[away][:points] = table[away][:points] + ap
        table[away][:bonus] = table[away][:bonus] + ab
    else
        hp, hb, ap, ab = points_for_draw(hs, as, 0, 0)
        table[home][:points] = table[home][:points] + hp
        table[home][:bonus] = table[home][:bonus] + hb
        table[away][:points] = table[away][:points] + ap
        table[away][:bonus] = table[away][:bonus] + ab
    end

    hb, ab = extra_bonus_points(hs, as, 0, 0)
    table[home][:bonus] = table[home][:bonus] + hb
    table[away][:bonus] = table[away][:bonus] + ab
}
printf "%2s %-20s %3s %4s %3s\n", '#', 'Team', 'Pts', 'Bns', 'Tot'
table.keys.sort_by {|h| table[h][:points]+table[h][:bonus] }.reverse.each_with_index {|t,i|
    printf "%2d %-20s %3d +%3d %3d\n", i+1, t, table[t][:points], table[t][:bonus], table[t][:points]+table[t][:bonus]
}
