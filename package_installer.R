# Let's check if everything you need for the course is installed

# If there are packages missing, they will be installed by this script.

# Please run the COMPLETE script. At the end the console output will tell you
# whether all packages are installed or not.

# If not everything works immediately, don't panic. Run it again. Sometimes when dependiencies have to be installed the actual package you want is not correctly installed th first time around.

### important ###
# if you are a windows user, make sure to have Rtools installed
#https://cran.r-project.org/bin/windows/Rtools/

#####################
# first let's look at your R version
#####################

if(as.numeric(base::version$major) < 4){
  print('Your R version may be too old. Please update!')
  print('You can find help here:')
  print('https://uvastatlab.github.io/phdplus/installR.html')
}

#####################
# create lists of packages to be installed and which ones are already installed
#####################

# list package names that are needed from CRAN
packages_needed = c("tidyverse","readxl","ggplot2", "writexl",
                    "table1","knitr","GGally","emmeans")

finished = FALSE

n_runs = 0

while(!finished){
  # list the packages that are already installed
  packages_installed = installed.packages()[,"Package"]
  
  #####################
  # loop over necessary packages and install them if needed
  #####################
  
  # here you can also see how loops look :)
  for(package_name in packages_needed){ # iterate through all package names
    if(!(package_name %in% packages_installed)){ # check whether package name is in list of installed packages
      cat('package',package_name,'missing\ninstalling now\n') # if not, print that to console
      install.packages(package_name, dependencies = TRUE) # and install it
    }
  }
  
  
  #####################
  # check and print out whether all packages are installed
  #####################
  
  packages_installed = installed.packages()[,"Package"] # now update the list of installed packages
  all_packages_needed = packages_needed # combining two vectors
  
  count = 0 # use this count to keep track if all necessary packages are installed
  for(package_name in all_packages_needed){
    if(!(package_name %in% packages_installed)){
      cat('package',package_name,'missing\n')
    } else{
      count = count + 1
    }
  }
  if(count == length(all_packages_needed)){
    print('all packages have been successfully installed')
    finished = TRUE
  }else{
    print('not all packages installed. please run the whole script again.')
    print('------------------------')
    print('running again')
    print('------------------------')
  }
  n_runs = n_runs + 1
  if(n_runs == 10){
    finished = TRUE
    print('Tried installing 10 times. There is a problem. Get help.')
  }
}
