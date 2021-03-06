require 'parseprem'

=begin rdoc
Convert a BBC-style results list into a YAML file suitable for loading
=end

input = ARGV[0]
output = ARGV[1] || 'results.yaml'

table = Hash.new { 
    |h,k| h[k] = {
        :win=>0, :draw=>0, :lose=>0, :played=>0, :points=>0, :bonus=>0, :final=>0
    } 
}

games = parse_file(input)
dates = games.keys.sort_by{|h| Time.parse(h).to_i}
by_date = []
dates.each { |d| by_date.push [d, games[d]] }
open(output, 'w') {|f|
    YAML.dump(by_date, f)
}
