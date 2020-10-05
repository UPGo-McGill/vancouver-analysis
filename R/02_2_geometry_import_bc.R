#### 02 GEOMETRY IMPORT ########################################################

#' This script should only be rerun when geometry needs to be rebuilt from 
#' scratch.
#' 
#' Output:
#' - `geometry_CMA.Rdata`
#' 
#' Script dependencies:
#' - None
#' 
#' External dependencies:
#' - None

source("R/01_startup.R")
library(cancensus)


# BC province -------------------------------------------------------------

province <- 
  get_census("CA16", regions = list(PR = "59"), geo_format = "sf") %>% 
  st_transform(32610) %>% 
  select(geometry)


# CMA DAs -----------------------------------------------------------

DA_CMA <-
  get_census(
    dataset = "CA16", regions = list(CMA = "59933"), level = "DA",
    geo_format = "sf") %>% 
  filter(CSD_UID != "5915022") %>% 
  st_transform(32610) %>% 
  select(GeoUID, Dwellings) %>% 
  set_names(c("GeoUID", "dwellings", "geometry")) %>% 
  st_set_agr("constant")


# CMA's CSD -----------------------------------------------------------

CMA_CSDs <-
  get_census(
    dataset = "CA16", regions = list(CMA = "59933"), level = "CSD", geo_format = "sf") %>% 
  filter(name != "Vancouver (CY)") %>%
  st_transform(32610) %>% 
  select(name, Dwellings) %>% 
  set_names(c("CSD", "dwellings", "geometry")) %>% 
  st_set_agr("constant")

# Save output -------------------------------------------------------------

save(province, DA_CMA, CMA_CSDs, 
     file = "output/geometry_bc.Rdata")
