# Graphics with ggplot2 ----


#############

### Importing libraries ----

library(readxl)
library(writexl)
library(tidyverse)
library(ggplot2)


### Set working directory ----
setwd('/Users/pbj825/Desktop/FromExceltoR/Presentations/')


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

downloads$machineName[1:10]

downloads <- downloads %>% 
  mutate(machineName = factor(machineName, levels = dl_sizes$machineName))

ggplot(downloads, aes(x = machineName, y = size/10^6)) + 
  geom_col()


### Saving a plot object

# Calling 'ggplot(data, aes(...))' creates a plot object. Like a dataframe, you can save
# this plot object by giving it a name:

p <- ggplot(downloads, aes(x = machineName, y = size/10^6)) + geom_col()

# Note that if you execute the line above, no plot appears. That is because we have redirected
# the output into a plot object we called 'p'. We could call it anything within the allowed 
# variable names in R. 

# Now that the plot object 'p' exists, we can call it by writing its name:
p

# This will cause the plot to appear, similar to how writing the name of a dataframe 
# object causes the dataframe to be printed to the console.

# Additional instructions can be added to an existing plot object, for example:
###  Flipping the bar chart ----

p + coord_flip()


#############

#Exercise A: 10 mins

# 1. Make a bar chart of the downloads data showing the total download size per month. 
# Hint: Very similar to the first example shown during the lecture 
# 2. Make a bar chart of the downloads data showing the total time spend on downloads per month. 
# 3. Assign the plot you made in 1. to the variable p_size_month .

#############

### Another level of information

# 2D plots have an x- and a y-axis. 
# However, we can often convey additional information by using color and shape. 
# I.e. in a plot with two lines, one of them can be dashed and the other solid, 
# or one can be red and the other blue.  

# There are 4 different aesthetics (aes) we can use to add this kind of information to our plots:
# color: change the color depending on the variable
# fill: change the fill depending on the variable (this is what we use for bar charts)
# shape: change the shape of the dot or line depending on the variable
# size: change the size of the dot or line depending on the variable

###  Add coloring by monthly download info ----

# This is the same command as above, but with an additional keyword in the aes: 'fill = ...'
# Like with x and y, we pass here the column that contains the variable we want to color by. 
# In this case it's the month column.
# Note that in bar plots, color is defined with the 'fill' keyword. The 'color' keyword refers
# to the outline of the bar.

p <- ggplot(downloads, aes(x = machineName, y = size/10^6, fill = month))

p + geom_col()

# Compare this to the previous plots by using the arrows in the 'plot' window. 
# You will note that each bar has become split up into colored fractions that are stacked on top of each other.

# We could also use a different arrangement than stacked by calling the 'position' keyword:
p + geom_col(position = "dodge") ## Left/first plot
p + geom_col(position = "fill") ## Right/second plot

# Note that we did not need to repeat the aesthetics mapping. It is still saved in our plot object 'p'.
# We added an additional instruction by writing p + geom_col(...)

###  Grouping by machine and month ----
p1 <- ggplot(downloads, aes(x = machineName, y = size, groups = month, fill=month)) + 
  geom_boxplot() + scale_y_log10() 
p1

### Types of plots: Geom

# The geom defines what kind of plot we want to make: bar, boxplot, line, ect. 
# There are many geoms! You can find information for example in the cheatsheet: https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
# Or in the gallery: https://r-graph-gallery.com/


#############

#Exercise B: 7 mins

# 1. On the bar chart you made in A3 (p_size_month), add coloring by the machineName by using the 'fill' 
# keyword in the aes.
# 2. Now, position the bars for the different machines next to each other instead of stacked. 
# Hint: Use the 'position' keyword.
# 3. Now turn it into a boxplot instead. If it's hard to see the boxes try to make the scale of 
# the size axis logarithmic.

#############

### A simple scatter plot ----

# We here make a new dataset from downloads which is suitable for a scatter plot
###  Daily summary statistics ----

daily_downloads <- downloads %>%
    group_by(machineName, date) %>% 
    summarize(dl_count = n(), size_mb = sum(size)/10^6) %>%
    mutate(total_dl_count = cumsum(dl_count))

daily_downloads

# Notice we have changed the dataset from 'downloads' to 'daily_downloads'

p <- ggplot(daily_downloads, aes(x = date, y = dl_count)) +
  geom_point()
p

### Plotting on the log-scale ----

