
# Source libraries --------------------------------------------------------

source("code/source-libraries.R")

# Read PC shapefile (geojson) ---------------------------------------------

pc_shapefile <-
  sf::read_sf("data/gis/india_pc_2019_simplified.geojson")
pc_shapefile$pc_name <-
  pc_shapefile$pc_name %>% stringr::str_trim() %>% stringr::str_to_lower()
pc_shapefile$st_name <-
  pc_shapefile$st_name %>% stringr::str_trim() %>% stringr::str_to_lower()

constituency_analysis_file <-
  readr::read_csv("data/processed/constituency_analysis_file.csv",
                  col_types = cols())

# Merge with PC shapefile -------------------------------------------------

constituency_map_file <-
  inner_join(
    constituency_analysis_file,
    pc_shapefile,
    by = c(
      "state_name_dm" = "st_name",
      "constituency_name_dm" = "pc_name"
    )
  )

# Using st_as_sf to convert dataframw to an sf object
# Reference: https://stackoverflow.com/questions/49181715/how-to-make-a-data-frame-into-a-simple-features-data-frame

constituency_map_file <- sf::st_as_sf(constituency_map_file)
