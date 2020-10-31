#### 13 NATIONAL COMPARISON ####################################################

#' This script is time-consuming to run, so it should only be rerun when STR 
#' data needs to be rebuilt from scratch.
#' 
#' Output:
#' - `national_comparison.qs`
#' 
#' Script dependencies:
#' - None
#' 
#' External dependencies:
#' - Access to the UPGo database

source("R/01_startup.R")
library(cancensus)


# Get geometries for 10 biggest cities ------------------------------------

CSD <-
  get_census("CA16", list(C = "01"), level = "CSD", geo_format = "sf") %>% 
  arrange(-Population) %>% 
  slice(1:10) %>% 
  mutate(name = str_extract(name, '.*(?= )'),
         name = stringi::stri_trans_general(name, "Latin-ASCII")) %>% 
  as_tibble() %>% 
  st_as_sf()


# Get STR data for same cities --------------------------------------------

upgo_connect()

property_CA <- 
  property_all %>% 
  filter(country == "Canada", city %in% !!CSD$name) %>% 
  collect() %>% 
  strr_as_sf() %>%
  st_filter(CSD)

daily_CA <- 
  daily_all %>% 
  filter(property_ID %in% !!property_CA$property_ID, start_date >= "2019-01-01",
         start_date <= "2019-12-31") %>% 
  collect() %>% 
  strr_expand() %>% 
  # Reconcile geography inconsistencies between property and daily files
  select(-country, -region, -city) %>% 
  left_join(select(st_drop_geometry(property_CA), property_ID, country:city))

upgo_disconnect()


# Calculate figures -------------------------------------------------------

national_comparison <- 
  daily_CA %>% 
  filter(status != "B", housing) %>% 
  group_by(city) %>% 
  summarize(active_daily_listings = n() / 365, .groups = "drop") %>% 
  left_join(select(st_drop_geometry(CSD), name, Dwellings), 
            by = c("city" = "name")) %>% 
  mutate(listings_per_1000 = 1000 * active_daily_listings / Dwellings) %>% 
  select(-Households)

exchange_rates <- convert_currency(start_date = "2019-01-01", 
                                   end_date = "2019-12-31")

national_comparison <- 
  daily_CA %>% 
  filter(status == "R", housing) %>% 
  mutate(year_month = substr(date, 1, 7)) %>% 
  left_join(exchange_rates) %>% 
  mutate(price = price * exchange_rate) %>% 
  select(-year_month, -exchange_rate) %>% 
  group_by(city) %>% 
  summarize(revenue = sum(price)) %>% 
  left_join(national_comparison, .)

national_comparison <- 
  national_comparison %>% 
  mutate(revenue_per_listing = revenue / active_daily_listings)


# Get Montreal and Toronto CMAs -------------------------------------------

CMA_montreal <- 
  get_census("CA16", list(CMA = "24462"), "CSD", geo_format = "sf") %>% 
  st_transform(32618)

CMA_toronto <- 
  get_census("CA16", list(CMA = "35535"), "CSD", geo_format = "sf") %>% 
  st_transform(32617)

property_montreal <- 
  property_remote %>% 
  filter(country == "Canada", region == "Québec") %>% 
  collect() %>% 
  strr_as_sf(32618) %>% 
  st_filter(CMA_montreal)

property_montreal <- 
  property_montreal %>% 
  mutate(central = as.logical(st_intersects(
    geometry, 
    CMA_montreal[CMA_montreal$name == "Montréal (V)",]$geometry))) %>% 
  mutate(central = if_else(is.na(central), FALSE, central))

property_toronto <- 
  property_remote %>% 
  filter(country == "Canada", region == "Ontario") %>% 
  collect() %>% 
  strr_as_sf(32617) %>% 
  st_filter(CMA_toronto)

property_toronto <- 
  property_toronto %>% 
  mutate(central = as.logical(st_intersects(
    geometry, 
    CMA_toronto[CMA_toronto$name == "Toronto (CY)",]$geometry))) %>% 
  mutate(central = if_else(is.na(central), FALSE, central))

daily_montreal <- 
  daily_remote %>% 
  filter(property_ID %in% !!property_montreal$property_ID) %>% 
  collect() %>% 
  strr_expand()

daily_montreal <- 
  property_montreal %>% 
  st_drop_geometry() %>% 
  select(property_ID, central) %>% 
  left_join(daily_montreal, .)

daily_toronto <- 
  daily_remote %>% 
  filter(property_ID %in% !!property_toronto$property_ID) %>% 
  collect() %>% 
  strr_expand()

daily_toronto <- 
  property_toronto %>% 
  st_drop_geometry() %>% 
  select(property_ID, central) %>% 
  left_join(daily_toronto, .)


# Save output -------------------------------------------------------------

qsave(national_comparison, file = "output/national_comparison.qs",
      nthreads = availableCores())

qsavem(property_montreal, property_toronto, daily_montreal, daily_toronto,
       file = "output/cma_comparison.qs", nthreads = availableCores())
