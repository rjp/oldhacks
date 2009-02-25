prefix=${PREFIX:-games}

mkdir -p history/$prefix svg/$prefix png/$prefix weekly/$prefix

for i in rules/*.rb; do
	j=${i%.*}
	j=$(basename $j)
	echo XXX ruby test.rb $i history/$prefix/$j
	ruby test.rb $i history/$prefix/$j data/${prefix}_teams.yaml 2> weekly/$prefix/$j > weekly/$prefix/$j.tb
	ls graphs/*.rb | grep -v color | while read k; do
		l=${k%.*}
		l=$(basename $l)
		ruby $k history/$prefix/$j > svg/$prefix/${j}_$l.svg
        sed -e '1,/^__DATA__/d' weekly/$prefix/$j | ruby plotpos.rb > svg/$prefix/${j}_pos.svg
	done
    if [ "$j" = "football" ]; then
	    for k in graphs/color*.rb; do
			l=${k%.*}
			l=$(basename $l)
			ruby $k history/$prefix/$j > svg/$prefix/${j}_$l.svg
        sed -e '1,/^__DATA__/d' weekly/$prefix/$j | ruby plotpos.rb > svg/$prefix/${j}_pos.svg
		done
    fi
done

