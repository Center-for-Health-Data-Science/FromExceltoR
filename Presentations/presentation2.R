### II. Working with data in R (R codes for presentation)

### See the files presentation2.html and presentation2.pdf for further explanations. 

########################
### 0. Load packages
########################

# Load tidyverse package
library(tidyverse)

# Load a package that can read excel files
library(readxl)

#set working directory 
setwd('./FromExceltoR')

########################
### 1. Importing data
########################

## Often we will work with large datasets that already exist in i.e. an excel sheet or
## a tab separated file. 

## We can easily load that data into R, either with the read_excel function or by clicking 
## on 'Import Dataset' in the Environment tab (right). 

# This command is generated via the Import data facility
crohns <- read_excel("Data/crohns_disease.xlsx")

########################
### 2. A first look at the data
########################

# Print first few lines of dataset on screen
crohns

# Get dimensions of your dataset
dim(crohns)

# How many observations == rows do we have?
nrow(crohns)

# How many data columns are there and what are their types?
# Both 'str' and 'summary' will you what column types you have. Summary has some extra summary 
# stats on numeric columns.
summary(crohns)
str(crohns)

# Subsetting/ Slicing tibbles and vectors:
# We will usually want to subset based on content not position so we will use tidyverse functions for that
# first 5 rows, all columns
crohns[1:5,]
# first five rows and first 3 columns
crohns[1:5, 1:3]


########################
### 3. The anatomy of tidyverse
########################

### Let's try some tidyverse commands.

# We will use tidyverse syntax in this course. It can look clunky for simple commands, 
# but it is very useful for complex commands

# Tidyverse syntax looks like this:
# 1. The name of the new object you are creating. Can omit if you don't want to save the result. 
# 2. The dataset we are working on. 
# 3. The function you want to perform on the dataset.

# new_object <-
#   dataset %>%
#   the_function(arguments...)

# Often assignment is done on the same line as we name the dataset, i.e.:
# 1. The name of the new object you are creating.
# 2. The function you want to perform on the dataset.

# new_object <- dataset %>%
#   my_function(arguments...) 

########################
### 4. Count, distinct, sort
########################

# Count and distinct are very useful to get information about your dataset!

# Variables (columns) can be numeric or categorical (characters, factors)  
crohns %>%
  str()

### Distinct tells us how many different levels a categorical variable has

# How many different treatments do we have?
crohns %>%
  distinct(treat)

#From how many different countries do we have data?
crohns %>%
  distinct(country)

### Counting: tabulation of categorical variables

# Total number of lines, i.e. patients in the current dataset
# Observe, this matches with the number of lines you can see in the Environment tab
crohns %>% 
  count()

# How many lines, i.e. patients do we have per treatment?
crohns %>% 
  count(treat)
# Is our dataset balanced?

# How many patients do we have for each age?
crohns %>% 
  count(age)

# Perhaps this is more useful: How many patients are older than 65?
crohns %>% 
  count(age>65)

### Sorting data: arrange

# Display dataframe sorted by age
crohns %>%
  arrange(age)

# Sort according to age size in descending order, i.e. oldest first
crohns %>%
  arrange(desc(age))

# We can also sort after sex first and then according to age size in descending order
crohns %>%
  arrange(sex, desc(age))

# Note we haven't saved anything here, we just get output to the console sorted in a certain way. 
# This helps us to check if the data looks correct and get an impression.


########################
### 5. Filtering data (selecting rows) with `filter`
########################

# How we subset dataset into subsets we find interesting. 
# For example only female patients: 
crohns %>% 
  filter(sex == 'F') # processed from left to right

# great about tidyverse: write code the way you think
# You always filter by defining conditions. 
# If the condition evaluates to 'TRUE' the line is included.
# see only data lines for patients over 65:
crohns %>% 
  filter(age > 65)

# From the above commands are getting the result printed to the console.
# This is useful to check something.
# To save the result, we need to re-assign:

seniors <- crohns %>% 
  filter(age > 65)

# view newly created data frame:
seniors 

# Do we still have all three treatment groups in our subset?
seniors %>%
  distinct(treat)

# How many patients with each treatment?
seniors %>%
  count(treat)

### The world of conditional operators 

# Now we get lines that fit certain conditions 
# but what if I want to filter on more than one condition? Enter conditional operators!

# The 'and' operator: &

# We can also subset on several conditions. 
# Here are younger patients who received drug 1:
crohns %>% 
  filter(age <= 65 & treat == 'd1')

# The 'or' operator: |

