cd /work_dir/1KGPselection/SV


vcf=./ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/HGSVC2/release/v1.0/PanGenie_results/pangenie_merged_bi_nosnvs.vcf.gz

vcftools  --maf  0.01  --gzvcf  $vcf --recode  --recode-INFO-all  --out  /work_dir/1KGPselection/SV/out.Maf1Percetn.vcf




 perl filter_len.pl  out.Maf1Percetn.vcf.recode.vcf   50  >   out.Maf1Percetn.vcf.recode.length50.vcf


popdir=/work_dir/1KGPselection/non-SNV_selection


ls $popdir/*top  |  while read top_lle; do
perl filter.pl  out.Maf1Percetn.vcf.recode.vcf.gz   $top_lle    >    $top_lle.vcf

perl pop_freq.pl   $top_lle.vcf  /work_dir/1KGPselection/non-SNV_selection/total_noX.samplre_order.meta  4  >  $top_lle.vcf.freq


AnnotSV  -SVinputFile  $top_lle.vcf  \
  -outputFile  $top_lle.vcf.annot  \
  -SVminSize 1

cut  -f 1-6,8-13,3217-3400   $top_lle.vcf.annot.tsv >  $top_lle.vcf.annot.tsv.sites

perl combine.pl  $top_lle.vcf.annot.tsv.sites   $top_lle.vcf.freq    $top_lle   >  $top_lle.tab



head -1  $top_lle.tab  >  $top_lle.tab.head
line_n=$( wc -l  $top_lle.tab | awk '{print $1}')
((line_n--))
tail -$line_n  $top_lle.tab   | sort -k5,5nr >  $top_lle.tab.sort

cat   $top_lle.tab.head   $top_lle.tab.sort    >    $top_lle.tab.sort.tab
ld1=/work_dir/1KGPselection/LD/out.Maf1Percetn.vcf.gz.mnv.list.all.2mnv.ld
ld2=/work_dir/1KGPselection/LD/out.Maf1Percetn.vcf.gz.mnv.list.all.2snv.ld

perl   add_ld.pl   $top_lle.tab.sort.tab    $ld1    $ld2   >   $top_lle.tab.sort.tab.ld

fisher=/work_dir/1KGPselection/Fisher/all.counts.split.log10.fisher.BHadjusted.tab
perl   add_fisher.pl   $top_lle.tab.sort.tab.ld  $fisher  >  $top_lle.tab.sort.tab.ld.fisher
perl  ../non-SNV_selection/extract_id.pl   $top_lle.tab.sort.tab  > $top_lle.geneid
done


ls $popdir/*map.withlle  |  while read lle; do

ld1=/work_dir/1KGPselection/LD/out.Maf1Percetn.vcf.gz.mnv.list.all.2mnv.ld
ld2=/work_dir/1KGPselection/LD/out.Maf1Percetn.vcf.gz.mnv.list.all.2snv.ld

perl   add_ld2.pl   $lle    $ld1    $ld2   >   $lle.withld

perl ../non-SNV_selection/ld_stats.pl  $lle.withld >  $lle.withld.stat

done;

ls  ../non-SNV_selection/step4.all.sel.10*map.withlle.withld  | while read line; do echo $line;  sort -k6,6nr  $line | head -100  | sort -k5,5n   | perl -alne   'my@inf=split;print if($inf[4]<=0.2)'  | wc -l ; sort -k6,6nr  $line | head -100  | sort -k5,5n   | perl -alne   'my@inf=split;print if($inf[4] >0.2 and $inf[4]<=0.4)'  | wc -l ; sort -k6,6nr  $line | head -100  | sort -k5,5n   | perl -alne   'my@inf=split;print if($inf[4] >0.4 and $inf[4]<=0.8)'  | wc -l  ; done

