# Celiac app global with packages and data
# Contributor: Lindsay Hracs
# Date: 06-Dec-22
# R version 4.1.2
# Running on macOS Monterey 12.1

# load libraries
library(rsconnect) # version 0.8.18
library(shiny) # version 1.6.0
library(shinyjs) # show/hide function
library(shinythemes) # version 1.2.0
library(shinyWidgets)
library(DT) # version 0.18
library(tidyverse) # version 0.18
library(ggtext) # version 0.1.1; HTML in ggplots
library(ggiraph)
library(viridis)
library(plotly)
library(reshape2)
library(shinycssloaders)
library(leaflet) # version 2.0.4.1
library(leaflet.esri)
library(leaflet.extras)
library(sf)
library(geojsonsf)
library(fontawesome)
library(readxl)

# laod data

# incidence and prevalence for province, zone, and HSA
path = "https://raw.githubusercontent.com/kaplan-gi/CAVE/main/"

inc_prov <- read.csv(paste0(path,"Provincial_Map_CDA_Incidence_2022-07-11.csv"), header = T)
inc_zone <- read.csv(paste0(path,"Zone_Map_CDA_Incidence_2022-11-22.csv"), header = T)
inc_HSA <- read.csv(paste0(path,"HSA_Map_CDA_Incidence_2022-11-22.csv"), header = T)

test_prov <- read.csv(paste0(path,"Provincial_Map_TTG_Testing_2022-08-12.csv"), header = T)
test_zone <- read.csv(paste0(path,"Zone_Map_TTG_Testing_2022-11-22.csv"), header = T)
test_HSA <- read.csv(paste0(path,"HSA_Map_TTG_Testing_2022-11-22.csv"), header = T)

indiv_prov <- read.csv(paste0(path,"Provincial_Map_TTG_Individual_Testing_2022-09-16.csv"), header = T)
indiv_zone <- read.csv(paste0(path,"Zone_Map_TTG_Individual_Testing_2022-09-16.csv"), header = T)
indiv_HSA <- read.csv(paste0(path,"HSA_Map_TTG_Individual_Testing_2022-11-24.csv"), header = T)

# geofiles

can <- geojson_sf(paste0(path,"canada_prov_terr.json"))
zones <- geojson_sf(paste0(path,"Zone.geojson"))
HSAs <- geojson_sf(paste0(path,"HSA.geojson"))

# time series data

# time <- read.csv("https://raw.githubusercontent.com/kaplan-gi/Map_Data/main/TimeSeriesData.csv")
# monthly <- read.csv("https://raw.githubusercontent.com/kaplan-gi/Map_Data/main/AverageMonthlyPercentChanges.csv")

# time_obs <- read.csv("~/Dropbox/COVID_ShinyApp/Celiac/Data/Temporal_Incidence.csv")
time_obs <- read.csv(paste0(path,"Temporal_Incidence.csv"))
#time_trends <- read.csv(paste0(path, "Temporal_Incidence_Trends.csv"))
time_trends <- read.csv("~/Dropbox/COVID_ShinyApp/Celiac/Data/Temporal_Incidence_Trends.csv")

# data prep

# create prov, zone, and HSA data frames

inc_prov_data <- inner_join(can, inc_prov, by = "name")
inc_zone_data <- inner_join(zones, inc_zone, by = "ZONE_NAME")
inc_HSA_data <- inner_join(HSAs, inc_HSA, by = "HSA_NAME")
test_prov_data <- inner_join(can, test_prov, by = "name")
test_zone_data <- inner_join(zones, test_zone, by = "ZONE_NAME")
test_HSA_data <- inner_join(HSAs, test_HSA, by = "HSA_NAME")
indiv_prov_data <- inner_join(can, indiv_prov, by = "name")
indiv_zone_data <- inner_join(zones, indiv_zone, by = "ZONE_NAME")
indiv_HSA_data <- inner_join(HSAs, indiv_HSA, by = "HSA_NAME")

inc_zone_data_met <- subset(inc_zone_data, MET == "yes")
inc_HSA_data_met <- subset(inc_HSA_data, MET == "yes")
test_zone_data_met <- subset(test_zone_data, MET == "yes")
test_HSA_data_met <- subset(test_HSA_data, MET == "yes")
indiv_zone_data_met <- subset(indiv_zone_data, MET == "yes")
indiv_HSA_data_met <- subset(indiv_HSA_data, MET == "yes")

inc_zone_data_nonmet <- subset(inc_zone_data, MET == "no")
inc_HSA_data_nonmet <- subset(inc_HSA_data, MET == "no")
test_zone_data_nonmet <- subset(test_zone_data, MET == "no")
test_HSA_data_nonmet <- subset(test_HSA_data, MET == "no")
indiv_zone_data_nonmet <- subset(indiv_zone_data, MET == "no")
indiv_HSA_data_nonmet <- subset(indiv_HSA_data, MET == "no")


# data for 3D plots

years_3D <- read.csv(paste0(path,"3D_Age_Sex_Testing_Incidence_2022-10-17.csv"), header = T)
bands_3D <- read.csv(paste0(path,"3D_AgeBands_Sex_Testing_Incidence_2022-10-17.csv"), header = T)
years_3D$SEX <- recode_factor(years_3D$SEX, "F" = "Female", "M" = "Male")
bands_3D$SEX <- recode_factor(bands_3D$SEX, "F" = "Female", "M" = "Male")
dataF_years <- subset(years_3D, SEX == "Female")
dataM_years <- subset(years_3D, SEX == "Male")
dataF_bands <- subset(bands_3D, SEX == "Female")
dataM_bands <- subset(bands_3D, SEX == "Male")

