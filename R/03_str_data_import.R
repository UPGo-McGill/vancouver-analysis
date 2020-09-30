#### 03 STR DATA IMPORT ########################################################

#' This script is time-consuming to run, so it should only be rerun when STR 
#' data needs to be rebuilt from scratch.
#' 
#' Output:
#' - `str_raw.Rdata`
#' 
#' Script dependencies:
#' - `02_geometry_import.R`
#' 
#' External dependencies:
#' - Access to the UPGo database
#' - Old versions of the AirDNA property file to fix problems with last scraped
#'   dates

source("R/01_startup.R")
load("output/geometry.Rdata")


# Get data ----------------------------------------------------------------

upgo_connect(daily_inactive = TRUE)

property <- 
  property_remote %>% 
  filter(country == "Canada", city == "Vancouver") %>% 
  collect()

daily <- 
  daily_remote %>% 
  filter(country == "Canada", city == "Vancouver") %>% 
  collect()
  
daily <- daily %>% strr_expand()

daily_inactive <- 
  daily_inactive_remote %>% 
  filter(country == "Canada", city == "Vancouver") %>% 
  collect()

daily_inactive <- daily_inactive %>% strr_expand()

host <-
  host_all %>% 
  filter(host_ID %in% !!property$host_ID) %>% 
  collect()
  
host <- host %>% strr_expand()

upgo_disconnect()


# Manually remove wonky created dates -------------------------------------

property <-
  property %>% 
  filter(!is.na(created))

daily <-
  daily %>% 
  filter(property_ID %in% property$property_ID)

host <- 
  host %>% 
  filter(host_ID %in% property$host_ID)


# Manually fix January scraped date issue ---------------------------------

# Load old property files
prop_04 <- 
  read_csv(paste0("~/Documents/Academic/Code/global-file-import/", 
                  "data/property_2020_04.gz")) %>% 
  select(property_ID = `Property ID`,
         old_scraped = `Last Scraped Date`)

# Get fixes
jan_fix <- 
  property %>% 
  filter(scraped >= "2020-01-29", scraped <= "2020-01-31") %>% 
  left_join(prop_04) %>% 
  filter(scraped < old_scraped) %>% 
  select(property_ID, old_scraped)

# Change scraped date in property file
property <- 
  property %>% 
  left_join(jan_fix) %>% 
  mutate(scraped = if_else(is.na(old_scraped), scraped, old_scraped)) %>% 
  select(-old_scraped)

# Scrape fixed listings with May scraped date to see which are still active
to_scrape <- jan_fix %>% filter(old_scraped >= "2020-05-01")
upgo_scrape_connect(chrome = "84.0.4147.30", check = FALSE)
new_scrape <- to_scrape %>% upgo_scrape_ab(proxies = .proxy_list, cores = 10)
upgo_scrape_disconnect()
still_active <- new_scrape %>% filter(!is.na(country))

# Update scraped dates for active listings
property <- 
  property %>% 
  mutate(scraped = if_else(property_ID %in% still_active$property_ID,
                           as.Date("2020-08-01"), scraped))

# Get inactives
upgo_connect(daily_inactive = TRUE)

inactives <-
  daily_inactive_all %>% 
  filter(property_ID %in% !!jan_fix$property_ID) %>% 
  collect() %>% 
  strr_expand()

upgo_disconnect()


# Add inactive rows to daily file then re-trim
daily <- 
  daily %>% 
  bind_rows(daily_inactive) %>% 
  left_join(select(property, property_ID, created, scraped)) %>%
  filter(date >= created, date <= scraped) %>%
  select(-created, -scraped)

rm(prop_04, jan_fix, to_scrape, new_scrape, still_active, inactives)


# Convert currency --------------------------------------------------------

exchange_rates <- 
  convert_currency(start_date = min(daily$date), 
                   end_date = max(daily$date))

daily <- 
  daily %>% 
  mutate(year_month = substr(date, 1, 7)) %>% 
  left_join(exchange_rates) %>% 
  mutate(price = price * exchange_rate) %>% 
  select(-year_month, -exchange_rate)


# Process the property and daily files ------------------------------------

# # Spatial join to only keep the properties inside the city of Mtl
# property <- 
#   property %>% 
#   strr_as_sf(32618) %>% 
#   st_intersection(city)

# Run raffle to assign a DA to each listing
property <-
  property %>% 
  strr_as_sf(32610) %>% 
  strr_raffle(DA, GeoUID, dwellings, seed = 1)

# Trim daily file
daily <- 
  daily %>% 
  filter(property_ID %in% property$property_ID)

# Trim host file
host <- 
  host %>% 
  filter(host_ID %in% property$host_ID)


# Save output -------------------------------------------------------------

save(property, daily, host, exchange_rates, file = "output/str_raw.Rdata")
