####DESEQ CODE for specific number of samples
source("http://bioconductor.org/biocLite.R")
biocLite("DESeq2")
#setwd("/Users/vdas/Desktop/Work/Transcriptomic/myanalysis")
countTable = read.table("counts_d7_final.txt", header = TRUE, row.names=1)
head(countTable)
colData = data.frame(row.names=c("GFP+A","GFP+B","GFP-A","GFP-B"), condition=as.factor(c(rep("+ve",2),rep("-ve",2))))
colData
library("DESeq2")
dds <- DESeqDataSetFromMatrix(countData = countTable,
colData = colData,
design = ~ condition)
dds
#featureData <- data.frame(gene=rownames(countTable))
#head(featureData)
#(mcols(dds) <- data.frame(mcols(dds), featureData))
ddds <- DESeq(dds)
res <- results(ddds)
res

#summary(res)
resOrdered<-res[order(res$padj),]
head(resOrdered)

thresh<-subset(resOrdered,padj<0.01)
dim(thresh)
head(thresh)
write.table(thresh, "DE_d7_0.01.txt", sep="\t")
up<-subset(thresh,log2FoldChange>1.5)
dim(up)
write.table(up, "upregulated_d7.txt", sep="\t")
down<-subset(thresh,log2FoldChange<1.5)
dim(down)
write.table(down, "downregulated_d7.txt", sep="\t")
