# bonus tiles
for i in white red aquamarine blue pink; do convert -size 32x32 xc:$i $i.png; done

# normal letters
for i in A1 B3 C3 D2 E1 F4 G2 H4 I1 J8 K5 L1 M3 N1 O1 P3 Q10 R1 S1 T1 U1 V4 W4 X8 Y4 Z10; do 
    letter=${i:0:1}; score=${i:1}; o=2; 
    if [ $letter = 'Q' ]; then o=0; fi; 
    for j in black blue green red purple; do
        convert -size 32x32 xc:'#F0DC82' -gravity Center -pointsize 20 -fill "$j" -draw "text 0,3 '$letter'" -pointsize 8 -gravity SouthEast -draw "text $o,0 '$score'" $j$letter.png
    done
done
