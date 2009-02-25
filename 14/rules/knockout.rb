require 'yaml'

def desc
	"knockout competition"
end

$pool = {}
$latergames = Hash.new { |h,k| h[k]=[] }
list = []

t = YAML.load_file('history/0708/football') # league positions
now = YAML.load_file('0809.yaml')
now.each_with_index {|k,i|
	list.push k[1].collect { |q| q.match(/(^.*?) \d.*?\) (.*)/)[1,2] }.flatten
}
prev = t.keys.sort_by {|k| t[k].last[0]}[0..16]
newteams = list.flatten.uniq - prev
p newteams
prev.push newteams.sort

prev.flatten.map{|i|i.gsub!(' ','_')}each_with_index {|n,i|
	$pool[n] = i%4
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

def quickmatch(h, a)
	key = [h,a].sort.join(':')
	sc = Hash.new { |i,k| i[k] = {:g=>0,:a=>0} }
	$latergames[key].each { |g|
    		home, away, hs, as, date, hhs, ahs = g
		sc[home][:g] = sc[home][:g] + hs
		sc[away][:g] = sc[away][:g] + as
		sc[away][:a] = sc[away][:a] + as
	}
	puts "#{h} #{sc[h][:g]}-#{sc[a][:g]} (A:#{sc[h][:a]}-#{sc[a][:a]}) #{a}"
	if sc[h][:g] > sc[a][:g] then
		return 1, 2
	elsif sc[a][:g] > sc[h][:g] then
		return 2, 1
	else
		if sc[h][:a] > sc[a][:a] then
			return 1, 2
		else
			return 2, 1
		end
	end
	puts "can't get here"
end


def postprocess(table, sort_routine)
	pools = Array.new(4) {[]}
    table.keys.sort_by {|x| sort_routine.call(x)}.reverse.each_with_index { |t,i| 
        p $pool[t]
		pools[$pool[t]].push t # table[t]
	}
	p pools
	(0..4).each { |i|
		a,b,c,d = pools[0][i], pools[1][i], pools[2][i], pools[3][i]
		pa, pd = quickmatch(a,d)
		pb, pc = quickmatch(b,c)
	
		sf1 = pa < pd ? a : d
		sf2 = pb < pc ? b : c
		sf3 = pa < pd ? d : a
		sf4 = pb < pc ? c : b

		f,s = quickmatch(sf1, sf2)
		(w,l) = f<s ? [sf1,sf2] : [sf2,sf1]

		tp,fp = quickmatch(sf3,sf4)
		puts "#{sf3} #{tp}-#{fp} #{sf4}"
		(tw,tl) = tp<fp ? [sf3,sf4] : [sf4,sf3]

		puts "results: 1: #{w} 2: #{l} 3: #{tw} 4: #{tl}"
		table[w][:pos] = 1+i*4
		table[l][:pos] = 2+i*4
		table[tw][:pos] = 3+i*4
		table[tl][:pos] = 4+i*4
	}
end
