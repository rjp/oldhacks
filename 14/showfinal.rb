require 'yaml'
require 'erb'
require 'digest/md5'

desc = YAML.load_file('rules.yaml')
teams = Hash.new {|k,v| k[v]={:totpos=>0,:totcomp=>0,:bestpos=>100,:worstpos=>0,:real=>0}}
by_team = Array.new(25) {Hash.new}
size = nil
rules = []
filenames = []
table = []
ARGV.sort {|a,b| a=~%r{/football$} ? -1 : (b=~%r{/football$} ? 1 : a<=>b) }.each_with_index { |file, i|
	table.push Array.new(25)
	h = YAML.load_file(file)
	as = h.keys.size

	if size.nil? then
		size = as
	else
		if size != as then
			$stderr.puts "#{file} has odd size, #{size}!=#{h.keys.size}"
			exit
		end
	end

	h.keys.each {|team|
		final, points, bonus = h[team].last[0..2]
        colour = Digest::MD5.hexdigest(team.downcase.split('').sort.join(''))[-6..-1]
        short = team.gsub(/[aeiou]/,'').upcase.gsub(/[^A-Z]/,'').gsub(/(.)\1\1(.)/,'\1\1\2')[0..2]
		table[i][final-1] = [team, points+bonus, h[team].size, short, colour]
        by_team[i][team] = final
        if team.nil? then puts "team=nil"; exit; end

        if (not file =~ /knock|football/) then
	        teams[team][:totpos] = teams[team][:totpos] + final
	        teams[team][:totcomp] = teams[team][:totcomp] + 1
	        if final < teams[team][:bestpos] then
	            teams[team][:bestpos] = final
	        end
	        if final > teams[team][:worstpos] then
	            teams[team][:worstpos] = final
	        end
            if i > 0 then # we know the real league position
                teams[team][:real] = by_team[0][team]
            end
        end     
	}
	filenames.push(File.basename(file))
        rules.push(File.basename(file))
}

relegated = 3
# puts "calculated size is #{size}"
if ENV['HTML'] then
    template = File.read('html.erb')
    tt = ERB.new(template, nil, '%')
    puts tt.result
    width = ARGV.size * 40 + 40
    height = 24*40+40 
    svg = File.read('block.erb')
    tt_svg = ERB.new(svg, nil, '%')
    $stderr.puts tt_svg.result
elsif 1==2 then
puts '<table border=1><tr><th></th><th>' << filenames.join('</th><th>') << '</th></tr>'
(1..size).each { |i|
	puts "<tr class='r#{i}'><td>#{i}</td><td>" << [table.collect {|j| j[i-1]}].join('</td><td>') << '</td></tr>'
}
puts '</table>'
else
printf "%2s %s\n", '', [filenames.collect {|j| sprintf("%-16s",j[0..13])}].join(',')
(1..size).each { |i|
	p [table.collect {|j| sprintf("%-16s",j[i-1])}.join(' ')]
	printf "%2d %s\n", i, [table.collect {|j| sprintf("%-16s",j[i-1])}].join(',')
}
end
