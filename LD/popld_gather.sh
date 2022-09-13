wd=/work_dir/1KGPselection/LD
poplddecay=/work_dir/software/PopLDdecay/bin/PopLDdecay
vcf=/hwfssz1/pub/database/ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/HGSVC2/release/v1.0/PanGenie_results/pangenie_merged_bi_all.vcf.gz
sample_list=/work_dir/1KGPselection/non-SNV_selection/total_noX.samplre_order.meta
contig_list=/work_dir/1KGPselection/LD/primary_contigs.list
Plot_OnePop=/work_dir/software/PopLDdecay/bin/Plot_OnePop.pl
Plot_MultiPop=/work_dir/software/PopLDdecay/bin/Plot_MultiPop.pl

cd $wd


##  vcftools   --chr $chr   --gzvcf  ./filter.vcf.gz  --recode  --recode-INFO-all  -c  |  bgzip -c >  ./filter.$chr.vcf.gz

#awk '{print $4}' $sample_list | sort -u | while read subpop;do

#ls $wd/vcf.$subpop.*.stats.stat.gz   > $subpop.chr.list

#perl $Plot_OnePop -inList  $subpop.chr.list   -output  $wd/$subpop.cat

#echo "${wd}/${subpop}.cat.bin.gz       ${subpop}" >> $wd/multi.list

#perl $Plot_MultiPop  -inList $wd/multi.list2  -output  $wd/Final_mix

#done

continent=/work_dir/1KGPselection/LD/sample_order.contcontinent.meta

awk '{print $4}' $continent | sort -u | while read subpop;do

ls $wd/vcf.$subpop.*.stats.stat.gz   > $subpop.chr.list

perl $Plot_OnePop -inList  $subpop.chr.list   -output  $wd/$subpop.cat

echo "${wd}/${subpop}.cat.bin.gz        ${subpop}" >> $wd/multi.continent.list

done

perl $Plot_MultiPop  -inList $wd/multi.continent.list  -output  $wd/continent.Final_mix

