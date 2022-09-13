wd=/work_dir/1KGPselection/LD
contig=/work_dir/1KGPselection/LD/primary_contigs.list
#vcf=/hwfssz1/pub/database/ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/HGSVC2/release/v1.0/PanGenie_results/pangenie_merged_bi_all.vcf.gz
vcf=/work_dir/1KGPselection/LD/out.Maf1Percetn.vcf.gz


cat $contig | while read chrom; do
chr=${chrom##*chr}
out_ped=$chrom.vcf

cat > $chrom.plink.sh <<EOF
 cd $wd
  vcftools  --maf  0.01   --gzvcf  $vcf  --plink --chr $chrom   --out   $out_ped
  plink --noweb  --file  $out_ped  --allow-no-sex  --r2 --ld-window 99999 --ld-window-kb 50 --ld-window-r2 0.01  --out $chrom.out_file
  perl  haplo_ld.pl   $chrom.out_fil.ld    $chrom.out_fil.ld.svg                                             ## too large file. do in smaller batches than chromosome
 #plink --noweb  --file  $out_ped  --allow-no-sex  --r2 --ld-window 99999 --ld-window-kb 10 --ld-window-r2 0.2  --out $chrom.out_file

EOF

qsub -cwd -q st.q -P P18Z10200N0124 -l vf=2g -l num_proc=1 -binding linear:1 $chrom.plink.sh

done