p <- p + scale_y_log10()
p

### Using aes to define groups

# Like in the bar chart above, we can use the four aes keywords color, fill, shape and size to
# distinguish different groups of points.

# Not all aesthetics can be combined with all geoms. 
# 'shape' is useful for scatter plots, you can i.e. have filled dots, hollow dots and triangles 
# denoting different groups. But it will not do anything in a bar chart.

# Let's try some different aesthetics mappings on scatter plots:

### Points colored by machine ----

# In scatter plots, color is controlled via the 'color' keyword, whereas in bar charts it is 
# controlled by 'fill'.
p + aes(color = machineName)


### Points shaped by machine ----

p + aes(shape = machineName)

### Bubble plot ----

p + aes(size = size_mb)


### You can use several aes together:

# shape and color after two different variables:
p + aes(shape = machineName, color = size_mb)

# Both size and color by the download size:

p + aes(size = size_mb, color = size_mb > 2)
p2 <- p + aes(size = size_mb, color = size_mb > 2)

### Legends:

# You will notice in the examles above that we got a legend for the different groupings without 
# asking for it. In ggplot2, legends come from the aes. This is the correct way to do them. 

### Color scales will depend on whether the variable we color by is continuous or discrete:

#continuous: size of download: shades of blue
p + aes(color = size_mb)

#discrete: is the download size greater than 2 mb or not? We only get two different colors
p + aes(color = size_mb > 2)


# Aes can also be defined inside the geom as well as added later:

#These three commands all do the same!

#all aes stated during object creation:
ggplot(daily_downloads, aes(x = date, y = dl_count, color = machineName)) +
  geom_point()

#color aes specified when the geom is added:
ggplot(daily_downloads, aes(x = date, y = dl_count)) +
  geom_point(aes(color = machineName))

# color aes added separately:
ggplot(daily_downloads, aes(x = date, y = dl_count)) +
  geom_point() +
  aes(color = machineName)

#############

#Exercise C:

# 1. Add coloring by the total download count (total_dl_count) to this plot:
p <- ggplot(daily_downloads, aes(x = date, y = dl_count)) +
  geom_point()
# 2. Add a different point shape depending on the machine to the same plot.
# 3. Change the coloring to be discrete instead of continuous. You can choose total_dl_count > 5000 
# or any cutoff you like.  

#############

### Other types of plots:

# Line plot: Cumulative total download size over the dates within machines

p3 <- ggplot(daily_downloads, aes(x = date, y = total_dl_count)) + 
  geom_line(aes(group = machineName, colour = machineName)) 
p3 

# A box plot ----

p <- ggplot(daily_downloads, aes(x = machineName, y = size_mb, fill=machineName)) + 
  geom_boxplot()

p + scale_y_log10()


# A violin plot ----
p <- ggplot(daily_downloads, aes(x = machineName, y = size_mb, fill=machineName)) + 
  geom_violin(trim = TRUE) + scale_y_log10() 
p

### More control over colors: 

# scale_fill_manual is used to change the colors assigned by a 'fill' aesthetic for a discrete variable.
# For continuous variables, use scale_fill_gradient(low color, high color), or scale_fill_gradient2 
# for a diverging scale (low color, mid color, high color).
# If you use a color aes, instead use scale_color_...
# As always, stackoverflow is your friend.

p4 <- p + geom_point(size = 1, alpha = 0.5) + 
  theme_minimal() +
  scale_fill_manual(values=c("#2A2D43", "#91A6FF", "#C7EDE4", "#AFA060", "#AD8350"))

p4


### Arrange multiple ggplots on the same page ----

# install.packages("ggpubr")
library(ggpubr)

figure <- ggarrange(p1, p2, p3, p4,
                    ncol = 2, nrow = 2)
figure

figure <- ggarrange(p1 + theme_bw(),
                    p2 + theme_bw() + scale_color_manual(
                      values=c("#2A2D43", "#91A6FF", "#AD8350")),
                    p3 + theme_bw(), 
                    p4 + theme_bw(), 
                    labels = c ("A", "B", "C", "D"),
                    ncol = 2, nrow = 2)
figure


### Save Object and Save Plot ----

write_xlsx(daily_downloads, "daily_downloads.xlsx")

ggsave(filename = "vionlinPlot.pdf", plot = p4, height = 5, width = 10)

pdf("vionlinPlot2.pdf", height = 5, width = 10)
p4
dev.off()










