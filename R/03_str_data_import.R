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
qload("output/geometry.qs", nthreads = availableCores())


# Get data ----------------------------------------------------------------

upgo_connect(daily_inactive = TRUE)

property <- 
  property_remote %>% 
  filter(country == "Canada", city == "Vancouver") %>% 
  collect() %>% 
  strr_as_sf(32610) %>% 
  st_filter(city)

property_bc <- 
  property_remote %>% 
  filter(country == "Canada", region == "British Columbia") %>% 
  collect() %>% 
  filter(!property_ID %in% property$property_ID) %>% 
  strr_as_sf(32610) %>% 
  st_filter(CMA)

daily <- 
  daily_remote %>% 
  filter(country == "Canada", city == "Vancouver") %>% 
  collect()
  
daily <- daily %>% strr_expand()

daily_bc <- 
  daily_remote %>% 
  filter(property_ID %in% !!property_bc$property_ID) %>% 
  collect()

daily_bc <- daily_bc %>% strr_expand()

daily_inactive <- 
  daily_inactive_remote %>% 
  filter(country == "Canada", city == "Vancouver") %>% 
  collect()

daily_inactive <- daily_inactive %>% strr_expand()

daily_inactive_bc <- 
  daily_inactive_remote %>% 
  filter(property_ID %in% !!property_bc$property_ID) %>% 
  collect()

daily_inactive_bc <- daily_inactive_bc %>% strr_expand()

host <-
  host_remote %>% 
  filter(host_ID %in% !!property$host_ID) %>% 
  collect()
  
host <- host %>% strr_expand()

host_bc <- 
  host_remote %>% 
  filter(host_ID %in% !!property_bc$host_ID) %>% 
  collect()

host_bc <- host_bc %>% strr_expand()

upgo_disconnect()


# Manually fix wonky created dates ----------------------------------------

property <-
  property %>% 
  mutate(created = if_else(is.na(created), first_active, created),
         scrpaed = if_else(is.na(scraped), last_active, scraped)) %>% 
  filter(!is.na(created))

property_bc <- 
  property_bc %>% 
  mutate(created = if_else(is.na(created), first_active, created),
         scrpaed = if_else(is.na(scraped), last_active, scraped)) %>% 
  filter(!is.na(created))

daily <-
  daily %>% 
  filter(property_ID %in% property$property_ID)

daily_bc <- 
  daily_bc %>% 
  filter(property_ID %in% property_bc$property_ID)

host <- 
  host %>% 
  filter(host_ID %in% property$host_ID)

host_bc <- 
  host_bc %>% 
  filter(host_ID %in% property_bc$host_ID)


# Manually fix January scraped date issue ---------------------------------

# Load old property files
prop_04 <- 
  qread(paste0("~/Documents/Academic/Code/global-file-import/", 
                  "output/property/property_2020_04.qs"),
        nthreads = availableCores()) %>% 
  select(property_ID, old_scraped = scraped)

# Get fixes
jan_fix <- 
  property %>% 
  st_drop_geometry() %>% 
  filter(scraped >= "2020-01-29", scraped <= "2020-01-31") %>% 
  left_join(prop_04) %>% 
  filter(scraped < old_scraped) %>% 
  select(property_ID, old_scraped)

jan_fix_bc <- 
  property_bc %>% 
  st_drop_geometry() %>% 
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

property_bc <- 
  property_bc %>% 
  left_join(jan_fix_bc) %>% 
  mutate(scraped = if_else(is.na(old_scraped), scraped, old_scraped)) %>% 
  select(-old_scraped)

# Scrape fixed listings with May scraped date to see which are still active
to_scrape <- jan_fix %>% filter(old_scraped >= "2020-05-01")
upgo_scrape_connect()
new_scrape <- to_scrape %>% upgo_scrape_ab(proxies = .proxy_list, cores = 10)
upgo_scrape_disconnect()
still_active <- new_scrape %>% filter(!is.na(country))

to_scrape_2 <- jan_fix_bc %>% filter(old_scraped >= "2020-05-01")
upgo_scrape_connect()
new_scrape_2 <- 
  to_scrape_2 %>% upgo_scrape_ab(proxies = .proxy_list, cores = 10)
upgo_scrape_disconnect()
still_active_2 <- new_scrape_2 %>% filter(!is.na(country))

# Update scraped dates for active listings
property <- 
  property %>% 
  mutate(scraped = if_else(property_ID %in% still_active$property_ID,
                           as.Date("2020-09-01"), scraped))

property_bc <- 
  property_bc %>% 
  mutate(scraped = if_else(property_ID %in% still_active_2$property_ID,
                           as.Date("2020-09-01"), scraped))

# Get inactives
inactives <-
  daily_inactive %>% 
  filter(property_ID %in% jan_fix$property_ID)

inactives_bc <-
  daily_inactive %>% 
  filter(property_ID %in% jan_fix_bc$property_ID)

# Add inactive rows to daily file

daily <- 
  inactives %>% 
  left_join(select(st_drop_geometry(property), 
                   property_ID, created, scraped)) %>%
  filter(date >= created, date <= scraped) %>%
  select(-created, -scraped) %>% 
  bind_rows(daily)

daily_bc <- 
  inactives_bc %>% 
  left_join(select(st_drop_geometry(property), 
                   property_ID, created, scraped)) %>%
  filter(date >= created, date <= scraped) %>%
  select(-created, -scraped) %>% 
  bind_rows(daily_bc)

rm(prop_04, jan_fix, jan_fix_bc, to_scrape, to_scrape_2, new_scrape, 
   new_scrape_2, still_active, still_active_2, inactives, inactives_bc,
   daily_inactive, daily_inactive_bc)


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

daily_bc <- 
  daily_bc %>% 
  mutate(year_month = substr(date, 1, 7)) %>% 
  left_join(exchange_rates) %>% 
  mutate(price = price * exchange_rate) %>% 
  select(-year_month, -exchange_rate)


# Process the property and daily files ------------------------------------

# Run raffle to assign a DA to each listing
property <-
  property %>% 
  strr_raffle(DA, GeoUID, dwellings, seed = 1)

# Add area to property file
property <-
  property %>%
  st_join(select(LA, -dwellings))

# Add area to daily file
daily <-
  property %>%
  st_drop_geometry() %>%
  select(property_ID, area) %>%
  left_join(daily, ., by = "property_ID")


# Save output -------------------------------------------------------------

qsavem(property, daily, host, exchange_rates, file = "output/str_raw.qs",
       nthreads = availableCores())
qsavem(property_bc, daily_bc, host_bc, file = "output/str_province_raw.qs",
       nthreads = availableCores())
