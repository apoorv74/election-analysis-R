
# Source files ------------------------------------------------------------

source("code/source-libraries.R")

# Read DataMeet file ------------------------------------------------------

pc_shapefile <-
  geojsonsf::geojson_sf("data/gis/india_pc_2019_simplified.geojson")
pc_shapefile$pc_name <-
  pc_shapefile$pc_name %>% stringr::str_trim() %>% stringr::str_to_lower()
pc_shapefile$st_name <-
  pc_shapefile$st_name %>% stringr::str_trim() %>% stringr::str_to_lower()

dm_list <- pc_shapefile %>% data.frame() %>% select(c("st_name","pc_name"))


# Read constituency master file -------------------------------------------

constituency_data <-
  readr::read_csv("data/processed/constituency_master.csv", col_types = cols())

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

# Process constituency file ---------------------------------------------------------

# 1. Clean up state name
# 2. Clean up constituency name
# 3. Create an additional column for type of constituency (Caste wise breakup)
# 4. Create a country column
# 5. Assign an ID to each row

constituency_sub$state_name_updated <-
  stringr::str_sub(constituency_sub$state_name,
                   start = 1,
                   end = (nchar(constituency_sub$state_name) - 4)) %>%
  stringr::str_trim()

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


# Export constituency sub file --------------------------------------------

readr::write_csv(constituency_sub, "data/processed/constituency_sub.csv")


# Update constituency list in the ECI file --------------------------------

eci_list <- constituency_sub[,c("id","state_name","constituency_name_updated")] %>% unique()
eci_list$state_name_updated <-
  substr(eci_list$state_name,
         start = 1,
         stop = nchar(eci_list$state_name) - 4) %>% stringr::str_to_lower() %>% stringr::str_trim()
eci_list$constituency_name_updated_2 <-
  eci_list$constituency_name_updated %>% stringr::str_to_lower() %>% stringr::str_trim()

eci_list$state_name_updated[eci_list$state_name_updated == "odisha"] <- "orissa"
eci_list$state_name_updated[eci_list$state_name_updated == "nct of delhi"] <- "delhi"
eci_list$state_name_updated[eci_list$state_name_updated == "andaman & nicobar islands"] <- "andaman and nicobar"


eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "aruku"] <- "araku"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "anantapur"] <- "anantapuramu"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "gopalganj (sc)"] <- "gopalganj"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "hajipur (sc)"] <- "hajipur"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "samastipur (sc)"] <- "samastipur"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "sasaram (sc)"] <- "sasaram"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "gaya (sc)"] <- "gaya"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "jamui (sc)"] <- "jamui"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "chikkodi"] <- "chikodi"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "belgaum"] <- "belagavi"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "davanagere"] <- "davangere"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "hassan"] <- "haasan"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "chikkballapur"] <- "chikballapur"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "mavelikkara"] <- "mavelikara"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "mandsour"] <- "mandsaur"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "bhandara - gondiya"] <- "bhandara-gondiya"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "mumbai south central"] <- "mumbai south central"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "mumbai   south"] <- "mumbai south"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "ahmadnagar"] <- "ahmednagar"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "ratnagiri - sindhudurg"] <- "ratnagiri-sindhudurg"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "firozpur"] <- "firozepur"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "bikaner (sc)"] <- "bikaner"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "mayiladuthurai"] <- "mayiladuturai"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "thoothukkudi"] <- "thoothukudi"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "kanniyakumari"] <- "kanyakumari"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "srerampur"] <- "sreerampur"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "bardhaman durgapur"] <- "bardhaman-durgapur"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "sarguja"] <- "surguja"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "janjgir-champa"] <- "janjgir"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "palamau"] <- "palamu"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "hardwar"] <- "haridwar"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "peddapalle"] <- "peddapalli"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "secundrabad"] <- "secunderabad"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "mahbubnagar"] <- "mahabubnagar"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "bhongir"] <- "bhuvanagiri"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "andaman & nicobar islands"] <- "andaman and nicobar islands"
eci_list$constituency_name_updated_2[eci_list$constituency_name_updated_2 == "daman & diu"] <- "daman and diu"

names(eci_list)[] <-
  c("id",
    "state_name",
    "constituency_name",
    "state_name_dm",
    "constituency_name_dm")

readr::write_csv(eci_list,"data/gis/eci_geographies_standard.csv")


# To check if all geographies match ---------------------------------------

# dm_list_check <-
#   left_join(
#     keep = FALSE,
#     dm_list,
#     eci_list,
#     by = c("st_name" = "state_name_dm",
#            "pc_name" = "constituency_name_dm")
#   )
