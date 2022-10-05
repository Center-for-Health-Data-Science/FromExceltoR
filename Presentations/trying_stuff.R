
library(tidyverse)
library(readxl)
library(ggplot2)

#set working directory absolute path
setwd("~/Documents/Heads_center_management/courses/excel_to_r/oct2022/FromExceltoR/Presentations")

# This command is generated via the Import data facility
crohns <- read_excel("data/crohns_disease.xlsx")

### A simple bar chart ----
ggplot(crohns, aes(x = treat, y = nrAdvE)) + 
  geom_col() 


###  Flipping the bar chart ----

# Assign a plot
p <- ggplot(crohns, aes(x = treat, y = nrAdvE)) + 
  geom_col()

#flip
p + coord_flip()

### Adding split by color: stacked bar charts

ggplot(crohns, aes(x = treat, y = nrAdvE, fill = sex)) + 
  geom_col()

crohns %>%
  group_by(treat, sex) %>%
  summarise(tot_nrAdvE = sum(nrAdvE)) %>%
  ggplot(aes(x = treat, y = tot_nrAdvE, fill = sex)) + 
  geom_col(position = "dodge")

#check
crohns %>%
  group_by(treat, sex) %>%
  summarise(tot_nrAdvE = sum(nrAdvE))

# Some other stacked bar chart placement options ----

ggplot(crohns, aes(x = treat, y = nrAdvE, fill = sex)) + 
  geom_col(position = "dodge2")

ggplot(crohns, aes(x = treat, y = nrAdvE, fill = sex)) + 
  geom_col(position = "fill")


ggplot(crohns, aes(x = treat, y = nrAdvE, fill = sex)) + 
  geom_col(position = position_dodge()) 


#the strange behavior of position = 'dodge' also applies to mtcars
mtcars
ggplot(mtcars, aes(y=mpg,x=as.factor(cyl), fill = as.factor(am))) +
  geom_col()

ggplot(mtcars, aes(y=mpg,x=as.factor(cyl), fill = as.factor(am))) +
  geom_col(position = 'dodge')
