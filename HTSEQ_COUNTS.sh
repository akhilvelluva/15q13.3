#!/bin/bash
$1 input directory="/RNA/STAR/" #STAR Mapped BAM files
$2 genome.gtf.file="gencode.v29.annotation.gtf.gz" # Genecode Annotation file in gtf format
$3 output directory="/RNA/htseq_counts" # HTSEQ-COUNT output folder
mkdir -p $3
samples=$(ls $1)
echo $samples
for i in $samples; do
    echo "htseq-count -f bam -s no -a 30 $1/$i/${i}_grch38-aln_sorted.bam $2 >$3/${i}.txt"
    htseq-count -f bam -s no -a 30 $1/$i/${i}_grch38-aln_sorted.bam $2 > $3/${i}.txt
done



