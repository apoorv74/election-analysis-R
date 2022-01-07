source("code/source-libraries.R")
source("code/merge-data-gis.R")

candidate_data <-
  readr::read_csv("data/processed/candidate_profile_data.csv", col_types = cols())


w_30 <-
  constituency_analysis_file[constituency_analysis_file$flag_contested_w_30 == 'yes', c("state_name_updated", "constituency_name_updated")]

cd_data <- inner_join(
  w_30,
  candidate_data,
  by = c(
    "state_name_updated" = "State Name",
    "constituency_name_updated" = "PC NAME"
  )
)

cd_data <-
  cd_data %>%
  arrange(desc(TOTAL)) %>%
  group_by(state_name_updated, constituency_name_updated) %>%
  mutate(crank = row_number())

cd_win <- cd_data[cd_data$crank == 1,]
readr::write_csv(cd_win,"data/processed/w30_winning_candidates.csv")
