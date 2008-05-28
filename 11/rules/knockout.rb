require 'yaml'

def desc
	"knockout competition"
end

$pool = {}
$latergames = Hash.new { |h,k| h[k]=[] }
list = []

t = YAML.load_file('history/0607/football') # league positions
now = YAML.load_file('0708.yaml')
now.each_with_index {|k,i|
	list.push k[1].collect { |q| q.match(/(^.*?) \d.*?\) (.*)/)[1,2] }.flatten
}
prev = t.keys.sort_by {|k| t[k].last[0]}[0..16]
newteams = list.flatten.uniq - prev
prev.push newteams.sort

prev.flatten.each_with_index {|n,i|
	$pool[n] = i%5
}


def points(game, hi, ai)
    home, away, hs, as, date, hhs, ahs = game
	if $pool[home] != $pool[away] then
		key = [home,away].sort.join(':')
		$latergames[key].push game
		return nil
	end

    if hs > as then
        hi[:result] = 'W'
        ai[:result] = 'L'
        return 3,0,0,0
    elsif as > hs then
        ai[:result] = 'W'
        hi[:result] = 'L'
        return 0,0,3,0
    else
        ai[:result] = 'D'
        hi[:result] = 'D'
        return 1,0,1,0
    end
end

def postprocess(table, sort_routine)
	p $latergames
	pools = Array.new(5) {[]}
    table.keys.sort_by {|x| sort_routine.call(x)}.reverse.each_with_index { |t,i| 
		pools[$pool[t]].push t # table[t]
	}
	p pools
end
