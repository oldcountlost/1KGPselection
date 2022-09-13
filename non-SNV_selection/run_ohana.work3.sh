
wd=/work_dir/1KGPselection/non-SNV_selection

vcf=/work_dir/1KGPselection/SV/out.Maf1Percetn.vcf.recode.vcf
fai=/ldfssz1/ST_BIGDATA/USER/st_bigdata/Sentieon/reference_bigdatacompute/hg38_noalt_withrandom/hg38.fa.fai


k=10  ## best ancestral component number

One_percent_Q=$wd/noX.infer$k.1percent_Q.matrix
One_percent_C=$wd/noX.infer$k.1percent_C.matrix

cat   $wd/chrs.bed.txt  | while read line ; do
chr=$( echo $line | awk '{print $1}')
st=$( echo $line | awk '{print $2}')
ed=$( echo $line | awk '{print $3}')


#########################################
#### global test
out_sel="$wd/sel${k}_${chr}_${st}_$ed"
out="$wd/all${chr}_${st}_${ed}"

cat > qsub$k.$chr.$st.$ed.sh << EOF
cd $wd
qpas  $out.g.dgm -e 0.0001  -qi  $One_percent_Q -fo  $out_sel.f.matrix  -fq
selscan $out.g.dgm  $out_sel.f.matrix  $One_percent_C   > $out_sel.lle-ratios.txt  ##  default 10 times the C matrix
EOF
sleep 0.2s
 qsub -cwd -q st.q -P P18Z10200N0124 -l vf=2g -l num_proc=1 -binding linear:1  qsub$k.$chr.$st.$ed.sh


#########################################
#### each component test
for c in {1..10}; do
One_percent_C2=$wd/noX.infer$k.1percent_C$c.matrix

out_sel="$wd/sel${k}_${c}_${chr}_${st}_${ed}"
out="$wd/all${chr}_${st}_${ed}"

cat > qsub$k.$c.$chr.$st.$ed.sh << EOF
cd $wd
qpas  $out.g.dgm -e 0.0001  -qi  $One_percent_Q -fo  $out_sel.f.matrix  -fq
selscan $out.g.dgm  $out_sel.f.matrix  $One_percent_C   -cs $One_percent_C2   > $out_sel.lle-ratios.txt

EOF
#sleep 0.2s
qsub -cwd  -l vf=2g -l num_proc=1 -binding linear:1  qsub$k.$c.$chr.$st.$ed.sh
done

done





#########################################
#### component complex tests
cat   $wd/chrs.bed.txt  | while read line ; do
chr=$( echo $line | awk '{print $1}')
st=$( echo $line | awk '{print $2}')
ed=$( echo $line | awk '{print $3}')

  ls *.inner_node_test  |   while read One_percent_C2; do
# ls noX.infer10.1percent_C1_5_9.matrix.inner_node_test  |   while read One_percent_C2; do

out_sel="$wd/sel$k\_$One_percent_C2\_$chr\_$st\_$ed"
out="$wd/all$chr\_$st\_$ed"

cat > qsub$k.$One_percent_C2.$chr.$st.$ed.sh << EOF
cd $wd
#qpas  $out.g.dgm -e 0.0001  -qi  $One_percent_Q -fo  $out_sel.f.matrix  -fq
selscan $out.g.dgm  $out_sel.f.matrix  $One_percent_C   -cs $One_percent_C2   > $out_sel.lle-ratios.txt

EOF
#sleep 0.2s
qsub -cwd -q st.q -P P18Z10200N0124 -l vf=2g -l num_proc=1 -binding linear:1  qsub$k.$One_percent_C2.$chr.$st.$ed.sh
done

done


