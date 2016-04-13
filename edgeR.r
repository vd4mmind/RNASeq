library(edgeR)
countTable <- read.table(pipe("grep -v \"^_\" genes_raw_count"), header=T)
treatment <- c("WT", "WT", "WT", "KO", "KO", "KO")
condition <- c("t1", "t2", "t2", "t1", "t2", "t2")
dge <- DGEList(counts=countTable, group=treatment)
design <- model.matrix(~ condition + treatment)
rownames(design) <- colnames(dge)
keep <- rowSums(cpm(dge)>1) >= 3
dge <- dge[keep,]
dge$samples$lib.size <- colSums(dge$counts)
dge <- calcNormFactors(dge)

## other
logCPM <- cpm(dge,log=TRUE,prior.count=5)
plotMDS(logCPM)
logCPM <- removeBatchEffect(logCPM,batch=condition)
plotMDS(logCPM)

## edgeR
dge <- estimateGLMCommonDisp(dge, design, verbose=T)
dge <- estimateGLMTrendedDisp(dge, design)
dge <- estimateGLMTagwiseDisp(dge, design)
fit <- glmFit(dge, design)
lrt <- glmLRT(fit, coef=2)
summary(de <- decideTestsDGE(lrt))
isDE <- as.logical(de)
DEnames <- rownames(dge)[isDE]

## combat-limma
library(sva)
v <- voom(dge, design, plot=TRUE)
combat_edata <- ComBat(dat=v$E, batch=condition, mod=design[,1], numCovs=NULL, par.prior=TRUE, prior.plots=FALSE)
fit <- lmFit(combat_edata, design)
fit <- eBayes(fit)
top <- topTable(fit,coef=3,number=Inf,sort.by="P")
sum(top$adj.P.Val<0.05)

## voom-limma
library(limma)
v <- voom(dge, design, plot=TRUE)
fit <- lmFit(v,design)
fit <- eBayes(fit)
top <- topTable(fit,coef=2,number=Inf,sort.by="P")
sum(top$adj.P.Val<0.05)

## voom-limma with weight
v <- voomWithQualityWeights(dge, design=design, normalization="none", plot=TRUE)
fit <- lmFit(v,design)
fit <- eBayes(fit)
top <- topTable(fit,coef=2,number=Inf,sort.by="P")
sum(top$adj.P.Val<0.05)
barplot(v$weights, xlab="Sample", ylab="Weight", col="white", las=2, main="Sample-specific weights")
