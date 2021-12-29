# This script is used to create a master file of variables at a PC level
# and include standardised PC names from the DataMeet file. The PC level file
# exported from here will be used to create maps and charts for the analysis.

# Import libraries --------------------------------------------------------

source("code/source-libraries.R")

# Read raw files ----------------------------------------------------------

constituency_data <- readr::read_csv("data/processed/constituency_master.csv", col_types = cols())

# Create a PC level file with selected variables --------------------------

cols_to_explore <-
  c(
    "state_name",
    "constituency_name",
    "sheet",
    "elector_General_m",
    "elector_General_w",
    "voter_General_m",
    "voter_General_w",
    "candidate_Contested_m",
    "candidate_Contested_w",
    "voter_POLLING PERCENTAGE_total",
    "result_margin",
    "votes_Total Valid Votes Polled"
  )
constituency_sub <- constituency_data[,cols_to_explore]

candidate_profile_data <- readr::read_csv("data/processed/candidate_profile_data.csv", col_types = cols())

# Process constituency file ---------------------------------------------------------
# 1. Clean up constituency name
# 2. Create an additional column for type of constituency (Caste wise breakup)
# 3. Create a country column
# 4. Assign an ID to each row

# Certain constituency names can contain a "-". The use of the max function will ensure that we're selecting the last "-" always. 
constituency_sub$hypehn_pos <-
  stringr::str_locate_all(constituency_sub$constituency_name, pattern = "-") %>%
  purrr::map(max) %>%
  as.numeric()

constituency_sub$constituency_name_updated <-
  stringr::str_sub(
    constituency_sub$constituency_name,
    start = 1,
    end = constituency_sub$hypehn_pos - 1
  ) %>% stringr::str_trim()

constituency_sub$constituency_type_updated <-
  stringr::str_sub(
    string = constituency_sub$constituency_name,
    start = constituency_sub$hypehn_pos + 1,
    end = nchar(constituency_sub$constituency_name)
  )

constituency_sub$country <- "IN"
constituency_sub$id <- 1:nrow(constituency_sub)
constituency_sub$hypehn_pos <- NULL

# Standardising geogrpahies -----------------------------------------------

# The `eci_geographies_standard` file was created by matching the 
# constituency names parliamentary shape file (downloaded from DataMeet) 
# and the constituency names present in the dataset downloaded from the 
# ECI website. Please refer to `geography-matching.R` to check the code for
# updating the names.

standard_geograhies <-
  readr::read_csv("data/gis/eci_geographies_standard.csv", 
                  col_types = cols())

# Merging the constituency data file with the standardised geogrpahies file
# so that we can include the standard geographies in the data file. The 
# standard geography column names are state_name_dm and constituency_name_dm
# where dm is short for DataMeet.

constituency_sub <-
  left_join(constituency_sub,
            standard_geograhies[, c("id", "state_name_dm", "constituency_name_dm")],
            by = "id")


# Create gender vote variables --------------------------------------------

# Note: The analysis only considers general votes. Other categories are Overseas,
# Proxy, Postal.

# 1. Constituencies where women votes are more than men votes 

constituency_sub$flag_more_women <-
  ifelse(constituency_sub$voter_General_w > constituency_sub$voter_General_m,
         "w",
         "m")

# 2. Constituencies where the percentage of eligible women vote 
# is higher than percentage of eligible men vote

constituency_sub$eligible_vote_w <- constituency_sub$voter_General_w/constituency_sub$elector_General_w
constituency_sub$eligible_vote_m <- constituency_sub$voter_General_m/constituency_sub$elector_General_m
constituency_sub$flag_eligible_women <-
  ifelse(constituency_sub$eligible_vote_w > constituency_sub$eligible_vote_m,
         "w",
         "m")

# 3. At-least one women contested from constituency

constituency_sub$flag_contested_w <-
  ifelse(constituency_sub$candidate_Contested_w > 0,
         "yes",
         "no")

# 4. Constituencies where the ratio of women to men candidates
# is at-least 40%

constituency_sub$flag_contested_w_40 <-
  ifelse(
    constituency_sub$candidate_Contested_w / (
      constituency_sub$candidate_Contested_w + constituency_sub$candidate_Contested_m
    ) > 0.3,
    "yes",
    "no"
  )


# Polling percentage  ----------------------------------------------
polling_percent_index <- which(names(constituency_sub) == "voter_POLLING PERCENTAGE_total")
names(constituency_sub)[polling_percent_index] <- "polling_percentage"


# Vote margin variables ---------------------------------------------------
# To check the PC's where there was a tight competition between candidates.

constituency_sub$margin_ratio <-
  constituency_sub$result_margin / constituency_sub$`votes_Total Valid Votes Polled` * 100

# Candidate profile variables ---------------------------------------------

# 1. Median age of candidates for constituencies

pc_wise_age <-
  candidate_profile_data %>% 
  group_by(`State Name`, `PC NAME`) %>% 
  summarise(median_age = median(AGE,na.rm = TRUE))

# 2. Candidate caste distribution for constituencies

pc_wise_category <- 
  candidate_profile_data %>% 
  group_by(`State Name`, `PC NAME`,CATEGORY) %>% 
  summarise(total_candidates = n())
pc_wise_category <- pc_wise_category[!is.na(pc_wise_category$CATEGORY),]

pc_wise_category_wide <-
  pc_wise_category %>%
  tidyr::pivot_wider(names_from = CATEGORY,
                     values_from = total_candidates,
                     values_fill = 0)

# Merging age and category variables at PC level

candidate_pc <- left_join(pc_wise_age, pc_wise_category_wide, by=NULL) 

# Merging with the constituency sub file
constituency_sub$state_name_updated <-
  stringr::str_sub(constituency_sub$state_name,
                   start = 1,
                   end = (nchar(constituency_sub$state_name) - 4)) %>% 
  stringr::str_trim()

constituency_sub <-
  left_join(
    constituency_sub,
    candidate_pc,
    by = c(
      "state_name_updated" = "State Name",
      "constituency_name_updated" = "PC NAME"
    )
  )

# Creating age buckets to plot on the map
constituency_sub$median_age_bucket <-
  findInterval(
    x = constituency_sub$median_age,
    vec = c(35, 45, 55, 65, 75),
    rightmost.closed = TRUE
  )


# Export file -------------------------------------------------------------
readr::write_csv(constituency_sub, "data/processed/constituency_analysis_file.csv")

