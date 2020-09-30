#### REMAPPING OF HOMEAWAY PROPERTY IDS ########################################

library(tidyverse)
library(future)
library(future.apply)
plan(multiprocess)

# Load data ---------------------------------------------------------------

load(paste0("~/Documents/Academic/Code/global-file-import/output/property/",
            "property_2020_05.Rdata"))
property_2020_05 <- property



# Update fields -----------------------------------------------------------

upgo_connect(property = FALSE, daily = FALSE, host = FALSE, ha_mapping = TRUE)

fixed_property <- 
  property %>% 
  left_join(ha_mapping_remote, by = c("property_ID" = "new_ID"), 
            copy = TRUE) %>% 
  left_join(select(property_2020_05, old_ID = property_ID, 
                   old_created = created, old_scraped = scraped)) %>%  
  select(property_ID, created, old_created, scraped, old_scraped) %>% 
  rename(new_created = created, new_scraped = scraped) %>% 
  mutate(created = as.Date(pmin(as.integer(new_created), 
                                as.integer(old_created), na.rm = TRUE), 
                           origin = "1970-01-01"),
         scraped = as.Date(pmax(as.integer(new_scraped), 
                                as.integer(old_scraped), na.rm = TRUE), 
                           origin = "1970-01-01")) %>% 
  mutate(created = if_else(created > scraped, as.Date(NA), created))
  

# Integrate changes into property file and save ---------------------------

property <- 
  property %>% 
  select(-created, -scraped) %>% 
  left_join(fixed_property) %>% 
  select(property_ID:listing_type, created:scraped, housing:ha_host)


# Update daily files ------------------------------------------------------

daily_to_change <- 
  daily %>% 
  filter(date <= "2020-06-30", str_starts(property_ID, "ha"))

daily_to_change <- 
  daily_to_change %>% 
  left_join(ha_mapping_remote, by = c("property_ID" = "old_ID"), copy = TRUE) %>% 
  mutate(property_ID = if_else(is.na(new_ID), property_ID, new_ID)) %>% 
  select(-new_ID)

daily <- 
  daily %>% 
  filter(date >= "2020-06-01" | !str_starts(property_ID, "ha")) %>% 
  bind_rows(daily_to_change)

daily_inactive_to_change <- 
  daily_inactive %>% 
  filter(date <= "2020-06-30", str_starts(property_ID, "ha"))

daily_inactive_to_change <- 
  daily_inactive_to_change %>% 
  left_join(ha_mapping_remote, by = c("property_ID" = "old_ID"), copy = TRUE) %>% 
  mutate(property_ID = if_else(is.na(new_ID), property_ID, new_ID)) %>% 
  select(-new_ID)

daily_inactive <- 
  daily_inactive %>% 
  filter(date >= "2020-06-01" | !str_starts(property_ID, "ha")) %>% 
  bind_rows(daily_inactive_to_change)

daily_inactive %>% 
  count(property_ID, date, sort = TRUE)


# Reallocate daily/daily_inactive -----------------------------------------

daily %>% 
  left_join(select(property, property_ID, created, scraped)) %>% 
  filter(date < created | date > scraped)


property_remote %>% 
  filter(property_ID == "ab-10089310")


ha_mapping_remote %>% 
  filter(new_ID == "ha-1000301")

# property %>% 
# daily_to_change %>% 
daily_inactive %>% 
  filter(property_ID == "ha-1000301") %>% 
  filter(date == max(date))

daily_inactive_remote %>% 
  filter(property_ID == "ha-1000301")

daily_inactive_van <- daily_inactive

load("output/2017/daily_2017.Rdata")
load("output/2017/daily_inactive_2017.Rdata")
load("~/Documents/Academic/Code/global-file-import/output/2020/daily_inactive_2020_06.Rdata")


error <- read_csv("/Users/dwachsmuth/Documents/Academic/Code/global-file-import/output/2020/error_2020_06.csv")

error %>% 
  filter(property_ID == "ha-1000301")

ids_to_check <- 
  error %>% 
  count(property_ID) %>% 
  filter(str_starts(property_ID, "ha"))

ids_to_check %>% 
  left_join(ha_mapping_remote, by = c("property_ID" = "new_ID"), copy = TRUE)
  

daily_inactive %>% 
  filter(property_ID == "ha-1000301")


daily <- daily %>% as_tibble()
daily_inactive <- daily_inactive %>% as_tibble()

daily2 <- 
  daily %>% 
  left_join(mapping, by = c("property_ID" = "old_ID")) %>% 
  mutate(property_ID = if_else(is.na(new_ID), property_ID, new_ID)) %>% 
  select(-new_ID)

daily_inactive2 <- 
  daily_inactive %>% 
  left_join(mapping, by = c("property_ID" = "old_ID")) %>% 
  mutate(property_ID = if_else(is.na(new_ID), property_ID, new_ID)) %>% 
  select(-new_ID)

daily2 <- 
  daily2 %>% 
  left_join(select(property, property_ID, created, scraped))

daily_inactive2 <- 
  daily_inactive2 %>% 
  left_join(select(property, property_ID, created, scraped))

daily2_to_inactive <- 
  daily2 %>% 
  filter(!property_ID %in% property$property_ID)



daily2 %>% 
  filter(end_date > scraped)

# daily2 %>% 
property %>% 
  filter(is.na(scraped))

daily2 %>% 
  filter(property_ID %in% mapping$old_ID)


IDs_to_check <- 
  daily_to_change %>% 
  count(property_ID) %>% 
  pull(property_ID)


