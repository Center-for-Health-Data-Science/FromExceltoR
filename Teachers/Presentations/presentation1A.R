
##############################################
############### PRESENTATION 1A ############### 
##############################################

###### R as a calculator ###### 

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

###### Define variables ###### 

a <- 5

b <- 3


a + b 


c <- a + b


c

###### Check objects in environment ######

ls()


###### Object Types ######

# Character 
char1 <- "Hello World!"
char1
class(char1)


# Numeric 
num1 <- 5
num1
class(num1)


# Vector
vector1 <- c(1, 2, 3, 4, 5, 'hello', 'world', 7, 1)
vector1
class(vector1)


# List
list1 <- list(1, 2, 3, 4, 5, 'hello', 'world', 7, 1)
list1
class(list1)


# Vector of numeric 
vector2 <- c(1, 2, 4, 6, 8, 2, 5, 7)
vector2


###### Functions ######


# Summing a vector
?sum
sum(vector2)


# Mean of vector
?mean
mean(vector2)


mean(vector2) # mean/average

median(vector2) # median

sd(vector2) # standard deviation

sum(vector2) # sum

min(vector2) # minimum value

max(vector2) # maximum value

length(vector2) # length of vector


###### Working directories ######

# See current working directory
getwd()

# Change working directory 
setwd("/Users/kgx936/Desktop/HeaDS/GitHub_repos/FromExceltoR")
getwd()

# Read excel file from path relative to working directory
df <- readxl::read_excel("Data/climate.xlsx")

# Read excel file from absolute path
df <- read_excel("~/Users/kgx936/Desktop/HeaDS/GitHub_repos/FromExceltoR/Data/climate.xlsx")
