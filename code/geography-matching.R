
source("code/source-libraries.R")

dm_list <- readr::read_csv("data/gis/constituency-list-datameet.csv")
dm_list$state_name <- stringr::str_replace_all(dm_list$state_name,pattern = "&",replacement = "and") %>% stringr::str_to_lower() %>% stringr::str_trim()
dm_list$constituency_name <- dm_list$constituency_name %>% stringr::str_trim() %>% stringr::str_to_lower()

constituency_sub <- readr::read_csv("data/processed/constituency_analysis_file.csv")
eci_list <- constituency_sub[,c("id","state_name","constituency_name_updated")] %>% unique()
eci_list$state_name_updated <- substr(eci_list$state_name, start = 1,stop = nchar(eci_list$state_name)-4) %>% stringr::str_to_lower() %>% stringr::str_trim()
eci_list$state_name_updated <- stringr::str_replace_all(eci_list$state_name_updated,pattern = "&",replacement = "and")
eci_list$constituency_name_updated_2 <- eci_list$constituency_name_updated %>% stringr::str_to_lower() %>% stringr::str_trim() 

eci_list$state_name_updated[eci_list$state_name_updated == "odisha"] <- "orissa"
eci_list$state_name_updated[eci_list$state_name_updated == "nct of delhi"] <- "delhi"
eci_list$state_name_updated[eci_list$state_name_updated == "andaman and nicobar islands"] <- "andaman and nicobar"


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

names(eci_list)[] <- c("id","state_name","constituency_name","state_name_dm","constituency_name_dm")
readr::write_csv(eci_list,"data/gis/eci_geographies_standard.csv")
# dm_list_check_2 <- left_join(keep = FALSE, dm_list, eci_list, by=c("state_name"="state_name_updated","constituency_name"="constituency_name_updated_2"))
