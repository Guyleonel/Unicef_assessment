# ------------------------------------------------
# Script that ingest data from the UNICEF Warehouse
# using the API.
# -------------------------------------------------

# Load the library
library(rsdmx)

# 1. Retrieve the indicators from the UNICEF Global Data Repository and save to the data folder

# Adapt the url provided using the sdmx
url <- "https://sdmx.data.unicef.org/ws/public/sdmxapi/rest/data/UNICEF,GLOBAL_DATAFLOW,1.0/.MNCH_ANC4+MNCH_SAB.?startPeriod=2018&endPeriod=2022"
sdmx_data <- readSDMX(url)

# Convert to data frame
df <- as.data.frame(sdmx_data)

# 2. Save the data
write.csv(df, "data/unicef_data.csv", row.names = FALSE)