# get patients that were treated with either drug 1 or the placebo
crohns %>% 
  filter(treat == 'placebo' | treat == 'd1')

# The 'not' operator: !

# get patients that were not treated with the placebo:
crohns %>% 
  filter(treat != 'placebo')

# other conditional operators can be found in the first presentation!
# or just google it

?dplyr::filter

# what if you want to allow multiple arguments in a variable?
# here are the young patients who got treatment with either drug 1 or 2:
crohns %>% 
  filter(age <= 65 & treat %in% c("d1","d2"))

########################
### 6. Selecting variables (columns): with `select`
########################

### We can choose to only include certain columns:

# select only BMI, age and the number of adverse events:
crohns %>% 
  select(nrAdvE, BMI, age)

# we can also make a negative selection that excludes the named column(s):
# the ID doesn't give us any information since the data is anonymized:
without_id <- crohns %>% 
  select(-ID)

#show the new tibble without the ID column
without_id

########################
### 7. Transformations of data
########################

### We can create new columns based on other columns 

#this is our original tibble:
crohns

# We want to add height in meters
crohns <- crohns %>% 
  mutate(height_m = height/100)

crohns

# We can also create columns based on true/false conditions
# according to the CDC, a person with a BMI < 18.5 is underweight:
crohns <- crohns %>% 
  mutate(underweight = ifelse(BMI < 18.5, "Yes", "No"))

crohns

#How many patients are underweight?
crohns %>%
  count(underweight)

?mutate


########################
### 7. Summary statistics, revisited: The `summarize` function
########################

# Methods from before  
mean(crohns$age)
max(crohns$age)
summary(crohns)

# the summarize function does the same but in a tidyverse way:
crohns %>% 
  summarize(mean(age),
            max(age))

# We can also specify names for the new columns:
crohns %>% 
  summarize(mean_age = mean(age),
            max_age = max(age))

# what kind of things can you summarize? 
# Have a look at the help by typing '?summarize' into the console, or 'summarize'
# into the help panel and scroll down to 'Useful functions'.

# A useful summarize function is 'n()' which counts the number of lines

crohns %>% 
  summarize(mean_age = mean(age),
            max_age = max(age),
            number_lines = n())

# Note that R is tolerant of BE/AE spelling differences. 
# 'summarise' and 'summarize' are the same function, likewise with 'color' and 'colour'.


########################
### 8. Grouping: group_by
########################

### group_by imposes a grouping on a tibble (not saved!):

# Group according to sex
crohns %>%
  group_by(sex)

# We also group according to several variables!
# How many groups will we get?
crohns %>%
  group_by(sex, treat)

# By itself, group_by does nothing, we still get the same dataset returned. 
# But it is very useful in combination with other commands!

# The reason we want to do it this is way is that we can first impose grouping 
# with group_by and then pipe the resulting tibble into summarize which will 
# respect our grouping. So smart!

crohns %>%                      # the dataset
  group_by(sex) %>%             # grouped by sex
  summarise(avg = mean(age),    # calculate mean of the age
            med = median(age),  # calc median
            stdev = sd(age),    # calc standard dev.
            n = n())            # get the number of observations

# Now we see why 'n()' is useful: It tells us how many lines, i.e. patients are in each group.


# Group by sex and treatment, and calculate stats for the number of adverse events

crohns %>%                              # the dataset
  group_by(sex, treat) %>%              # grouped by sex
  summarise(avg = mean(nrAdvE),         # calculate mean number of adverse events
            med = median(nrAdvE),       # calc median
            max = max(nrAdvE),          # calc max 
            stdev = sd(nrAdvE),         # calc standard dev.
            total_events = sum(nrAdvE), # calc cumulative sum 
            n = n())                    # get the number of observations


########################
### 9. The might of the pipe operator: %>%
########################

# Many commands can be combined with the pipe operator to 
# pipe data through an analysis workflow

crohns %>%                              # the dataset
  filter(age > 65) %>%                  # filtered to only people over 65
  group_by(sex, treat) %>%              # Grouping 
  summarise(avg = mean(nrAdvE),         # calculate mean number of adverse events
            med = median(nrAdvE),       # calc median
            max = max(nrAdvE),          # calc max 
            stdev = sd(nrAdvE),         # calc standard dev.
            total_events = sum(nrAdvE), # calc cumulative sum 
            n = n()) %>%                # get the number of observations
  arrange(avg)                          # Sort output by the mean


# What if I want to do the same analysis but with only obese patients?
# The CDC lists a BMI of > 30 as obese.


