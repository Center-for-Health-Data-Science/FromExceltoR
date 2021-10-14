# -----------------------------------------------------------------------------------------------
#                                       LOAD R-PACKAGES
# -----------------------------------------------------------------------------------------------

### Data Wrangling and Annotation

# install.packages("BiocManger")

# install.packages("tidyverse")
library(tidyverse)

# BiocManager::install("biomaRt")
library(biomaRt)



### For Plotting

#install.packages("ggplot2")
library(ggplot2)

#install.packages("gridExtra")
library(gridExtra)

#install.packages("viridis")
library(viridis)



### For DEA

# BiocManager::install("DESeq2")
library(DESeq2)



### For Enrichment Analysis

# BiocManager::install("clusterProfiler")
library(clusterProfiler)

# BiocManager::install("org.Mm.eg.db")
library(org.Mm.eg.db)



# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# SIGNIFICANT DE GENES:
# Takes as arguments:
# my.res = a dataframe of results from the DEseq results()function
# my.name = a user specified string denoting which group comparison DE genes in my.res are from.
# my.symbols = a tibble/dataframe of min 2 columns; one with entrez IDs (EntrezGeneID) and one with gene symbols.
# my.LFC = log fold change cutoff, default is 1.0
# my.cof = adjusted p-value cutoff, default is 0.01 
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SigDE <- function(my.res, my.name, my.symbols, my.LFC=1.0, my.cof=0.01) {
  my.res <- my.res %>%
    as_tibble() %>%
    bind_cols(my.symbols, .) %>%
    mutate(compar=rep(my.name, nrow(my.res)),
           dir = ifelse(log2FoldChange >= 0, 'up', 'down')) %>%
    filter((log2FoldChange >= my.LFC | log2FoldChange <= -my.LFC) & padj <= my.cof) %>%
    arrange(padj, desc(abs(log2FoldChange)))
  return(my.res)
}



# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# PCA Plot
# Takes as arguments:
# countDat = a dataframe of expression counts
# groupVar = a factor vector of groups (conditions) to color points by (may be the same or different as labelVar)
# labelVar = a vector of IDs for labeling (may be the same or different as groupVar)
# colVar = a vector of colors (one color for each group)
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


pcaPlot <- function(countDat, groupVar, labelVar, colVar) {
  
  # Make basic plot
  pcap <- ggplot(data=countDat) + geom_point(aes(x=PC1,y=PC2,color= groupVar), size=2) + 
    geom_text(aes(x=PC1,y=PC2, label=labelVar)) +
    
    # Improve look of plot:
    theme_minimal() + theme(panel.grid.minor = element_blank()) + 
    scale_color_manual(values = colVar) +
    theme(legend.title=element_blank(), legend.text = element_text(size = 12, face="bold"), legend.position = "top", axis.title=element_text(size=12,face="bold")) +
    guides(colour = guide_legend(override.aes = list(size=6)))
  return(pcap)
}




