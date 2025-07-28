# ---------------------------------------
# Master script to execute the full analysis workflow
# from data preparation to report generation
# ---------------------------------------

# 1. Load required packages
packages <- c("here", "dplyr", "ggplot2", "readxl", "tidyr","rmarkdown")

installed <- rownames(installed.packages())
to_install <- setdiff(packages, installed)
if (length(to_install)) install.packages(to_install)
lapply(packages, library, character.only = TRUE)

# 2. Define project structure
scripts_path <- here("scripts")
data_path <- here("data")
output_path <- here("documentation")

# 3. Ingest and prepare the data, and compute the population weighted average 
prepare_script <- file.path(scripts_path, "prepare.R")
if (file.exists(prepare_script)) {
  source(prepare_script)
}

# 4. Render the R Markdown report
rmd_input <- file.path(scripts_path, "output.Rmd")
rmd_output <- file.path(output_path, "my_report.html")

message("Rendering report...")
rmarkdown::render(
  input = rmd_input,
  output_file = "my_report.html",
  output_dir = output_path,
  clean = TRUE
)

message("Report generated successfully at: ", rmd_output)

