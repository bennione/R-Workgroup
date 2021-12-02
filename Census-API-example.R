#Load ACS data using the Census API --------------

#This program loads ACS data through the Census API for GINI index, a measure of income inequality

#Note: All services, which utilize or access the Census API, should display the following notice prominently within the application: "This product uses the Census Bureau Data API but is not endorsed or certified by the Census Bureau." 
#https://cran.r-project.org/web/packages/censusapi/vignettes/getting-started.html

#Packages
library(httr)
library(jsonlite)
library(tidyverse)

#Functions
#The convert_df fn takes json data from the api and converts to a data frame. It also converts all variables to numeric and replaces missing values that were coded as things like -22222 to NA
convert_df <- function(api) {
  df <- as.data.frame(fromJSON(rawToChar(api$content)))
}
#Note: The step of converting to data.frame depends on the Content-Type. This code assumes Content-Type = "application/json;charset=utf-8" or "application/json"

#Income Inequality ---------------
#The following API pulls from this data table: https://data.census.gov/cedsci/table?q=ACSDT5Y2017.B19083&g=0400000US49.860000&tid=ACSDT5Y2019.B19083&hidePreview=true
gini <-
  GET(
    "https://api.census.gov/data/2019/acs/acs5?get=B19083_001E,B19083_001M&for=zip%20code%20tabulation%20area:*&in=state:49"
  )
gini #Check that api loaded successfully. Status code should be 200. If it's not, something went wrong.

#Convert to data frame
gini <- convert_df(api = gini)
View(gini)

#Fix column names
colnames(gini) <- c("GINI_est", "GINI_moe", "State", "ZCTA")
#Remove first row
gini <- gini[-1,]
  