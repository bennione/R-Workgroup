#Survey procedures using BRFSS data
#Created 6/24 by Erica Bennion
#Last Updated 7/22 by Erica Bennion

#Packages used ------------
library(tidyverse)
library(haven)
library(survey)
library(summarytools)

#File location ------------
folder <- "G:/BHP/BHP_projects/BRFSS Data/"

#Read in data ------------
brfss <- read_sas(paste0(folder, "y19cdc.sas7bdat"))
attach(brfss)

#Simplest frequency table in R (no packages required)
table(rsmoke)
table(rsmoke, useNA = "always")

#Weighted frequencies and cross tabs with the summarytools package ------------
freq(rsmoke, weights = `_LLCPWT`)
ctable(rsmoke, `_SEX`, weights = `_LLCPWT`)

#Weighted frequencies and cross tabs with the survey package ------------

#First specify the design effect
dsn <- svydesign(id = ~`_PSU`, strata = ~`_STSTR`, weights = ~`_LLCPWT`, data = brfss, nest = T)

#Descriptive analyses
svymean(~AGE, design=dsn, na.rm=T) #If there are missing data, you'll need the na.rm=T option
svymean(~DRNK3GE5 + AGE, design=dsn, na.rm=T) #If you want multiple means, separate them with +
mean(AGE) #without accounting for survey design

#Smoking status by sex
svytable(~rsmoke + `_SEX`, design=dsn) #Counts
svytable(~rsmoke + `_SEX`, Ntotal=sex_freq, design=dsn) #Percent
svyby(~rsmoke, by = `_SEX`, design = dsn, FUN = svytable)


