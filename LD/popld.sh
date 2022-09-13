wd=/work_dir/1KGPselection/LD
poplddecay=/work_dir/software/PopLDdecay/bin/PopLDdecay
vcf=/hwfssz1/pub/database/ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/HGSVC2/release/v1.0/PanGenie_results/pangenie_merged_bi_all.vcf.gz
sample_list=/work_dir/1KGPselection/non-SNV_selection/total_noX.samplre_order.meta
continent_list=/work_dir/1KGPselection/non-SNV_selection/total_noX.samplre_order.meta
contig_list=/work_dir/1KGPselection/LD/primary_contigs.list

cd $wd

perl /jdfssz1/ST_HEALTH/P21Z10200N0047/zengyan/Guizhou/filter_vcf.pl   /work_dir/1KGPselection/LD/out.Maf1Percetn.vcf.gz   |   bgzip -c  >   ./filter.vcf.gz
awk '{print $1}' $sample_list  >  ./sampleIDS


cat  $contig_list | while read chr ; do

vcftools   --chr $chr   --gzvcf  ./filter.vcf.gz  --recode  --recode-INFO-all  -c  |  bgzip -c >  ./filter.$chr.vcf.gz

awk '{print $4}' $sample_list | sort -u | while read subpop;do
cat $sample_list  | grep "$subpop" | awk '{print $1}' > $subpop.samples


cat >  $wd/$subpop.$chr.sh <<EOF

cd  $wd


  $poplddecay  -InVCF  ./filter.$chr.vcf.gz   -OutStat  $wd/vcf.$subpop.$chr.stats  -SubPop  $subpop.samples   -MAF 0.01

EOF

done
done

############################


cat  $contig_list | while read chr ; do
cat >  $wd/allpop.$chr.sh <<EOF

cd  $wd


  $poplddecay  -InVCF  ./filter.$chr.vcf.gz   -OutStat  $wd/vcf.$chr.stats  -SubPop  ./sampleIDS   -MAF 0.01

EOF
done



continent_meta=/work_dir/1KGPselection/LD/sample_order.contcontinent.meta
cat  $contig_list | while read chr ; do


cat >  $wd/filter.$chr.sh <<EOF
cd $wd
  vcftools   --chr $chr   --gzvcf  ./filter.vcf.gz  --recode  --recode-INFO-all  -c  |  bgzip -c >  ./filter.$chr.vcf.gz
EOF
#qsub -cwd -q st.q -P P18Z10200N0124 -l vf=2g -l num_proc=1 -binding linear:1   $wd/filter.$chr.sh

cat  $continent_meta  | awk '{print $4}' | sort -u  |  while read  continent; do
cat $continent_meta  | grep "$continent" | awk '{print $1}' > $continent.samples
cat >  $wd/$continent.$chr.sh <<EOF

cd  $wd

cd $wd
  $poplddecay  -InVCF  ./filter.$chr.vcf.gz   -OutStat  $wd/vcf.$continent.$chr.stats  -SubPop  $continent.samples   -MAF 0.01

EOF

 qsub -cwd -q st.q -P P18Z10200N0124 -l vf=2g -l num_proc=1 -binding linear:1   $wd/$continent.$chr.sh
done

done;
