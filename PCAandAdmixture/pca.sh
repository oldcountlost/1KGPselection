wd=/work_dir/1KGPselection/PCA
vcf=/work_dir/1KGPselection/non-SNV_selection/total_noX.1percent_withnoX.vcf
gcta=/work_dir/software/gcta_v1.94.0Beta_linux_kernel_3_x86_64/gcta

admixture=/work_dir/software/dist/admixture_linux-1.3.0/admixture

cd $wd

#/vcftools --vcf tmp.vcf --plink --out tmp
tmp=/work_dir/1KGPselection/non-SNV_selection/vcf_trans_ped_noX.recode
<<!
plink --noweb --file $tmp  --maf 0.01 --make-bed --out $tmp

#### PCA
$gcta --bfile $tmp --make-grm --autosome --out $wd/tmp

$gcta --grm $wd/tmp --pca 3 --out $wd/pcatmp

#!
 sed  -i.bak 's/ /\t/g' $wd/pcatmp.eigenvec
 sort   -k1,1 pcatmp.eigenvec  > pcatmp.eigenvec.sort
 sort  -k1,1  /work_dir/1KGPselection/non-SNV_selection/samples.meta   > /work_dir/1KGPselection/non-SNV_selection/samples.meta.sort
 sed   -i.bak 's/ /_/g' /work_dir/1KGPselection/non-SNV_selection/samples.meta.sort

 join  -o 1.1 1.2 1.3 1.4 1.5 2.4 2.6 pcatmp.eigenvec.sort  /work_dir/1KGPselection/non-SNV_selection/samples.meta.sort  >  pcatmp.eigenvec.sort.group
sed -i.bak 's/ /\t/g' pcatmp.eigenvec.sort.group
echo '1 2       pc1     pc2     pc3     ethnic  ancestry' > pcatmp.eigenvec.sort.group2
cat pcatmp.eigenvec.sort.group2  pcatmp.eigenvec.sort.group  > pcatmp.eigenvec.sort.group3
mv pcatmp.eigenvec.sort.group3 pcatmp.eigenvec.sort.group  ; rm pcatmp.eigenvec.sort.group2

Rscript ./draw_pca.Rscript

exit
!
#### ADMIXTURE
for i in {8..12};do

$admixture --cv $tmp.bed $i |tee log${i}.out

done
