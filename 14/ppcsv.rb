require 'yaml'

counts = Hash.new{|h,k| h[k]=0}

events = 0
$stdin.readlines.each { |line|
	events = events + 1
	teams = line.chomp.split(',')
	teams.each_with_index {|name,pos|
		counts[name] = counts[name] + pos + 1
	}
}

output = {}
counts.keys.sort_by {|n| counts[n]}.each_with_index { |name,f|
	pos = counts[name].to_f/events
	printf "%-16s %.2f\n", name, pos
	output[name] = [nil,[f+1,pos,0,'W',0,0]]
}
$stderr.puts output.to_yaml
