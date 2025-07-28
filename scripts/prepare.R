# ------------------------------------------------
# Script that preprocessing the data and estimate
# the population weighted average for ANC4 and SBA
# -------------------------------------------------


# libraries
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

# 1. Ingest the required data for the estimation (all data are located in the data/ directory)
#   - The demographic data were downloaded, all other data were provided for the assessment

global_data <- read_excel("data/GLOBAL_DATAFLOW_2018-2022.xlsx")
countries_data <- read_excel("data/On-track and off-track countries.xlsx")
demo_data <- read_excel("data/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx", sheet="Projections",skip=16)


# 2. Preprocessing

# 2.1 Clean and treat the global data:
#   - Rename variables, identify the type of each variable, 
#   - There is some duplicates values (no reason why). Only regions (no countries) were duplicates
#   - I keep the first value of duplicate as its only concern regions (not countries) 
#   - Filter estimates between (2018-2022) and use the most recent estimate

# Check duplicated areas
dupli <- global_data[duplicated(global_data[c("Geographic area", "Indicator","TIME_PERIOD")]),]
Area_duplicated <- unique(dupli["Geographic area"])

# Clean the global data and report the ANC4 and SBA per countries
temp0 <- global_data %>%
  select(Area=`Geographic area`, Measure=`Indicator`, Year=`TIME_PERIOD`, Value=`OBS_VALUE`) %>%
  mutate(Year = as.numeric(Year),
         Value = as.numeric(Value)) %>%
  filter(!is.na(Measure)) %>%
  filter(Year>=2018 & Year<=2022) %>%
  distinct(Area, Measure, Year, .keep_all = TRUE) %>%
  pivot_wider(names_from=Measure, values_from=Value) %>%
  group_by(Area) %>%
  slice_max(order_by = Year, n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  select(Area, Year,
         `Antenatal care (ANC4)`=`Antenatal care 4+ visits - percentage of women (aged 15-49 years) attended at least four times during pregnancy by any provider`,
         `Skilled birth attendance (SBA)`=`Skilled birth attendant - percentage of deliveries attended by skilled health personnel`)


# 2.2. Clean the country_data and categorize countries as "On track" and "Off-track"
temp1 <- countries_data %>%
  mutate(Mortality.Target = case_when(
    Status.U5MR == 'Achieved' ~ "On Track",
    Status.U5MR == 'On Track' ~ "On Track",
    Status.U5MR == 'Acceleration Needed' ~ "Off-track")) %>%
    select(Country.Code=`ISO3Code`, Country.Name=`OfficialName`, Mortality.Target)

# 2.3. Clean the demographic data:
#   - Filter the geography to country and the year 2022
#   - Only select the "number of births" variable (variable of interest)
temp2 <- demo_data %>%
  filter((Type=="Country/Area")&(Year==2022)) %>%
  select(Country.Name=`Region, subregion, country or area *`, Births=`Births (thousands)`) %>%
  mutate(Births = as.numeric(Births))
  

# 2.4. Merge all data (only focus on country with data)
#   - Merge all data on country name (we can't merge on year, because we selected the most recent available data)
final_data <- temp1 %>%
  inner_join(temp0, by = c("Country.Name"="Area")) %>%
  inner_join(temp2, by = c("Country.Name"="Country.Name"))
  
# 3. For each category of the Mortality.Target ("On tract" and "Off tract") compute the population-weighted averages of SBA and ANC, 
# weighted by projected birth in 2022
pop_average <- final_data %>%
  group_by(Mortality.Target) %>%
  summarise(
    weighted_avg_ANC4 = sum(`Antenatal care (ANC4)`* Births, na.rm = TRUE) / sum(Births, na.rm = TRUE),
    weighted_avg_SBA = sum(`Skilled birth attendance (SBA)` * Births, na.rm = TRUE) / sum(Births, na.rm = TRUE),
    .groups = "drop"
  )

# 4. Save the final data into rds format 
#   - save the final data and pop_average in csv format; also save the pop_average in rds format

# Ensure a clean folder exists where the final data and the population_weighted data will be saved
if (!dir.exists("data/clean")) dir.create("data/clean", recursive = TRUE)

# CSV format
write.csv(final_data, file = "data/clean/final_data.csv", row.names = FALSE)
write.csv(pop_average, file = "data/clean/weighted_pop_average.csv", row.names = FALSE)

# RDS format
saveRDS(pop_average, "data/clean/weighted_pop_average.rds")




