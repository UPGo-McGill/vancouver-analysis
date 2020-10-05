### Quick temporary raffle for the CMA ##############################

#' Script dependencies:
#' `02_2_geometry_import_bc.R`
#' 

source("R/01_startup.R")
load("output/str_province.Rdata")
load("output/geometry_bc.Rdata")

# Run raffle to assign a DA to each listing
property_bc <-
  property_bc %>% 
  strr_as_sf(32610) %>% 
  strr_raffle(DA_CMA, GeoUID, dwellings, seed = 1)

# Trim daily file
daily_bc <- 
  daily_bc %>% 
  filter(property_ID %in% property_bc$property_ID)

# Trim host file
host_bc <- 
  host_bc %>% 
  filter(host_ID %in% property_bc$host_ID)

# Add area to property file
property_bc <-
  property_bc %>%
  st_join(select(CMA_CSDs, -dwellings))

# Add area to daily file
daily_bc <-
  property_bc %>%
  st_drop_geometry() %>%
  select(property_ID, CSD) %>%
  left_join(daily_bc, ., by = "property_ID")

# Save output -------------------------------------------------------------

save(property_bc, daily_bc, host_bc, file = "output/str_province.Rdata")
