# Statistical analysis in R ----
# Data Science Lab, University of Copenhagen
# 21 October 2021


# Step 1: Load packages & set working directory ----

#install.packages("emmeans")
#install.packages("readxl")
#install.packages("tidyverse")
#install.packages("GGally")


library(readxl)
library(tidyverse)
# Extension for ggplot 2 - pairwise plot matrix, a parallel coordinates plot, a survival plot, and several functions to plot networks.
library(GGally)
library(ggplot2)
library(emmeans)
# Package for statistical analysis. Estimated marginal means. 
# Means "extracted" from model not the data itself. Good for pairwise comparisons and adjustment for multiple testing. Back-transformation of model estimates.

setwd("~/Desktop/FromExceltoR/Presentations")



# Example A: Analysis of variance ----

## Example A: Analysis of variance

#### Step 1: Data

# Psoriasis is an immune-mediated disease that affects the skin. 
# Microarray experiment with skin from 37 people in order to examine a potential association between the disease and gene expression levels.
# In total 37 samples: 
  # 15 skin samples were from psoriasis patients and from a part of the body affected by the disease (`psor`)
  # 15 samples were from psoriasis patients but from a part of the body not affected by the disease (`psne`)
  # 7 skin samples were from healthy people (`healthy`).  

# Step 2: Data ----

psoriasisData <- read_excel("psoriasis.xlsx")
psoriasisData

# Dataset1 - Statistical analysis
# Gene IGFL4. 

psorData  <-  select(psoriasisData, type, IGFL4)
psorData

# Dataset2 - Bioinformatic analysis
psorDataG <- select(psoriasisData, -IGFL4)
psorDataG


# -----------------------------------------------------------------------------------------

# STATISTICAL ANALYSIS

# -----------------------------------------------------------------------------------------

# Dataset 1, make type a factor and count entry in each group
psorData <- mutate(psorData, type = factor(type))
count(psorData, type)



# Step 3: Descriptive plots and statistics ----

# Compute group-wise means and standard deviations.

ggplot(psorData, aes(x=type, y=IGFL4)) +
  geom_point() + 
  labs(x="Skin type", y="IGFL4")

ggplot(psorData, aes(x=type, y=IGFL4)) +
  geom_boxplot() + 
  labs(x="Skin type", y="IGFL4")

psorData %>% 
  group_by(type) %>% 
  summarise(avg=mean(IGFL4), median=median(IGFL4), sd=sd(IGFL4))


# Step 4: Fit of oneway ANOVA, model validation ----

# Does IGFL4 expression level differs between the three types/groups. 
# Oneway analysis of variance (ANOVA). The oneway ANOVA is fitted with `lm`.

oneway <- lm(log(IGFL4) ~ type, data=psorData)
oneway



# Step 5: Hypothesis test + Post hoc tests ----
# Carry out an F-test for the overall effect of the explanatory variable. 
# Input variable that is in some way important to include in a good model, that is, a model that does not include it is "significantly" different than the one that does.
# The null hypothesis is that the expected values are the same in all groups.

drop1(oneway,test="F")



# Is there a significant difference between all pairwise groups? To investigate that we do post hoc testing. 
# Framework of *estimated marginal means* using the **emmeans** package.`emmeans` returns the predicted gene expression IGFL4 on the log scale, 

emmeans(oneway,~type)

# The `pairs` command provide post hoc pairwise comparisons:
pairs(emmeans(oneway,~type))


#### Step 6: Report of model parameters
# As the analysis was done using a log transformation it is also advisable to backtransform. 
# Both things can be done automatically by the **emmeans** package, where the option `type="response" requests the backtransformation:

emmeans(oneway,~type,type="response")
confint(pairs(emmeans(oneway,~type,type="response")))
pairs(emmeans(oneway,~type,type="response"))


# Example B: Simple and multiple linear regression ----

  
# Step 1: Data ----


# For this part of the presentation we will use data from 31 cherry trees available in the built in dataset `trees`: 
# Girth, height and tree volume have been measured for each tree. 

data(trees)
trees
head(trees)

# Pairwise scatter plots:
plot(trees)


# Step 2: Visualization of raw data ----
# Pairwise scatter plots:
plot(trees)

# A more fancy version of this is available in **GGally**, where the diagonal is used to visualize the marginal distribution of the three tree variables:
ggpairs(trees)


# Step 3: Fitting and validating a simple linear regression model ----

linreg1 <- lm(Volume ~ Girth, data=trees)
linreg1

# Model assumptions about linearity, variance homogeneity, and normality.

par(mfrow=c(2,2))   # makes room for 4=2x2 plots!
plot(linreg1)

# Quadratic tendency in upper left plot suggesting that the linearity assumption is not appropriate. 
# Datapoint 31 seems to be an outlier.


# Step 4 iterated: Transformation ----

linreg2 <- lm(log(Volume) ~ log(Girth), data=trees)
par(mfrow=c(2,2))
plot(linreg2)


# Step 5: Report of the model ----
# The linear regression model above is  concerned with absolute changes. 
# Perhaps it is more reasonable to talk about relative changes.


linreg2 <- lm(log(Volume) ~ log(Girth), data=trees)
par(mfrow=c(2,2))
plot(linreg2)

summary(linreg2)

# The first line is about the intercept, the second line is about the slope. The columns are:
    # `Estimate`: The estimated value of the parameter (intercept or slope).
    # `Std. Error`: The standard error (estimated standard deviation) associated with the estimate in the first column.
    # `t value`: The $t$-test statistic for the hypothesis that the corresponding parameter is zero. Computed as the estimate divided by the standard error.
    # `Pr(>|t|)`: The $p$-value associated with the hypothesis just mentioned. In particular the $p$-value in the second line is for the hypothesis that there is no effect of girth on volume.
# Below the coefficient table you find, among others, the `Residual standard error`, i.e., the estimated standard deviation for the observations.


confint(linreg2)

# Thus, the model postulates the relation:

# ln(V) = a + b* ln(G)
# V = e^a * G^b

# This means that an increment of girth by 10%, say, corresponds to an increment of volume by a factor of 1.1^2.2 = 1.23, that is, by 23%.


# Step 6: Visualization of the model ----

ggplot(trees, aes(x = log(Girth), y = log(Volume))) + 
  geom_point() +
  geom_abline(intercept=-2.35332, slope=2.19997, col="red")

# With corresponding standard error:
  
ggplot(trees, aes(x = Girth, y = Volume)) + 
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  scale_x_log10() +
  scale_y_log10()


# Step 7 iterated: Multiple linear regression ----

linreg3 <- lm(log(Volume) ~ log(Girth) + log(Height), data=trees)
summary(linreg3)$coefficients

par(mfrow=c(2,2))
plot(linreg3)


# Step 8: Hypothesis test ----

# Comparison of two  models - Hypothesis is that there is no extra information in the height variable, when girth is in the model.
# Analysis of variance
anova(linreg3, linreg2)

# We could also just use the drop1 function,.

drop1(linreg3,test="F")

summary(linreg3)$coefficients


