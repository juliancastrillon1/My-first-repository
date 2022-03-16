pacman::p_load(
  rio,        # importing data  
  here,       # relative file pathways  
  janitor,    # data cleaning and tables
  lubridate,  # working with dates
  epikit,     # age_categories() function
  tidyverse   # data management and visualization
)

linelist_raw <- import("./data/raw/linelist_raw.xlsx")

head(linelist_raw,20)

skimr::skim(linelist_raw)
