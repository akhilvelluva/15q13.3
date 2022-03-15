# 15q13.3 Project
We analyzed the effects of the 15q13.3 microdeletion on genome-wide gene expression using native RNA-seq data from blood of 3 individuals with the 15q13.3 microdeletion and 4 sex- and age-matched control subjects. We assessed differentially expressed genes (DEGs), gene ontology (GO) enrichment, protein-protein interaction (PPI) functional modules, as well as gene expression in different brain developmental stages.
## Data Analysis Methods
### RNA mapping
We have used the Human genome version 38 for mapping the Illumina NovaSeq paired-end reads with STAR aligner version 2.6.1. 

Please refer to the Script: STAR.sh
### Compute the transcription level
We used htseq-count (version 0.6.0) to compute the transcription level. Genes with a sum of less than 10 reads in all samples together were excluded from further analysis.

Please refer to the Script: HTSEQ_COUNTS.sh

### Differential expression of genes 
Differential expression of genes was determined with the R package DESeq2 (version 1.30.1), which uses the Benjamini-Hochberg method to correct for multiple testing .All three patients were tested together against the four control subjects for differential expression of RNA. Genes were considered to be significantly differentially expressed if p-adj < 0.05. Further, differential expression was analyzed for each patient individually against the controls. Genes being differentially expressed with a p-adj < 0.1 in all three patients were identified as overlapping DEGs.

Please refer to the Script: DESeq2.R
###  ABA Enrichment Analysis
For DEGs expressed <1.5 TPM in adult brain cortex (according to PTEE (https://bioinf.eva.mpg.de/PTEE/)), expression levels in different developmental stages were obtained from the R package ABAEnrichment (version 1.20.0) for the whole brain. 
We used a Tukey’s HSD test to determine whether this group of DEGs (<1.5 TPM in adult brain cortex) displays a significantly different expression profile between the brain developmental stages.

Please refer to the Pipeline: https://rpubs.com/Akhil_Velluva/ptee_aba

### GO enrichment
Gene ontology enrichment analysis was performed with the R package GOfuncR (version 1.14.0) for up- and down-regulated DEGs. GO nodes with a family wise error rate (FWER) <0.05 were considered significantly enriched. To check for unspecific GO enrichment analysis results, the four control subjects were split in two groups and differential gene expression and GO enrichment analyses were performed for those two control groups.

Please refer to the Pipeline: https://rpubs.com/Akhil_Velluva/GOfuncR



