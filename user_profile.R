# ---------------------------------------
# This script sets up the environment to 
# ensure the project runs on any machine
# ---------------------------------------

# 1. Install and Load required packages
packages <- c("here", "dplyr", "ggplot2", "readxl", "readr", "tidyr", "rmarkdown", "remotes", "rsdmx")

installed <- rownames(installed.packages())
to_install <- setdiff(packages, installed)
if (length(to_install)) install.packages(to_install)
lapply(packages, library, character.only = TRUE)

# Install and load the rsdmx package (if the previous installation didn't work via remotes)
if (!require("rsdmx", character.only = TRUE)) {
  remotes::install_github("opensdmx/rsdmx")
  library(rsdmx)
}

# 2. Define project structure
scripts_path <- here("scripts")
data_path <- here("data")
output_path <- here("documentation")

message("Environment ready.")