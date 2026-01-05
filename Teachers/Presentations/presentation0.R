
##############################################-
############### PRESENTATION 0 ############### 
##############################################-

############# R as a calculator #############

# Adding
1+1

# Subtracting
2-1

# Multiplication 
3*3

# Division 
15/3

# Exponentiation  
10^2

# Base-2 logarithm
log2(20)

# Base-10 logarithm
log10(20)

#############  Define objects  #############

a <- 5

b <- 3

a

b


a + b 


c <- a + b


c

### Check objects in environment
ls()

############# Basic Data Types and Structures ############# 

# Numeric
  
num1 <- 5 # assignment (stores the value)
num1 # printing (shows the stored value)
# Access data type or structure with the class() function
class(num1)

# Character
  
char1 <- "Hello World!"
char1
class(char1)

# A vector of numeric values

vector1 <- c(1, 2, 4, 6, 8, 2, 5, 7)
vector1
# Access data type or structure with the class() function
class(vector1)

#############  R packages  ############# 

# R packages are collections of functions written by R developers and super users 
# and they make our lives much easier. Functions used in the same type 
# of R analysis/pipeline are bundled and organized in packages. In order to use a package 
# we need to download and install it on our computer. Most R packages are stored 
# and maintained on the CRAN https://cran.r-project.org/mirrors.html repository.

# Install a package

# install.packages('tidyverse') # run once (not every session)

# Load packages

library(tidyverse) # run each time you start R

# There is a help page for each package to tell us which functions 
# it contains and which arguments go into these. 

# Query package

?tidyverse

# Query function from package

?dplyr::select

#############  Functions  ############# 

# Summing a vector

?sum
sum(vector1)

# Mean of vector

?mean
mean(vector1)


mean(vector1) # mean/average

median(vector1) # median

sd(vector1) # standard deviation

sum(vector1) # sum

min(vector1) # minimum value

max(vector1) # maximum value

length(vector1) # length of vector