# create columns with distance values for error array which uses distance not axis value; lower CI = upper CI

years_3D[,"lowerCI_inc"] <- years_3D$INCIDENCE_RT - years_3D$INCIDENCE_L95
years_3D[,"upperCI_inc"] <- years_3D$INCIDENCE_U95 - years_3D$INCIDENCE_RT
years_3D[,"lowerCI_test"] <- years_3D$TEST_RT - years_3D$TEST_L95
years_3D[,"upperCI_test"] <- years_3D$TEST_U95 - years_3D$TEST_RT
dataF_years[,"lowerCI"] <- dataF_years$INCIDENCE_RT - dataF_years$INCIDENCE_L95
dataF_years[,"upperCI"] <- dataF_years$INCIDENCE_U95 - dataF_years$INCIDENCE_RT
dataM_years[,"lowerCI"] <- dataM_years$INCIDENCE_RT - dataM_years$INCIDENCE_L95
dataM_years[,"upperCI"] <- dataM_years$INCIDENCE_U95 - dataM_years$INCIDENCE_RT

bands_3D[,"lowerCI_inc"] <- bands_3D$INCIDENCE_RT - bands_3D$INCIDENCE_L95
bands_3D[,"upperCI_inc"] <- bands_3D$INCIDENCE_U95 - bands_3D$INCIDENCE_RT
bands_3D[,"lowerCI_test"] <- bands_3D$TEST_RT - bands_3D$TEST_L95
bands_3D[,"upperCI_test"] <- bands_3D$TEST_U95 - bands_3D$TEST_RT
dataF_bands[,"lowerCI"] <- dataF_bands$INCIDENCE_RT - dataF_bands$INCIDENCE_L95
dataF_bands[,"upperCI"] <- dataF_bands$INCIDENCE_U95 - dataF_bands$INCIDENCE_RT
dataM_bands[,"lowerCI"] <- dataM_bands$INCIDENCE_RT - dataM_bands$INCIDENCE_L95
dataM_bands[,"upperCI"] <- dataM_bands$INCIDENCE_U95 - dataM_bands$INCIDENCE_RT

# transform average monthly change data

# colnames(monthly) <- c("period", "measure", "AMC", "AMClower", "AMCupper")

# loop over rows and extract parts of period range if needed

# initialize new columns
# monthly[c("per_start", "per_end")] <- NA
# 
# for (row in 1:nrow(monthly)) {
#     split <- str_split_fixed(monthly[row, "period"], " - ", n = 2)
#     monthly[row, "per_start"] <- str_replace_all(split[1], " ", ". ")
#     monthly[row, "per_end"] <- str_replace_all(split[2], " ", ". ")
# }
# 
# monthly_inc <- monthly %>%
#     filter(measure == "Incidence") %>%
#     mutate(ch_dir = ifelse(AMC < 0, "decreasing", "increasing"))
# 
# monthly_test <- monthly %>%
#     filter(measure == "Testing") %>%
#     mutate(ch_dir = ifelse(AMC < 0, "decreasing", "increasing"))
# 
# # transform time series data
# 
# time_inc <- time[, c(1, 10:17)]
# colnames(time_inc) <- c("date", "rate", "lower", "upper", "forecast", "lo80", "hi80", "lo95", "hi95")
# time_inc <- time_inc %>%
#     filter(!is.na(rate)) %>%
#     mutate(type = "inc",
#            date = as.Date(date, format = "%d-%b-%y"),
#            period = ifelse(date <= as.Date("31-Dec-2019", format = "%d-%b-%Y"), "Apr 2015 - Jan 2020",
#                            ifelse(date >= as.Date("01-Jan-2020", format = "%d-%b-%Y") & date <= as.Date("31-Mar-2020", format = "%d-%b-%Y"), "Jan 2020 - Apr 2020", "Apr 2020 - Mar 2023"))
#            )
# 
# time_inc <- merge(time_inc, monthly_inc, by = "period")
# 
# time_inc <- time_inc %>%
#     arrange(date) # need to sort in order of date for line plot
# 
# time_test <- time[, c(1:9)]
# colnames(time_test) <- c("date", "rate", "lower", "upper", "forecast", "lo80", "hi80", "lo95", "hi95")
# time_test <- time_test %>%
#     filter(!is.na(rate)) %>%
#     mutate(type = "test",
#            date = as.Date(date, format = "%d-%b-%y"),
#            period = ifelse(date <= as.Date("31-Jan-2020", format = "%d-%b-%Y"), "Apr 2012 - Feb 2020",
#                            ifelse(date >= as.Date("01-Feb-2020", format = "%d-%b-%Y") & date <= as.Date("30-Apr-2020", format = "%d-%b-%Y"), "Feb 2020 - May 2020",
#                                   ifelse(date >= as.Date("01-May-2020", format = "%d-%b-%Y") & date <= as.Date("31-Jul-2020", format = "%d-%b-%Y"), "May 2020 - Aug 2020", "Aug 2020 - Mar 2023")))
#            )
# 
# time_test <- merge(time_test, monthly_test, by = "period")
# 
# time_test <- time_test %>%
#     arrange(date) # need to sort in order of date for line plot


# format time trend x-axis as a date
#time_obs$x = as.Date(time_obs$x, format = "%Y/%m/%d")

time_obs <- time_obs %>% 
  mutate(x = as.Date(x, format = "%Y/%m/%d")) %>% 
  mutate(x = x %m+% months(1))

# options

options(spinner.color="#52D6F4")#, warn = -1)
