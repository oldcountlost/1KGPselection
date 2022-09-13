wd=$(pwd)
k=10


for c in {1..10}; do


#### each component
echo " " | awk '{print "Chr\tSNP\tGen.Dis\tPosition"}' > step4.all.sel.$k.$c.map
ls $wd/sel$k*lle-ratios.txt  |  head -1 | xargs head -1 > step4.all.sel.$k.$c.lle-ratios.txt

cat   $wd/chrs.bed.txt  | while read line ; do

chr=$( echo $line | awk '{print $1}')
st=$( echo $line | awk '{print $2}')
ed=$( echo $line | awk '{print $3}')
out_sel=$wd/sel$k\_$c\_$chr\_$st\_$ed
out=$wd/all$chr\_$st\_$ed

cat $wd/ped$chr\_$st\_$ed.recode.map  >> step4.all.sel.$k.$c.map
cat $out_sel.lle-ratios.txt | sed '1d' >>  step4.all.sel.$k.$c.lle-ratios.txt

done

cut -f2 step4.all.sel.$k.$c.lle-ratios.txt | awk '{if(NR>1){printf("%f\n",$0)}else{print $0}}' >  step4.all.sel.$k.$c.lle-ratios.txt.col2
paste step4.all.sel.$k.$c.map   step4.all.sel.$k.$c.lle-ratios.txt.col2 | cut -f1,2,4,5 >  step4.all.sel.$k.$c.map.withlle

done





####  global
echo " " | awk '{print "Chr\tSNP\tGen.Dis\tPosition"}' > step4.all.sel.$k.map
ls $wd/sel$k*lle-ratios.txt  |  head -1 | xargs head -1 > step4.all.sel.$k.lle-ratios.txt

cat   $wd/chrs.bed.txt  | while read line ; do

chr=$( echo $line | awk '{print $1}')
st=$( echo $line | awk '{print $2}')
ed=$( echo $line | awk '{print $3}')
out_sel=$wd/sel$k\_$chr\_$st\_$ed
out=$wd/all$chr\_$st\_$ed

cat $wd/ped$chr\_$st\_$ed.recode.map  >> step4.all.sel.$k.map
cat $out_sel.lle-ratios.txt | sed '1d' >>  step4.all.sel.$k.lle-ratios.txt

done

cut -f2 step4.all.sel.$k.lle-ratios.txt | awk '{if(NR>1){printf("%f\n",$0)}else{print $0}}' >  step4.all.sel.$k.lle-ratios.txt.col2
paste step4.all.sel.$k.map   step4.all.sel.$k.lle-ratios.txt.col2 | cut -f1,2,4,5 >  step4.all.sel.$k.map.withlle
