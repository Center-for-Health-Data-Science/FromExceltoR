# Graphics with ggplot2 ----
# Data Science Laboratory, University of Copenhagen
# August 2020


#############

### Importing libraries ----

library(readxl)
library(writexl)
library(tidyverse)
library(ggplot2)


### Set working directory ----
setwd('/Users/kgx936/Desktop/FromExceltoR_2021/Presentations/')


### Reading in data and filtering out entries where size is 0 ----
downloads <- 
  read_excel("downloads.xlsx") %>% 
  filter(size > 0)

downloads

#############

### ggplot2: The basic concepts ----

ggplot(downloads,aes(x=machineName,y=size))


### A simple bar chart ----

ggplot(downloads, aes(x = machineName, y = size/10^6)) + 
  geom_col()


### A bar chart with ordered bars ----

### Figure out which order
dl_sizes <- downloads %>% 
  group_by(machineName) %>% 
  summarize(size_mb = sum(size)/10^6) %>%
  arrange(size_mb)

dl_sizes

### Order by making a factor with specified levels
downloads <- downloads %>% 
  mutate(machineName = factor(machineName, levels = dl_sizes$machineName))



### MachineName as character vector, sample random 50:
MachineName50 <- downloads$machineName %>% 
  sample(., 50)
MachineName50

### MachineName as factor:
MachineName50 <- factor(MachineName50)
MachineName50


ggplot(downloads, aes(x = machineName, y = size/10^6)) + 
  geom_col()


###  Flipping the bar chart ----

# Assign a plot
p <- ggplot(downloads, aes(x = machineName, y = size/10^6)) + geom_col()

p

p + coord_flip()



###  Adding monthly download info ----

ggplot(downloads, aes(x = machineName, y = size/10^6, fill = month)) + geom_col()

p <- ggplot(downloads, aes(x = machineName, y = size/10^6, fill = month))


# Some other bar chart options ----
p + geom_col(position = "dodge") ## Left/first plot
p + geom_col(position = "fill") ## Right/second plot


#############

###  Daily summary statistics ----

daily_downloads <- downloads %>%
    group_by(machineName, date) %>% 
    summarize(dl_count = n(), size_mb = sum(size)/10^6) %>%
    mutate(total_dl_count = cumsum(dl_count))

daily_downloads


### A simple scatter plot ----

p <- ggplot(daily_downloads, aes(x = date, y = dl_count)) +
  geom_point()
p


### Plotting on the log-scale ----

p <- p + scale_y_log10()
p


### Points colored by machine ----

p + aes(color = machineName)


### Points shaped by machine ----

p + aes(shape = machineName)

### Bubble plot ----

p + aes(size = size_mb)


# Points colored by download size ----

p + aes(size = size_mb, color = size_mb > 2)


### Cumulative total download size over the dates within machines ----

ggplot(daily_downloads, aes(x = date, y = total_dl_count)) + 
  geom_line()

ggplot(daily_downloads, aes(x = date, y = total_dl_count)) + 
  geom_line(aes(group = machineName, colour = machineName)) 

#ggplot(daily_downloads, aes(x = date, y = total_dl_count, colour = machineName)) + geom_line()


### A box plot ----

p <- ggplot(daily_downloads, aes(x = machineName, y = size_mb, fill=machineName)) + 
  geom_boxplot()

p + scale_y_log10()


### A violin plot ----
p <- ggplot(daily_downloads, aes(x = machineName, y = size_mb, fill=machineName)) + 
  geom_violin(trim = TRUE) + scale_y_log10() 

p

p2 <- p + geom_point(size = 1, alpha = 0.5) + 
  theme_minimal() +
  scale_fill_manual(values=c("#2A2D43", "#91A6FF", "#C7EDE4", "#AFA060", "#AD8350"))

p2


### Save Object and Save Plot ----

write_xlsx(daily_downloads, "daily_downloads.xlsx")

ggsave(filename = "vionlinPlot.pdf", plot = p2, height = 5, width = 10)

pdf("vionlinPlot2.pdf", height = 5, width = 10)
p2
dev.off()


