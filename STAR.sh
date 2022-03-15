#!/bin/bash
$1 indir ="/RNA/reads" # Path to cleaned fastq files (After QC)
$2 outdir="/RNA/STAR/" # Path to mapped files
$3 index="/RNA_Splice/STAR/grch38_index" # Star Index files . Please refer to STAR_Index.sh

mkdir -p $2

samples=$(ls $1)
echo $samples
for i in $samples; do
    mkdir -p $2/$i
    echo "Patient $i"
    echo "STAR --runThreadN 50 --genomeDir $3--readFilesIn $1/$i/${i}_1.fastq.gz $1/$i/${i}_2.fastq.gz --readFilesCommand zcat --outFileNamePrefix$2/$i/$i"
    STAR --runThreadN 50 --genomeDir $3 --readFilesIn $1/$i/${i}_1.fastq.gz $1/$i/${i}_2.fastq.gz --readFilesCommand zcat --outFileNamePrefix $2/$i/$i
    done
