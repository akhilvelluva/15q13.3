#!/usr/bin/env Rscript
#
#
# This Script needs the following input
#
# 1. HTSEQ COUNT files
# 2. Test samples names in a separate file (Without file extension)
# 3. Out put folder
# 4. Study or Sample name
#
#
# Syntax
#
# Rscript DESeq2.R /RNA/htseq_counts/ /RNA/Samples.txt /RNA/DEG/ 15Q
#
#
args = commandArgs(trailingOnly=TRUE)
#library("pasilla")
library("DESeq2")
library("AnnotationDbi")
library("org.Hs.eg.db")
library("RColorBrewer")
library("ashr")
library("apeglm")
library("pheatmap")


DEseq.analysis <- function(dds, res.path, test_name){

    cat("Running DESeq analysis\n")
    dds <- DESeq(dds, quiet = T)

    ret.list <- lapply (test_name, function(x){

        cat(x,"___getting results\n")
        dds.res <- results(dds)
        tmp=gsub("\\..*","",row.names(dds.res))
        dds.res$symbol <- mapIds(org.Hs.eg.db, keys=tmp, column="SYMBOL", keytype="ENSEMBL", multiVals="first")
        dds.res$Entrez <- mapIds(org.Hs.eg.db, keys=tmp, column="ENTREZID", keytype="ENSEMBL", multiVals="first")

        cat(x,"___omitting na values\n")
        dds.res.nona <- na.omit(dds.res)

        cat(x,"___ordering results according to significance\n")
        dds.res.nona <- dds.res.nona[order(dds.res.nona$padj),]

        cat(x, "___transforming the result according to condition_test_vs_control\n")
        resLFC <- lfcShrink(dds, coef=2, type="apeglm")
        resNorm <- lfcShrink(dds, coef=2, type="normal")
        resAsh <- lfcShrink(dds, coef=2, type="ashr")
        pdf(file=paste(res.path, "/",x,"_LFC-transform.pdf", sep = ""))
        par(mfrow=c(1,3), mar=c(4,4,2,1))
        xlim <- c(1,1e5); ylim <- c(-3,3)
        plotMA(resLFC, xlim=xlim, ylim=ylim, main="apeglm")
        plotMA(resNorm, xlim=xlim, ylim=ylim, main="normal")
        plotMA(resAsh, xlim=xlim, ylim=ylim, main="ashr")
        dev.off()

        cat(x, "___calculating sample distances for heatmap\n")
        vsd <- vst(dds, blind=FALSE)
        sampleDists <- dist(t(assay(vsd)))
        sampleDistMatrix <- as.matrix(sampleDists)
        rownames(sampleDistMatrix) <- vsd$condition
        colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)

        pdf(file=paste(res.path, "/",x,"_sample_heatmap.pdf", sep = ""))
        pheatmap(sampleDistMatrix,
                     clustering_distance_rows=sampleDists,
                     clustering_distance_cols=sampleDists,
                     col=colors)
            dev.off()

         
        cat(paste(x, "___writing the result to ->  ", res.path, "\n", sep=""))
        write.table(as.data.frame(dds.res.nona),file=paste(res.path, "/",x,"all-res.txt", sep = ""), quote=F, sep="\t")
        dds.res.nona.adj <- dds.res.nona[dds.res.nona$padj<0.1,]
        write.table(as.data.frame(dds.res.nona.adj),file=paste(res.path, "/",x,"adjp-res.txt", sep = ""), quote=F, sep="\t")
        dds.res.nona.p <- dds.res.nona[dds.res.nona$pvalue<0.01,]
        write.table(as.data.frame(dds.res.nona.p),file=paste(res.path, "/",x,"p-0.01-res.txt", sep = ""), quote=F, sep="\t")
        cat(x, "is done!!\n")
            })
  

    cat("DONE!!!\n")
}

# test if arguments are presennt; if not, return help message
if (length(args)<4) {
    stop("$1 is input directory
          $2 is which samples are the test (one column)
          $3 is output directory
          $4 is test name", call.=FALSE)}

dir.create(args[3])
directory <- args[1]
testSamples <- read.table (file=args[2], header=FALSE)
testSamples


sampleFiles <- list.files(directory)
sampleNames <- gsub(".txt", "", sampleFiles)

sampleCondition <- rep ("control", length(sampleFiles))
sampleCondition[which(sampleNames %in% testSamples[,1])]="test"
sampleTable <- data.frame(sampleName = sampleNames, fileName = sampleFiles, condition = sampleCondition)
print (sampleTable)
ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable, directory = directory, design= ~ condition)
dds<-ddsHTSeq
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]
dds$condition <- relevel(dds$condition, ref = "control")
DEseq.analysis(dds, args[3], args[4])
