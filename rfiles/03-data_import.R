# The following code is taken from the third chapter of the online script, which provides more detailed explanations:
# https://imsmwu.github.io/MRDA2017/_book/data-import-and-export.html


#-------------------------------------------------------------------#
#---------------------Install missing packages----------------------#
#-------------------------------------------------------------------#

# At the top of each script this code snippet will make sure that all required packages are installed
## ------------------------------------------------------------------------
req_packages <- c("rvest", "jsonlite", "readxl", "haven", "devtools")
req_packages <- req_packages[!req_packages %in% installed.packages()]
lapply(req_packages, install.packages)
library(devtools)
devtools::install_github('PMassicotte/gtrendsR', force = TRUE)


#-------------------------------------------------------------------#
#-------------------Getting data for this course--------------------#
#-------------------------------------------------------------------#

# read.table can be used to read data from sites (as done here) or from local files.
test_data <- read.table("https://raw.githubusercontent.com/IMSMWU/Teaching/master/MRDA2017/test_data.dat", 
                        sep = "\t", 
                        header = TRUE)

# If test_file is in your working directory, this would be the way to import it.
## test_data <- read.table(test_file, header=TRUE)


#-------------------------------------------------------------------#
#----------Import data created by other software packages-----------#
#-------------------------------------------------------------------#

# Reading excel files can be done with the readxl package.
## ------------------------------------------------------------------------
#before you can read data, make sure that the file is located in your working directory
getwd() #tells you the current working directory
list.files() #lists all files in the current working directory
setwd("path/to/file") #may be used to change the working directory to the folder that contains the desired file

#import excel files
library(readxl) #load package to import Excel files
excel_sheets("test_data.xlsx")
test_data_excel <- read_excel("test_data.xlsx", sheet = "mrda_2016_survey") # "sheet = x"" specifies which sheet to import
head(test_data_excel)
 
library(haven) #load package to import SPSS files
#import SPSS files
test_data_spss <- read_sav("test_data.sav")
head(test_data_spss)


#-------------------------------------------------------------------#
#----------------------------Export data----------------------------#
#-------------------------------------------------------------------#

# Writing data to the working directory is often as easy as exchanging "read" with "write".
## ------------------------------------------------------------------------
## write.table(test_data, "testData.dat", row.names = FALSE, sep = "\t") #writes to a tab-delimited text file
## write.table(test_data, "testData.csv", row.names = FALSE, sep = ",") #writes to a comma-separated value file
## write_sav(test_data, "my_file.sav") #writes to a SPSS file


#-------------------------------------------------------------------#
#-------------------Import data data from the Web-------------------#
#-------------------------------------------------------------------#

# Web scraping can be used to quickly access online data
# Here we scrape population data from Wikipedia
## ------------------------------------------------------------------------
library(rvest)
url <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"
population <- read_html(url) 
population <- html_nodes(population, "table")
print(population)

population <- html_table(population[[1]], fill = TRUE)
head(population) #checks if we scraped the desired data

class(population$Population) #check class of population variable

population$Population <- as.numeric(gsub(",", "", population$Population)) #convert to numeric
head(population) 

class(population$Population) #check class of population variable

# Many websites have APIs, with which you can directly access data
# Here population data from the World Bank is downloaded by the jsonlite package
## ------------------------------------------------------------------------
library(jsonlite)
url <- "http://api.worldbank.org/countries/AT/indicators/SP.POP.TOTL/?date=1960:2016&format=json&per_page=100" #specifies url
ctrydata <- fromJSON(url) #parses the data 
str(ctrydata)
head(ctrydata[[2]][,c("value","date")]) #checks if we scraped the desired data

# Many R packages exist that let you scrape data from websites
# Here Google Trends data for the term "data science" is obtained using the "gtrendsR" package

library(gtrendsR)
google_trends <- gtrends("data science", geo = c("US"), 
                         gprop = c("web"), time = "2017-09-01 2017-10-06")

ls(google_trends) # list all elements of the returned list

head(google_trends$interest_over_time)
