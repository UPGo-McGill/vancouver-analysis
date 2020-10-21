#### 02 GEOMETRY IMPORT ########################################################

#' This script should only be rerun when geometry needs to be rebuilt from 
#' scratch.
#' 
#' Output:
#' - `geometry.Rdata`
#' 
#' Script dependencies:
#' - None
#' 
#' External dependencies:
#' - `local-area-boundary.shp`: Shapefile of Vancouver's local areas

source("R/01_startup.R")
library(cancensus)
library(osmdata)


# BC province -------------------------------------------------------------

province <- 
  get_census("CA16", regions = list(PR = "59"), geo_format = "sf") %>% 
  st_transform(32610) %>% 
  select(geometry)

# Vancouver CMA without Vancouver -----------------------------------------

CMA <-
  get_census(
    dataset = "CA16", regions = list(CMA = "59933"), level = "CSD", geo_format = "sf") %>% 
  filter(name != "Vancouver (CY)") %>%
  st_transform(32610)
  
# Vancouver DAs -----------------------------------------------------------

DA <-
  get_census(
    dataset = "CA16", regions = list(CSD = "5915022"), level = "DA",
    geo_format = "sf") %>% 
  st_transform(32610) %>% 
  select(GeoUID, Dwellings) %>% 
  set_names(c("GeoUID", "dwellings", "geometry")) %>% 
  st_set_agr("constant")

# Vancouver local areas ---------------------------------------------------

LA_raw <-
  read_sf("data/shapefiles/local-area-boundary.shp") %>% 
  select(area = name) %>% 
  st_set_agr("constant") %>%
  st_as_sf() %>% 
  st_transform(32610) 

LA <- 
  LA_raw %>% 
  st_intersection(province)

LA <- 
  DA %>% 
  select(dwellings) %>% 
  st_interpolate_aw(LA, extensive = TRUE) %>% 
  st_drop_geometry() %>% 
  select(dwellings) %>% 
  cbind(LA, .) %>% 
  as_tibble() %>% 
  st_as_sf() %>% 
  arrange(area)

# Vancouver CSD -----------------------------------------------------------

city <-
  get_census(
    dataset = "CA16", regions = list(CSD = "5915022"), geo_format = "sf") %>% 
  st_transform(32610) %>% 
  select(GeoUID, Dwellings) %>% 
  set_names(c("GeoUID", "dwellings", "geometry")) %>% 
  st_set_agr("constant")

# Streets -----------------------------------------------------------------
# 
# streets <- 
#   (getbb("Vancouver BC") * c(1.01, 0.99, 0.99, 1.01)) %>% 
#   opq(timeout = 200) %>% 
#   add_osm_feature(key = "highway") %>% 
#   osmdata_sf()
# 
# streets <-
#   rbind(
#     streets$osm_polygons %>% st_set_agr("constant") %>% st_cast("LINESTRING"), 
#     streets$osm_lines) %>% 
#   as_tibble() %>% 
#   st_as_sf() %>% 
#   st_transform(32610) %>%
#   st_set_agr("constant") %>%
#   st_intersection(city)
# 
# streets <- 
#   streets %>% 
#   filter(highway %in% c("primary", "secondary")) %>% 
#   select(osm_id, name, highway, geometry)
# 
# downtown_poly <- 
#   st_polygon(list(matrix(c(490000, 5457200,
#                            493000, 5457200,
#                            493000, 5460500,
#                            490000, 5460500,
#                            490000, 5457200), 
#                           ncol = 2, byrow = TRUE))) %>% 
#   st_sfc(crs = 32610)
#  
# streets_downtown <- 
#   streets %>% 
#   st_intersection(downtown_poly)

# Business licenses ------------------------------------------------------

BL <-
  read_sf("data/shapefiles/business-licences.shp") %>% 
  st_drop_geometry()

BL <- 
  as_tibble(BL) %>% 
  mutate(issued = as.Date(substr(issueddate, 1, 10))) %>% 
  filter(businesstyp == "Short-Term Rental") %>%
  transmute(registration = licencenumb,
            issued,
            expired = expireddate,
            status,
            fee_paid = feepaid,
            area = localarea)

# When expanded, issuance change for the first day of the year if it was issued
# in the end of the previous year. It results to: if a licence expires at the end of the year,
# it is counted as issued minimum at the first of january of that said year, no earlier

BL_expand <-
BL %>% 
  filter(!is.na(issued), !is.na(expired)) %>% 
  mutate(issued = ifelse(str_extract(issued, "^\\d{4}") < str_extract(expired, "^\\d{4}"), 
                         str_glue("{expired_year}-01-01",
                                  expired_year = {str_extract(expired, "^\\d{4}")}), substr(issued, 1, 10)),
         issued = as.Date(issued))

BL_expand <- data.table::setDT(BL_expand)

# Add new date field
BL_expand <- BL_expand[, date := list(list(issued:expired)), by = seq_len(nrow(BL_expand))]

# Unnest
BL_expand <- BL_expand[, lapply(.SD, unlist), by = 1:nrow(BL_expand)]

BL_expand <- BL_expand[, date := as.Date(date, origin = "1970-01-01")]

# Import of skytrain shapefile --------------------------------------------

skytrain <- 
  read_sf("data/shapefiles/RW_STN_point.shp") %>% 
  filter(STTN_SR1_M == "Translink Skytrain") %>% 
  select(station = STTN_NGLSM) %>% 
  group_by(station) %>% 
  mutate(id = row_number()) %>% 
  filter(id == 1) %>% 
  select(-id) %>% 
  st_transform(32610)


# Save output -------------------------------------------------------------

save(province, CMA, DA, city, LA, BL, BL_expand, skytrain, #streets, streets_downtown, 
     file = "output/geometry.Rdata")
