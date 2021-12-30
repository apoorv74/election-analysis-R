
# Source files ------------------------------------------------------------
source("code/source-libraries.R")

# Leaflet Options ---------------------------------------------------------
leaflet(options = leafletOptions(minZoom = 7, maxZoom = 18))

# Generate colour palette

# DataWrapper colours
# c("#0b91a7","#f6d500","#00cabd")

map_colour_palette <-
  paletteer::paletteer_d("basetheme::clean") %>% as.vector()
