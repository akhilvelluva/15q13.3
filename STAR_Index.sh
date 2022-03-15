#!/bin/bash
$1 # number of treads
$2 dirctory_to_output_index="/RNA_Splice/STAR/grch38_index" # STAR index directory
$3 genome.fa.file="/GRCh38/whole_genome.fa" # GRCH 38 genome in fasta format
$4 genome.gtf.file="gencode.v29.annotation.gtf.gz" # Gene code Annotation data in gtf format
$5 # sjdbOverhang: read length minus 1

mkdir -p $2

echo "STAR --runThreadN $1 --runMode genomeGenerate --genomeDir $2 --genomeFastaFiles $3 --sjdbGTFfile $4 --sjdbOverhang $5"

STAR --runThreadN $1 --runMode genomeGenerate --genomeDir $2 --genomeFastaFiles $3 --sjdbGTFfile $4 --sjdbOverhang $5

