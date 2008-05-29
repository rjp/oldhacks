require 'yaml'
require 'erb'

desc = YAML.load_file('rules.yaml')
size = nil
rules = []
filenames = []
table = []
ARGV.each_with_index {|file, i|
	table.push Array.new(20)
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
		table[i][final-1] = [team, points+bonus]
	}
	filenames.push(File.basename(file))
        rules.push(File.basename(file))
}

relegated = 3
puts "calculated size is #{size}"
if ENV['HTML'] then
    template = File.read('html.erb')
    tt = ERB.new(template, nil, '%')
    puts tt.result
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
