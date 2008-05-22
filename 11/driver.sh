for i in rules/*.rb; do
	j=${i%.*}
	j=$(basename $j)
	echo XXX ruby test.rb $i history/$j
	ruby test.rb $i history/$j
	for k in graphs/*.rb; do
		l=${k%.*}
		l=$(basename $l)
		ruby $k history/$j > svg/${j}_$l.svg
	done
done

