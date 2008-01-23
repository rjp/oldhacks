# bonus tiles
for i in white grey90 red skyblue blue pink; do
    convert -size 30x30 xc:$i -bordercolor black -border 1 $i.png
done

convert -size 30x30 xc:'#f0dc82' -bordercolor black -border 1 blank.png
# normal letters
for i in A1 B3 C3 D2 E1 F4 G2 H4 I1 J8 K5 L1 M3 N1 O1 P3 Q10 R1 S1 T1 U1 V4 W4 X8 Y4 Z10; do 
    letter=${i:0:1}; score=${i:1}; o=2; 
    if [ $letter = 'Q' ]; then o=0; fi; 
    for j in white blue green red purple; do
        convert blank.png -gravity Center -pointsize 28 -fill "$j" -draw "text -1,3 '$letter'" -fill "$j" -draw "text 0,4 '$letter'" -fill "$j" -draw "text 1,3 '$letter'" -fill "$j" -draw "text 0,2 '$letter'" -fill black  -draw "text 0,3 '$letter'" $j$letter.png
    done
done
