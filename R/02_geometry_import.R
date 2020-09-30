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
#' - None

source("R/01_startup.R")
library(cancensus)
library(osmdata)


# BC province -------------------------------------------------------------

province <- 
  get_census("CA16", regions = list(PR = "59"), geo_format = "sf") %>% 
  st_transform(32610) %>% 
  select(geometry)


# Vancouver DAs -----------------------------------------------------------

DA <-
  get_census(
    dataset = "CA16", regions = list(CSD = "5915022"), level = "DA",
    geo_format = "sf") %>% 
  st_transform(32610) %>% 
  select(GeoUID, Dwellings) %>% 
  set_names(c("GeoUID", "dwellings", "geometry")) %>% 
  st_set_agr("constant")

# Vancouver local areas

LA_raw <-
  read_sf("data-vancouver/shapefiles/local-area-boundary.shp") %>% 
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

streets <- 
  (getbb("Vancouver BC") * c(1.01, 0.99, 0.99, 1.01)) %>% 
  opq(timeout = 200) %>% 
  add_osm_feature(key = "highway") %>% 
  osmdata_sf()

streets <-
  rbind(
    streets$osm_polygons %>% st_set_agr("constant") %>% st_cast("LINESTRING"), 
    streets$osm_lines) %>% 
  as_tibble() %>% 
  st_as_sf() %>% 
  st_transform(32610) %>%
  st_set_agr("constant") %>%
  st_intersection(city)

streets <- 
  streets %>% 
  filter(highway %in% c("primary", "secondary")) %>% 
  select(osm_id, name, highway, geometry)

# downtown_poly <- 
#   st_polygon(list(matrix(c(607000, 5038000,
#                            614000, 5038000,
#                            614000, 5045000,
#                            607000, 5045000,
#                            607000, 5038000), 
#                          ncol = 2, byrow = TRUE))) %>% 
#   st_sfc(crs = 32618)
# 
# streets_downtown <- 
#   streets %>% 
#   st_intersection(downtown_poly)


# Save output -------------------------------------------------------------

save(province, DA, city, streets, LA, #streets_downtown, 
     file = "output/geometry.Rdata")
