require 'yaml'

filenames = []
table = []
ARGV.each_with_index {|file, i|
	table.push Array.new(20)
	h = YAML.load_file(file)
	h.keys.each {|team|
		final = h[team].last[0]
		table[i][final-1] = team
	}
	filenames.push(File.basename(file))
}
if ENV['HTML'] then
puts '<table border=1><tr><th></th><th>' << filenames.join('</th><th>') << '</th></tr>'
(1..20).each { |i|
	puts "<tr style='r#{i}'><td>#{i}</td><td>" << [table.collect {|j| j[i-1]}].join('</td><td>') << '</td></tr>'
}
puts '</table>'
else
printf "%2s %s\n", '', [filenames.collect {|j| sprintf("%-14s",j[0..13])}].join(' ')
(1..20).each { |i|
	printf "%2d %s\n", i, [table.collect {|j| sprintf("%-14s",j[i-1])}].join(' ')
}
end
