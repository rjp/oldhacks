across=15
down=15
gameid=$1
letters=letters/

# yes letters/grey90.png | head -225 > newboard
sed -e "s#^#$letters#" < blankboard > newboard

# nodes='Z,1,2,3|Q,1,3,4|r,0,0,5'
echo "select nodes from game where gameid=$gameid;"
nodes=$(echo "select nodes from game where gameid=$gameid;" | sqlite3 /tmp/scrabgames.db)

for tile in $(echo $nodes | tr '|' ' '); do
	set -- $(echo $tile | tr ',' ' ')
	letter=$1
	x=$2
	y=$3
	line=$((15*x+y))
	color=white
	uc=$(echo $letter | tr a-z A-Z)
	if [ $uc != $letter ]; then color=red; fi
	echo "placing letter $letter at $x,$y (line $line)"
	(
		echo $((line+1))d
		echo ${line}a
		echo ${letters}$color$letter.png
		echo .
		echo w
		echo q
	) | ed newboard 2>/dev/null
done

montage +frame +shadow +label -tile 15x15 -geometry 32x32 @newboard board.png
convert -resize 128x128 board.png $gameid.png
