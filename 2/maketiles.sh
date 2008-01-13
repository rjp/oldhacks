# bonus tiles
for i in white red aquamarine blue pink; do
    convert -size 32x32 xc:$i -matte \( +clone -channel A -separate +channel -negate -bordercolor black -border 2 -blur 0x2 -shade 330x30 -normalize -blur 1x1 -fill $i -tint 120 \) -gravity center -compose Atop -composite $i.png
done

convert -size 32x32 xc:'#f0dc82' -matte \( +clone -channel A -separate +channel -negate -bordercolor black -border 2 -blur 0x2 -shade 330x30 -normalize -blur 1x1 -fill '#f0dc82' -tint 120 \) -gravity center -compose Atop -composite blank.png
# normal letters
for i in A1 B3 C3 D2 E1 F4 G2 H4 I1 J8 K5 L1 M3 N1 O1 P3 Q10 R1 S1 T1 U1 V4 W4 X8 Y4 Z10; do 
    letter=${i:0:1}; score=${i:1}; o=2; 
    if [ $letter = 'Q' ]; then o=0; fi; 
    for j in white blue green red purple; do
        convert blank.png -gravity Center -pointsize 22 -fill black -draw "text -1,3 '$letter'" -fill black -draw "text 0,4 '$letter'" -fill black -draw "text 1,3 '$letter'" -fill black -draw "text 0,2 '$letter'" -fill "$j" -draw "text 0,3 '$letter'" -pointsize 8 -fill black -gravity SouthEast -draw "text $o,0 '$score'" $j$letter.png
# convert -size 32x32 xc:'#F0DC82' -gravity Center -pointsize 22 -fill black -draw "text -1,3 '$letter'" -fill black -draw "text 0,4 '$letter'" -fill black -draw "text 1,3 '$letter'" -fill black -draw "text 0,2 '$letter'" -fill "$j" -draw "text 0,3 '$letter'" -pointsize 8 -fill black -gravity SouthEast -draw "text $o,0 '$score'" $j$letter.png
    done
done
