## ----setup, include=FALSE, warning=FALSE, message=FALSE----------------------------------------
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)


## ----------------------------------------------------------------------------------------------
# Data Wrangling
# install.packages("tidyverse")
# install.packages("readxl")
library(tidyverse)
library(readxl)

# For Plotting
# install.packages("ggplot2")
library(ggplot2)


# For DEA
# install.packages("BiocManager")
# BiocManager::install("DESeq2")
library(DESeq2)
library(dplyr)


## ----------------------------------------------------------------------------------------------
exprDat <- read_excel("MouseRNAseq.xlsx")
exprInfo <- read_excel("MouseSampleInfo.xlsx")

# Look at the data:
head(exprDat, n=5)
dim(exprDat)

head(exprInfo)


## ----------------------------------------------------------------------------------------------
exprInfo <- exprInfo %>%
  mutate(CellType = as.factor(CellType),
         Status = as.factor(Status))

head(exprInfo)


## ----------------------------------------------------------------------------------------------
# Sample 16 random rows
expr16 <- exprDat %>%
  sample_n(.,16)
expr16
# Extract genenames
GeneName <- expr16$GeneName

# Gather counts
expr16 <- expr16 %>%
  dplyr::select(-GeneName) %>%
  t() %>% 
  as_tibble() %>% 
  rename_at(vars(names(.)), ~GeneName) %>% 
  gather()

# Give it a look:
expr16


## ----------------------------------------------------------------------------------------------
ggplot(expr16, aes(log2(value+1))) + 
  geom_histogram(color="black", fill="grey80", bins=20) + 
  theme_minimal() +
  facet_wrap(~key)


## ----------------------------------------------------------------------------------------------
table(exprInfo$CellType, exprInfo$Status)
# 2 samples in each group


## ----------------------------------------------------------------------------------------------
# First, we count the number of times a count value in a sample is greater or equal to 3. Then Filter rows where at least 2 samples has a count great than 3.

exprDat <- exprDat %>%
  mutate(nzeros = rowSums(dplyr::select(.,-GeneName)<=3)) %>% # count number of 
  filter(nzeros <= 2) %>%
  dplyr::select(-nzeros)

# How many genes do we have left:
dim(exprDat)



## ----fig.align="center", echo=FALSE, out.width="70%"-------------------------------------------
knitr::include_graphics(paste0(getwd(),"/sumExp.png"))


## ----------------------------------------------------------------------------------------------
# Pull out GeneNames and EntrezGeneID for later use
GeneNames <- exprDat %>%
  dplyr::select(GeneName)

exprDat <- exprDat %>%
  column_to_rownames(., var = "GeneName")


## ----------------------------------------------------------------------------------------------
exprObj <- DESeqDataSetFromMatrix(countData = exprDat,
                              colData = exprInfo,
                              design= ~CellType+Status)
exprObj


## ----------------------------------------------------------------------------------------------
colSums(assay(exprObj))


## ----------------------------------------------------------------------------------------------
#boxplot(assay(exprObj), las=2)
boxplot(log2(assay(exprObj)+1), las=2)


## ----------------------------------------------------------------------------------------------
exprObjvst <- vst(exprObj,blind=FALSE)


## ----------------------------------------------------------------------------------------------
par(mfrow=c(1,1))
boxplot(assay(exprObjvst), xlab="", ylab="Log2 counts per million",las=2)


## ----fig.height = 4, fig.width = 12------------------------------------------------------------

# BiocManager::install("vsn")
library(vsn)
rawSd <- vsn::meanSdPlot(as.matrix(assay(exprObj)), plot=FALSE)
logSd <- vsn::meanSdPlot(log2(as.matrix(assay(exprObj))+1), plot=FALSE)
vstSd <- vsn::meanSdPlot(as.matrix(assay(exprObjvst)), plot=FALSE)

par(mfrow = c(1,3),  mar = c(3, 3, 3, 1), mgp = c(1.5, 0.5, 0))
smoothScatter(x = rawSd$px, y = rawSd$py, ylab = "Sd",xlab = "Rank", main = "Counts", cex.main=1.5, ylim = c(0,4e+03))
lines(x = rawSd$rank, y = rawSd$sd, add = TRUE, col = "red")
smoothScatter(x = logSd$px, y = logSd$py, ylab = "Sd",xlab = "Rank", main = "Log2", cex.main=1.5, ylim = c(0,4))
lines(x = logSd$rank, y = logSd$sd, add = TRUE, col = "red")
smoothScatter(x = vstSd$px, y = vstSd$py, ylab = "Sd",xlab = "Rank", main = "VST", cex.main=1.5, ylim = c(0,4))
lines(x = vstSd$rank, y = vstSd$sd, add = TRUE, col = "red")



## ----------------------------------------------------------------------------------------------
colSums(assay(exprObj))


## ----------------------------------------------------------------------------------------------
#boxplot(assay(exprObj), las=2)
boxplot(log2(assay(exprObj)+1), las=2)


## ----------------------------------------------------------------------------------------------
exprObjvst <- vst(exprObj,blind=FALSE)
boxplot(assay(exprObjvst), xlab="", ylab="Log2 counts per million",las=2)


## ----------------------------------------------------------------------------------------------
plotPCA(exprObjvst,intgroup="Status")
plotPCA(exprObjvst,intgroup="CellType")


## ----------------------------------------------------------------------------------------------
exprObj <- DESeq(exprObj)


## ----------------------------------------------------------------------------------------------
resultsNames(exprObj)


## ----------------------------------------------------------------------------------------------
resLC <- results(exprObj, contrast = c("Status", "lactate", "control"), independentFiltering = FALSE)


## ----------------------------------------------------------------------------------------------
DESeq2::plotMA(resLC)
summary(resLC)


## ----------------------------------------------------------------------------------------------
resPC <- results(exprObj, contrast = c("Status", "pregnant", "control"),  independentFiltering = FALSE)

#DESeq2::plotMA(resPC)
#summary(resPC)


## ----------------------------------------------------------------------------------------------
resLP <- results(exprObj, contrast = c("Status", "lactate", "pregnant"),  independentFiltering = FALSE)

#DESeq2::plotMA(resLP)
#summary(resLP)


## ----------------------------------------------------------------------------------------------
resDE <- rbind(resLC, resPC, resLP) %>% 
  as_tibble() %>%
  mutate(GeneName = rep(GeneNames$GeneName, 3)) %>%
  filter((log2FoldChange >= 1.0 | log2FoldChange <= -1.0) & padj <= 0.01) %>%
  arrange(padj, desc(abs(log2FoldChange)))

# DE genes 
dim(resDE)
length(unique(resDE$GeneName))


## ----------------------------------------------------------------------------------------------
# Make a vector of unique EntrezGeneIDs (top100):

top100 <- resDE[1:100,] %>%
  pull(GeneName) %>%
  unique()

length(top100)


## ----------------------------------------------------------------------------------------------
head(assay(exprObjvst), n=5)

resVST <- assay(exprObjvst) %>% 
  as.data.frame() %>%
  rownames_to_column(var = "GeneName")  %>%
  as_tibble() %>%
  filter(GeneName %in% top100)


## ----------------------------------------------------------------------------------------------
HPnames <- resVST %>% 
  pull(GeneName)


HPdat <- resVST %>%
  dplyr::select(-GeneName) %>%
  as.matrix()


## ----------------------------------------------------------------------------------------------
heatmap(HPdat,
        ColSideColors=exprInfo$CellType.colors, 
        labCol=exprInfo$Status,
        labRow = HPnames,
        cexCol=1.2, 
        cexRow = 1.0)

