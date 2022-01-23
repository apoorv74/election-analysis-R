
# Read libraries ----------------------------------------------------------

source("code/source-libraries.R")

# Declare file paths ------------------------------------------------------

constituency_master_path <- "data/raw/constituency-data-summary.xls"

## To list all sheets in the excel file
all_sheets <- readxl::excel_sheets(path = "data/raw/constituency-data-summary.xls")

# Process data from one sheet ---------------------------------------------

get_sheet_data <- function(sheet, path){
  print(glue::glue("{sheet}/n"))
  sheet_raw <- readxl::read_excel(sheet = sheet, path = path) %>% data.frame()
  state_name <- sheet_raw[1,2]
  constituency_name <- sheet_raw[1,4]
  number_of_polling_stations <- sheet_raw[33,4]
  dates_polling <- sheet_raw[36,4]
  dates_counting <- sheet_raw[36,5]
  dates_results <- sheet_raw[36,6]
  result_winner_name <- sheet_raw[39,5]
  result_winner_party <- sheet_raw[39,4]
  result_winner_votes <- sheet_raw[39,6]
  result_runner_up_name <- sheet_raw[40,5]
  result_runner_up_party <- sheet_raw[40,4]
  result_runner_up_votes <- sheet_raw[40,6]
  result_margin <- sheet_raw[41,4]

  # Rows to select for each data point
  candidate_rows <- 3:7
  elector_rows <- 9:12
  voter_rows <- 14:20
  votes_rows <- 22:31

  # Candidate Info
  candidate_cols <- sheet_raw[candidate_rows,2]
  candidate_cols_value_men <- sheet_raw[candidate_rows,4]
  candidate_cols_value_women <- sheet_raw[candidate_rows,5]
  candidate_cols_value_third <- sheet_raw[candidate_rows,6]
  candidate_cols_value_total <- sheet_raw[candidate_rows,7]
  candidate_cols_all <- paste0("candidate","_",candidate_cols,"_",
                               c(rep("m",length(candidate_cols)),
                                 rep("w",length(candidate_cols)),
                                 rep("t",length(candidate_cols)),
                                 rep("total",length(candidate_cols))
                                 ))
  candidate_values_all <-
    c(
      candidate_cols_value_men,
      candidate_cols_value_women,
      candidate_cols_value_third,
      candidate_cols_value_total
    )

  # Electors Info
  elector_cols <- sheet_raw[elector_rows,2]
  elector_cols_value_men <- sheet_raw[elector_rows,4]
  elector_cols_value_women <- sheet_raw[elector_rows,5]
  elector_cols_value_third <- sheet_raw[elector_rows,6]
  elector_cols_value_total <- sheet_raw[elector_rows,7]
  elector_cols_all <- paste0("elector","_",elector_cols,"_",
                             c(rep("m",length(elector_cols)),
                               rep("w",length(elector_cols)),
                               rep("t",length(elector_cols)),
                               rep("total",length(elector_cols))
                             ))

  elector_values_all <-
    c(
      elector_cols_value_men,
      elector_cols_value_women,
      elector_cols_value_third,
      elector_cols_value_total
    )


  # Voter Info
  voter_cols <- sheet_raw[voter_rows,2]
  voter_cols_value_men <- sheet_raw[voter_rows,4]
  voter_cols_value_women <- sheet_raw[voter_rows,5]
  voter_cols_value_third <- sheet_raw[voter_rows,6]
  voter_cols_value_total <- sheet_raw[voter_rows,7]
  voter_cols_all <- paste0("voter","_",voter_cols,"_",
                           c(rep("m",length(voter_cols)),
                             rep("w",length(voter_cols)),
                             rep("t",length(voter_cols)),
                             rep("total",length(voter_cols))
                           ))

  voter_values_all <-
    c(
      voter_cols_value_men,
      voter_cols_value_women,
      voter_cols_value_third,
      voter_cols_value_total
    )

  # Votes Info
  votes_cols <- sheet_raw[votes_rows,2]
  votes_cols_value_total <- sheet_raw[votes_rows,7]
  votes_cols_all <- paste0("votes","_",votes_cols)

  all_cols <-
    c(
      "state_name",
      "constituency_name",
      "number_of_polling_stations",
      "dates_polling",
      "dates_counting",
      "dates_results",
      "result_winner_name",
      "result_winner_party",
      "result_winner_votes",
      "result_runner_up_name",
      "result_runner_up_party",
      "result_runner_up_votes",
      "result_margin",
      candidate_cols_all,
      elector_cols_all,
      voter_cols_all,
      votes_cols_all)

  all_values <-
    c(
      state_name,
      constituency_name,
      number_of_polling_stations,
      dates_polling,
      dates_counting,
      dates_results,
      result_winner_name,
      result_winner_party,
      result_winner_votes,
      result_runner_up_name,
      result_runner_up_party,
      result_runner_up_votes,
      result_margin,
      candidate_values_all,
      elector_values_all,
      voter_values_all,
      votes_cols_value_total
    )

  constituency_df <- data.frame(t(all_values))
  names(constituency_df) <- all_cols
  return(constituency_df)
}


# Process all sheets ------------------------------------------------------

constituency_master_df <-
  constituency_master_path %>%
  excel_sheets() %>%
  map_df(get_sheet_data, path = constituency_master_path,.id="sheet")


# Export file -------------------------------------------------------------

readr::write_csv(constituency_master_df, "data/processed/constituency_master.csv")
