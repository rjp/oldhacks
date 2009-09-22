require 'parseprem'
require 'yaml'

$initial_points = 0
$initial_pos = 11

require ARGV[0]

ebp = proc { return 0, 0 }

begin
    ebp = Object.method(:extra_bonus_points)
rescue => e
end

pp = proc { }
begin
    pp = Object.method(:postprocess)
rescue => e
end


history_file = ARGV[1] || 'historyfile.yml'
teams = YAML.load_file(ARGV[2])

place = Hash.new { |h,k| h[k] = [] }
table = Hash.new { |h,k| h[k] = {:win=>0, :draw=>0, :lose=>0, :played=>0, :points=>$initial_points, :bonus=>0, :pos=>$initial_pos, :for=>0, :against=>0, :history=>[], :homewin=>0, :results=>[], :ppg=>[], :name => k } }

teams.each { |team| table[team][:win] = 0 }

sort_routine = proc {|t| 1000*(table[t][:points]+table[t][:bonus]) + (table[t][:for] - table[t][:against]) }

if Kernel.respond_to?('sort_table') then
	sort_routine = sort_table(table)
end

def count_results(team)
    case team[:result]
        when 'W' then team[:win] = team[:win] + 1
        when 'L' then team[:lose] = team[:lose] + 1
        when 'D' then team[:draw] = team[:draw] + 1
    end
end

def add_points(team, points, bonus)
    team[:points] = team[:points] + points
    team[:bonus] = team[:bonus] + bonus
    team[:p] = [points,bonus]
end

def count_goals(team, g_for, g_against)
    team[:for] += g_for
    team[:against] += g_against
end

input = ENV['LEAGUE'] || 'results.yaml'

plot_pos = 0
leaguepos = Hash.new {|h,k| h[k]=[]}

by_date = YAML.load_file(input)
by_date.each { |date, games|
    $stderr.puts "date=#{date}, #{games.size} games"
games.each { |game|
# Birmingham 4-1 (HT 1-0) Blackburn
    all, home, hs, as, hhs, ahs, away = game.match(%r{(.*?) (\d+)-(\d+) \(HT (\d+)-(\d+).*?\) (.+)}).to_a
    home.gsub!(' ','_')
    away.gsub!(' ','_')
    game = [ home, away, hs.to_i, as.to_i, date, hhs.to_i, ahs.to_i ]
    table[home][:played] = table[home][:played]+1
    table[away][:played] = table[away][:played]+1
    $stderr.print "h=#{home}/#{table[home][:pos]}:#{table[home][:points]} a=#{away}/#{table[away][:pos]}:#{table[away][:points]} s=#{hs}-#{as} (#{hhs}-#{ahs}) "
    
    place[home][table[home][:played]] = 'H'
    place[away][table[away][:played]] = 'A'

    hp, hb, ap, ab, hg, ag = points(game, table[home], table[away])

	unless hp.nil? then

	    if hg.nil? then hg = hs.to_i; end
	    if ag.nil? then ag = as.to_i; end
	
	    add_points(table[home], hp, hb)
	    add_points(table[away], ap, ab)
	
	    count_results(table[home])
	    count_results(table[away])
	
	    count_goals(table[home], hg, ag)
	    count_goals(table[away], ag, hg)
	
	    ehb, eab = ebp.call(game, table[home], table[away])
	    $stderr.puts [hp, hb, ap, ab, ehb, eab].join(',')
	    table[home][:bonus] = table[home][:bonus] + ehb
		table[away][:bonus] = table[away][:bonus] + eab
	end
}

    simple = []
    table.keys.sort_by {|x| sort_routine.call(x)}.reverse.each_with_index { |t,i| 
        table[t][:pos] = i+1
        simple.push "#{t} (#{table[t][:points]+table[t][:bonus]})"
        table[t][:history][table[t][:played]] = [i+1, table[t][:points], table[t][:bonus], table[t][:result], table[t][:p], place[t][table[t][:played]], table[t][:for], table[t][:against]]
        if t == 'Man_Utd' then; $stderr.puts "#{date}: Man Utd #{plot_pos} = #{i+1}"; end
        leaguepos[t][plot_pos]=i+1

    }
    $stderr.puts "#{date}/#{plot_pos}: " << simple[0..3].join(',')
    plot_pos = plot_pos + 1
}

pp.call(table,sort_routine)

if ENV['CSV'] then
	puts table.keys.sort_by{|k|table[k][:pos]}.join(',')
else
	printf "%2s %-16s %3s %4s %3s %s %3s %3s %4s %2s %2s %2s %2s\n", '#', 'Team', 'Pts', 'Bns', 'Tot', 'pos', 'gf', 'ga', 'gd', 'P', 'W', 'D', 'L'
	table.keys.sort_by{|k|table[k][:pos]}.each_with_index {|t,i|
	    printf "%2d %-16s %3d +%3d %3d %3d %3d %3d %4d %2d %2d %2d %2d %2d %2d\n", i+1, t, table[t][:points], table[t][:bonus], table[t][:points]+table[t][:bonus], table[t][:pos], table[t][:for], table[t][:against], table[t][:for]-table[t][:against], table[t][:played], table[t][:win], table[t][:draw], table[t][:lose], table[t][:homewin], table[t][:win]-table[t][:homewin]
	}
end

#p table['Man Utd'][:history]
#p table['Wigan'][:history]
#p table['Chelsea'][:history]
history = {}
table.keys.each { |k|
    history[k] = table[k][:history]
}
File.open(history_file, 'w') {|io|
    YAML.dump(history, io)
}

$stderr.puts '__DATA__'
$stderr.puts YAML.dump(leaguepos)
