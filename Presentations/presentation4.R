
## Importing libraries and data ----

library(readxl)
library(writexl)
library(tidyverse)

downloads <-
  read_excel("FromExceltoR/Data/downloads.xlsx") %>%
  filter(size > 0)
downloads

## ggplot2: The basic concepts ----

dl_sizes <- downloads %>%
  group_by(machineName) %>%
  summarise(size = sum(size))

ggplot(dl_sizes, aes(x = machineName, y = size))

###############################################################################-
## A simple bar chart ----

ggplot(dl_sizes, aes(x = machineName, y = size / 10 ^ 6)) +
  geom_col()

## A bar chart with ordered bars ----

dl_sizes <- dl_sizes %>%
  arrange(size)
dl_sizes


dl_sizes$machineName

dl_sizes <- dl_sizes %>%
  mutate(machineName = factor(machineName, levels = dl_sizes$machineName))

dl_sizes$machineName

ggplot(dl_sizes, aes(x = machineName, y = size / 10 ^ 6)) +
  geom_col()

## Flipping the bar chart ----

p <- ggplot(dl_sizes, aes(x = machineName, y = size / 10 ^ 6)) +
  geom_col()

p + coord_flip()

## Exploring monthly download info ---

dl_sizes_month <- downloads %>%
  group_by(machineName, month) %>%
  summarise(size = sum(size)) %>%
  arrange(size) %>%
  mutate(machineName = factor(machineName, levels = dl_sizes$machineName))

p <-
  ggplot(dl_sizes_month, aes(x = machineName, y = size / 10 ^ 6, fill = month))
p +  geom_col()

### Some other bar chart options ----

p + geom_col(position = "dodge") ## Side by side bars
p + geom_col(position = "fill") ## Fractional plot

p +  geom_col() + facet_grid(vars(month))
p +  geom_col() + facet_wrap(vars(month))

###############################################################################-
##  A box plot - grouping by machine and month ---

p <-
  ggplot(downloads, aes(x = machineName, y = size, fill = machineName)) +
  geom_boxplot() +
  scale_y_log10()
p

p1 <- ggplot(downloads,aes(x = machineName,y = size,groups = month,fill = month)) +
  geom_boxplot()
p1 <- p1 + scale_y_log10()
p1

### A Violin plot ----
p <-
  ggplot(downloads, aes(x = machineName, y = size, fill = machineName)) +
  geom_violin(trim = TRUE) + 
  scale_y_log10()
p

p2 <- p + geom_jitter(size = 0.1, alpha = 0.05, width = 0.4) +
  theme_minimal() +
  scale_fill_manual(values = c("#2A2D43", "#91A6FF", "#C7EDE4", "#AFA060", "#AD8350"))
p2

###############################################################################-
## Daily summary statistics ----

daily_downloads <- downloads %>%
  group_by(machineName, date) %>%
  summarize(dl_count = n(), size_mb = sum(size) / 10 ^ 6) %>%
  mutate(total_dl_count = cumsum(dl_count))
daily_downloads

## A simple scatter plot ----

p <- ggplot(daily_downloads, aes(x = date, y = dl_count)) +
  geom_point()
p <- p + scale_y_log10()
p

### Points colored by machine ----

p + aes(color = machineName)

### Points shaped by machine ----

p + aes(shape = machineName)

## p + aes(shape = factor(size_mb))
## Warning messages:
## 1: The shape palette can deal with a maximum of 6 discrete values because more than 6 becomes difficult to
## discriminate; you have 337. Consider specifying shapes manually if you must have them.
## 2: Removed 331 rows containing missing values (geom_point).

###############################################################################-
## Bobble plot ----

p + aes(size = size_mb)

p + aes(size = size_mb, color = size_mb > 2)
p3 <- p + aes(size = size_mb, color = size_mb > 2)


## Cumulated total download size over the dates within machines ----

ggplot(daily_downloads, aes(x = date, y = total_dl_count)) +
  geom_line()

p4 <- ggplot(daily_downloads, aes(x = date, y = total_dl_count)) +
  geom_line(aes(group = machineName, colour = machineName))
p4

###############################################################################-
## Arrange multiple ggplots on the same page

# install.packages("ggpubr")
library(ggpubr)

figure <- ggarrange(p1, p2, p3, p4,
                    ncol = 2, nrow = 2)
figure


figure <- ggarrange(
  p1 + theme_bw(),
  p3 + theme_bw() +
    scale_color_manual(values = c("#2A2D43", "#91A6FF", "#AD8350")),
  p4 + theme_bw() +
    scale_color_manual(values = c( "#2A2D43", "#91A6FF", "#C7EDE4", "#AFA060", "#AD8350")),
  p2 + theme_bw(),
  align = "hv",
  labels = c ("A", "B", "C", "D"),
  ncol = 2, nrow = 2)

figure

## Save Tibble and Save Plot:

#write_xlsx(daily_downloads, "daily_downloads.xlsx")

#ggsave(filename = "vionlinPlot.pdf", plot = p2, height = 5, width = 10)

#pdf("vionlinPlot2.pdf", height = 5, width = 10)
#p2
#dev.off()
