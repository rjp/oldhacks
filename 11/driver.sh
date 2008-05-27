prefix=${PREFIX:-games}

mkdir -p history/$prefix svg/$prefix png/$prefix

for i in rules/*.rb; do
	j=${i%.*}
	j=$(basename $j)
	echo XXX ruby test.rb $i history/$prefix/$j
	ruby test.rb $i history/$prefix/$j
	for k in graphs/*.rb; do
		l=${k%.*}
		l=$(basename $l)
		ruby $k history/$prefix/$j > svg/$prefix/${j}_$l.svg
	done
done

