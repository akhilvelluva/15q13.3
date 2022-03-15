# 15q13.3 Project
We analyzed the effects of the 15q13.3 microdeletion on genome-wide gene expression using native RNA-seq data from blood of 3 individuals with the 15q13.3 microdeletion and 4 sex- and age-matched control subjects. We assessed differentially expressed genes (DEGs), gene ontology (GO) enrichment, protein-protein interaction (PPI) functional modules, as well as gene expression in different brain developmental stages.
## Data Analysis Methods
### RNA mapping
We have used the Human genome version 38 for mapping the Illumina NovaSeq paired-end reads with STAR aligner version 2.6.1. 

Please refer to the Script: STAR.sh
### Compute the transcription level
We used htseq-count (version 0.6.0) to compute the transcription level. Genes with a sum of less than 10 reads in all samples together were excluded from further analysis.

Please refer to the Script: htseq-count.sh

### Differential expression of genes 
Differential expression of genes was determined with the R package DESeq2 (version 1.30.1), which uses the Benjamini-Hochberg method to correct for multiple testing .All three patients were tested together against the four control subjects for differential expression of RNA. Genes were considered to be significantly differentially expressed if p-adj < 0.05. Further, differential expression was analyzed for each patient individually against the controls. Genes being differentially expressed with a p-adj < 0.1 in all three patients were identified as overlapping DEGs.

Please refer to the Script: DESeq2.sh
