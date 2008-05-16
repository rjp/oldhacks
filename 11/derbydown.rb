table = {}

def show(table)
    temp = []
    a=%w{Ps Team P W D L GF GA GD P}
    printf "%2s %-20s %2s %2s %2s %2s %2s %2s %4s %2s\n", *a
    new = table.keys.sort_by {|i| 1000*table[i][:points] + table[i][:gf] - table[i][:ga]}.reverse
    new.each_with_index {|team,i|
        r = table[team]
        r[:pos] = i+1
        printf "%2s %-20s %2d %2d %2d %2d %2d %2d %4d %2d\n", 
               r[:pos], team, r[:played], r[:won], r[:drawn], r[:lost], r[:gf], r[:ga], r[:gf]-r[:ga], r[:points]
	temp[i+1] = team
    }
    if table['Derby'][:pos].to_i != 20 then
    	puts "DERBY ARE NOT BOTTOM"
    end
    if table[temp[19]][:points] > table['Derby'][:points] + 3*(38-table['Derby'][:played]) then
    	puts "DERBY ARE RELEGATED"
    end
end

def loss_for(x, table)
	table[x][:points] = table[x][:points]  + 3
	table[x][:won] = table[x][:won]  + 1
	table[x][:played] = table[x][:played]  + 1
	table[x][:gf] = table[x][:gf]  + 1
end

def win_for(x, table)
	table[x][:lost] = table[x][:lost]  + 1
	table[x][:played] = table[x][:played]  + 1
	table[x][:ga] = table[x][:ga]  + 1
end

def draw_for(x, y, table)
	table[x][:points] = table[x][:points]  + 1
	table[x][:drawn] = table[x][:drawn]  + 1
	table[x][:played] = table[x][:played]  + 1
	table[y][:points] = table[y][:points]  + 1
	table[y][:drawn] = table[y][:drawn]  + 1
	table[y][:played] = table[y][:played]  + 1
end

File.open("table") { |f|
    f.readlines.each { |l|
        pos, team, played, won, drawn, lost, goals_for, goals_against, *junk = l.gsub(/\t+/, ' ').split ' '
        points = junk[-1]
        table[team] = { :pos => pos.to_i, :played => played.to_i, :won => won.to_i, :drawn => drawn.to_i, :lost => lost.to_i, :gf => goals_for.to_i, :ga => goals_against.to_i, :points => points.to_i }
    }
}

max_points = table['Derby'][:points] + 3*(38-table['Derby'][:played])
max_points = 33

File.open("fixtures") { |f|
    f.readlines.each { |l|
        if l =~ /(.*?) v (.+)/ then
            t_away = $2
            home = $1.gsub(/ /, '_') # this will blat $2
            away = t_away.gsub(/ /, '_')
            puts "#{home} (#{table[home][:pos]}, #{table[home][:points]}) v #{away} (#{table[away][:pos]}, #{table[away][:points]})   D(#{table['Derby'][:pos]}, #{table['Derby'][:points]})"
            if home == 'Derby' then
                win_for home, table
                loss_for away, table
                puts "Derby win at home"
            elsif away == 'Derby'
                loss_for home, table
                win_for away, table
                puts "Derby win away"
            else
                printf "h%d-d%d cf a%d-d%d\n", table[home][:points],table['Derby'][:points],table[away][:points],table['Derby'][:points] 
                if table[home][:points]-table['Derby'][:points] <
                    table[away][:points]-table['Derby'][:points] then
                        puts "#{home} (non-reachable) beat #{away} (reachable)"
                        win_for away, table
                        loss_for home, table
                else
                        puts "#{home} (non-reachable) beat #{away} (reachable)"
                        win_for home, table
                        loss_for away, table
                end
            end
        end
        if l =~ /2008/ then
            show table
        end
    }
}
show table
