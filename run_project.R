# ---------------------------------------
# Master script to execute the full analysis workflow
# from data preparation to report generation
# ---------------------------------------

# 2. Ingest data 
ingest_script <- file.path(scripts_path, "ingest_data.R")
if (file.exists(ingest_script)) {
  source(ingest_script)
}

# 3. Preprocess the data and compute the population weighted average 
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

