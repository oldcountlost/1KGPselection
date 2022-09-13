wd=/work_dir/1KGPselection/LD


cd $wd

draw(){
        chr=$1
        m_start=$2
        end=$3
        label=$4
        zoom=$5
        out=$6
       awk '{print $1"\t"$4"\t"$4}' $chr.vcf.map  > $chr.vcf.bed
       perl  extract.pl  $chr.vcf.bed $m_start $end > $chr.vcf.extract.bed
       perl  form.matrix.pl   $chr.vcf.extract.bed   $chr.out_file.ld  > $chr.extract.ld.matrix
       perl   svg.pl  $chr.extract.ld.matrix  $chr.vcf.extract.bed  $m_start  $end   $label $zoom  >   $out.svg
       #perl中需要SVG包
#       /work_dir/software/Anaconda2/2.5.3/envs/py2.7/bin/python  /work_dir/software/HiCPlotter/HiCPlotter.py   -chr $chr  --start $m_start  --end  $end  -bed  $chr.vcf.extract.bed  -f $chr.extract.ld.matrix  -n ${chr}_${m_start}_${end}_ld -o ${chr}_${m_start}_${end}_ld.pdf  --matrixMax  1  --oExtension pdf  -r 1000
}

draw chr2  108384000   108784000  108585442 30  out
