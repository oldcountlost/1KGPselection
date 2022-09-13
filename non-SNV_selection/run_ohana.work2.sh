
wd=/work_dir/1KGPselection/non-SNV_selection
bin_size=50000000
chrs=/work_dir/1KGPselection/non-SNV_selection/chrs.txt
vcf=/work_dir/1KGPselection/SV/out.Maf1Percetn.vcf.recode.vcf
sample=/work_dir/1KGPselection/non-SNV_selection/total_noX.samplre_order
fai=/ldfssz1/ST_BIGDATA/USER/st_bigdata/Sentieon/reference_bigdatacompute/hg38_noalt_withrandom/hg38.fa.fai



perl /work_dir/1KGPselection/non-SNV_selection/generate_bed.pl  $fai $bin_size $chrs > $wd/chrs.bed.txt

cat   $wd/chrs.bed.txt  | while read line ; do
chr=$( echo $line | awk '{print $1}')
st=$( echo $line | awk '{print $2}')
ed=$( echo $line | awk '{print $3}')
out_ped="$wd/ped$chr\_$st\_$ed"
out="$wd/all$chr\_$st\_$ed"


cat > qsub$chr.$st.$ed.sh << EOF

cd $wd
vcftools --vcf $vcf --plink --chr $chr --from-bp $st --to-bp $ed --out $out_ped
perl /work_dir/1KGPselection/non-SNV_selection/filtersample.pl  $out_ped.ped  $sample   > $out_ped.ped2   && mv $out_ped.ped2  $out_ped.ped
plink  --noweb  --recode12  --geno 0.0 --maf 0.01  --tab  --file  $out_ped  --out  $out_ped.recode  && rm $out_ped.ped  $out_ped.map
convert ped2dgm   $out_ped.recode.ped   $out.g.dgm

EOF
qsub -cwd  -l vf=2g -l num_proc=1 -binding linear:1  qsub$chr.$st.$ed.sh
done

