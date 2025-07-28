# Antenatal Care and Skilled Birth Attendance Analysis
This repository contains the code, data, and documentation for analyzing antenatal care (ANC4) and skilled birth attendance (SBA) across countries, based on their progress toward the under-five mortality targets as defined by the Sustainable Development Goals (SDGs).


## Repository Structure
Unicef_assessment/
├─ documentation/
│  ├─ my_report.html
├─ scripts/
│  ├─ ingest_data.R
│  ├─ output.Rmd
│  ├─ prepare.R
├─ data/
│  ├─ GLOBAL_DATAFLOW_2018-2022.xlsx
│  ├─ On-track and off-track countries.xlsx
│  ├─ WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx
│  ├─ clean
│     ├─ final_data.csv
│     ├─ weighted_pop_average.csv
│     ├─ weighted_pop_average.rds
├─ .gitignore
├─ Unicef_assessment.Rproj
├─ run_project.R
├─ user_profile.R
├─ README.md


## Folder & File Descriptions
- **`data/`**: Stores raw and intermediate data files.
- **`data/clean/`**: Contains cleaned and final data outputs from scripts.
- **`scripts/prepare.Rmd`**: Preprocessing the data and compute the population weighted average for ANC4 and SBA.
- **`scripts/output.Rmd`**: R Markdown report generating the main analysis and visualizations.
- **`documentation/`**: Stores the generated HTML report and related outputs.
- **`run_project.R`**: Automates the entire workflow, from data loading to report generation. Loads required packages, sets paths.
- **`.Rproj`**: RStudio project file for consistent root directory handling using the `{here}` package.
- **`.Rprofile`**: Optional file to auto-source `setup.R` when the project is opened.

---

## How to Reproduce the Analysis

1. **Clone the repository:**

```bash
git clone https://github.com/your-username/your-project.git
cd your-project
```

2. **Open the .Rproj file in RStudio to activate the project environment.**

3. **Run the full analysis workflow:**