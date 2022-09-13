wd=$(pwd)
<<!

perl  pop_freq_with_counts.pl    ../SV/out.Maf1Percetn.vcf.recode.vcf    /work_dir/1KGPselection/non-SNV_selection/total_noX.samplre_order.meta  4  >  ./out.Maf1Percetn.vcf.recode.vcf.counts

split --lines=4000  --additional-suffix=counts.split  ./out.Maf1Percetn.vcf.recode.vcf.counts
ls ./*counts.split | while read line ; do

cat > $line.sh <<EOF
cd $wd
 /work_dir/software/Anaconda2/2.5.3/envs/py3.7/bin/python fisher.py  $line  >  $line.log10.fisher

EOF
 qsub -cwd -q st.q -P P18Z10200N0124 -l vf=2g -l num_proc=1 -binding linear:1  $line.sh
done


#cat ./*counts.split.log10.fisher  >  all.counts.split.log10.fisher

Rscript  ./BH.Rscript


!


awk '{print $1"\t"$2"\t"$11"\t"$15"\t"$20"\t"$23"\t"$6"\t"$8"\t"$18"\t"$12"\t"$27"\t"$26}' all.counts.split.log10.fisher.BHadjusted.tab  >  all.counts.split.log10.fisher.BHadjusted.tab.select.corr.tab
index=3
cat lle.test_set.order | while read lle_test ; do
        perl  combine.pl   all.counts.split.log10.fisher.BHadjusted.tab.select.corr.tab   $index   ../non-SNV_selection/step4.all.sel.10.${lle_test}.map.withlle   >  ${lle_test}.fisher_lle_corr.tab

        let index+=1
done
