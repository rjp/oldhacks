require 'parseprem'
require 'yaml'
require ARGV[0]


table = Hash.new { |h,k| h[k] = {:win=>0, :draw=>0, :lose=>0, :played=>0, :points=>0, :bonus=>0, :pos=>10, :for=>0, :against=>0} }

sort_routine = sort_table(table)

def home_win(table, home, away, hs, as)
        hp, hb, ap, ab = points_for_home_win(hs, as, table[home][:pos], table[away][:pos])
        table[home][:points] = table[home][:points] + hp
        table[home][:bonus] = table[home][:bonus] + hb
        table[away][:points] = table[away][:points] + ap
        table[away][:bonus] = table[away][:bonus] + ab
	table[home][:win] = table[home][:win] + 1
	table[away][:lose] = table[away][:lose] + 1
end

def away_win(table, home, away, hs, as)
        hp, hb, ap, ab = points_for_home_loss(hs, as, table[home][:pos], table[away][:pos])
        table[home][:points] = table[home][:points] + hp
        table[home][:bonus] = table[home][:bonus] + hb
        table[away][:points] = table[away][:points] + ap
        table[away][:bonus] = table[away][:bonus] + ab
	table[away][:win] = table[away][:win] + 1
	table[home][:lose] = table[home][:lose] + 1
end

def draw(table, home, away, hs, as)
        hp, hb, ap, ab = points_for_draw(hs, as, table[home][:pos], table[away][:pos])
        table[home][:points] = table[home][:points] + hp
        table[home][:bonus] = table[home][:bonus] + hb
        table[away][:points] = table[away][:points] + ap
        table[away][:bonus] = table[away][:bonus] + ab
	table[away][:draw] = table[away][:draw] + 1
	table[home][:draw] = table[home][:draw] + 1
end

by_date = YAML.load_file('results.yaml')
by_date.each { |date, games|
games.each { |game|
# Birmingham 4-1 (HT 1-0) Blackburn
    all, home, hs, as, away = game.match(%r{(.*?) (\d+)-(\d+) \(.*?\) (.+)}).to_a
    hs = hs.to_i
    as = as.to_i
    table[home][:played] = table[home][:played]+1
    table[away][:played] = table[away][:played]+1
    puts "h=#{home} a=#{away} s=#{hs}-#{as}"
    if hs > as then
    	home_win(table, home, away, hs, as)
    elsif as > hs then
    	away_win(table, home, away, hs, as)
    else
    	draw(table, home, away, hs, as)
    end

    table[home][:for] += hs
    table[home][:against] += as
    table[away][:for] += as
    table[away][:against] += hs

    hb, ab = extra_bonus_points(hs, as, 0, 0)
    table[home][:bonus] = table[home][:bonus] + hb
    table[away][:bonus] = table[away][:bonus] + ab

}
    simple = []
    table.keys.sort_by {|x| sort_routine.call(x)}.reverse.each_with_index {|t,i| table[t][:pos] = i+1; simple.push "#{t} (#{table[t][:points]+table[t][:bonus]})" }
    puts "#{date}: " << simple[0..3].join(',')
}
printf "%2s %-16s %3s %4s %3s %s %3s %3s %4s %2s %2s %2s %2s\n", '#', 'Team', 'Pts', 'Bns', 'Tot', 'pos', 'gf', 'ga', 'gd', 'P', 'W', 'D', 'L'
table.keys.sort_by{|k|table[k][:pos]}.each_with_index {|t,i|
    printf "%2d %-16s %3d +%3d %3d %3d %3d %3d %4d %2d %2d %2d %2d\n", i+1, t, table[t][:points], table[t][:bonus], table[t][:points]+table[t][:bonus], table[t][:pos], table[t][:for], table[t][:against], table[t][:for]-table[t][:against], table[t][:played], table[t][:win], table[t][:draw], table[t][:lose]
}
