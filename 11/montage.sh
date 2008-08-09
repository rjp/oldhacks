for i in svg/*; do convert $i ppm:- | pnmcrop | pnmpad -l 2 -r 2 -white | pnmtopng > png/$(basename $i).png; done
montage -tile x1 -geometry x201 png/*spread.svg.png test.png
