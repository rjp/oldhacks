for i in svg/$PREFIX/*; do convert $i ppm:- | pnmcrop | pnmpad -t 2 -b 2 -l 2 -r 2 -white | pnmtopng > png/$PREFIX/$(basename $i).png; done
montage -tile x1 -geometry x201 png/$PREFIX/*spread.svg.png png/$PREFIX/test.png
montage -tile x1 -geometry x201 png/$PREFIX/*spread_zero.svg.png png/$PREFIX/test2.png
