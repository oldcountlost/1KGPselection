wd=$(pwd)

vcf=/hwfssz1/pub/database/ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/HGSVC2/release/v1.0/PanGenie_results/pangenie_merged_bi_all.vcf.gz


cd $wd



vcftools  --maf  0.01   --gzvcf  $vcf  --chr chr2  --out  selected_vcf  --from-bp 108000000  --to-bp  109000000  --recode  --recode-INFO-all


sample=/work_dir/1KGPselection/non-SNV_selection/unrelated.IDs
EAS=/work_dir/1KGPselection/non-SNV_selection/EAS.id

out_ped="$wd/vcf_trans_ped_noX"
out="$wd/total_noX"

####

vcftools --vcf  selected_vcf.recode.vcf  --plink  --out $out_ped

perl filtersample.pl  $out_ped.ped  $sample   > $out_ped.ped2   && mv $out_ped.ped2  $out_ped.ped


plink  --noweb  --recode12  --geno 0.0 --maf 0.01 --tab  --file  $out_ped  --out  $out_ped.recode  && rm $out_ped.ped  $out_ped.map

plink --noweb --file $out_ped.recode  --make-bed --out  $out_ped.recode.bin



####

vcftools --vcf  selected_vcf.recode.vcf  --plink  --out $out_ped


sort $sample  $EAS  | uniq -d  > $EAS.2


perl filtersample.pl  $out_ped.ped  $EAS.2   > $out_ped.EAS.ped   && mv $out_ped.EAS.ped  $out_ped.ped

plink  --noweb  --recode12  --geno 0.0 --maf 0.01 --tab  --file  $out_ped  --out  $out_ped.recode.EAS  && rm $out_ped.ped  $out_ped.map

plink --noweb --file $out_ped.recode.EAS  --make-bed --out  $out_ped.recode.EAS.bin





####

vcftools --vcf  selected_vcf.recode.vcf  --plink  --out $out_ped


sort $EAS.2  $sample  | uniq -u > $sample.noEAS


perl filtersample.pl  $out_ped.ped  $sample.noEAS   > $out_ped.noEAS.ped   && mv $out_ped.noEAS.ped  $out_ped.ped

plink  --noweb  --recode12  --geno 0.0 --maf 0.01 --tab  --file  $out_ped  --out  $out_ped.recode.noEAS  && rm $out_ped.ped  $out_ped.map

plink --noweb --file $out_ped.recode.noEAS  --make-bed --out  $out_ped.recode.noEAS.bin


