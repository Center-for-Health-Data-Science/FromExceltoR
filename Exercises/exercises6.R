## ----setup, include=FALSE----------------------------------------------------------------------
knitr::opts_chunk$set(warning=FALSE, message=FALSE)


## ---- eval=FALSE-------------------------------------------------------------------------------
## library(tidyverse)
## library(ggplot2)
## library(readxl)
## library(BiocManager)
## library(DESeq2)


## ---- eval=FALSE-------------------------------------------------------------------------------
## airDat <- airDat %>%
##   mutate(nzeros = rowSums(dplyr::select(., -Ensgene, -GeneSymbol, -GC, -Length)<=3))


## ---- eval=FALSE-------------------------------------------------------------------------------
## 
## exprObj <- DESeqDataSetFromMatrix(countData = ,
##                               rowData = ,
##                               colData = ,
##                               design=~)


## ---- eval=FALSE-------------------------------------------------------------------------------
## exprObjvst <- vst(exprObj,blind=FALSE)


## ---- eval=FALSE-------------------------------------------------------------------------------
## # un-transformed counts
## unTrf <- assay(exprObj)
## head(unTrf, n=3)
## 
## # vst transformed counts
## vstTrf <- assay(exprObjvst)
## head(vstTrf, n=3)


## ---- eval=FALSE-------------------------------------------------------------------------------
## # un-transformed counts
## unTrf <- unTrf %>% t() %>%
##     dist() %>% cmdscale(., eig=TRUE, k=2)
## 
## unTrf <- tibble(PCo1=unTrf$points[,1],PCo2=unTrf$points[,2])
## 
## # vst transformed counts
## 
## vstTrf <- vstTrf %>% t() %>%
##     dist() %>% cmdscale(., eig=TRUE, k=2)
## 
## vstTrf <- tibble(PCo1=vstTrf$points[,1],PCo2=vstTrf$points[,2])
## 


## ---- eval=FALSE-------------------------------------------------------------------------------
## # Fitting gene-wise glm models:
## exprObj <- DESeq(exprObj)


## ---- eval=FALSE-------------------------------------------------------------------------------
## resTC <- results(. , contrast = c(), independentFiltering = FALSE)

