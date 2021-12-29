

# Source Librraies --------------------------------------------------------

source("code/source-libraries.R")

# Read raw file -----------------------------------------------------------

candidate_profile_raw <- readxl::read_excel("data/raw/constituency-detailed-results.xls")
col_names <- candidate_profile_raw[2,] %>% unlist()
candidate_profile_data <- candidate_profile_raw[3:(nrow(candidate_profile_raw)-2),]
names(candidate_profile_data)[] <- col_names
candidate_profile_data <- candidate_profile_data[!is.na(candidate_profile_data$`State Name`),]


# Export processed file ---------------------------------------------------
readr::write_csv(candidate_profile_data,"data/processed/candidate_profile_data.csv")

