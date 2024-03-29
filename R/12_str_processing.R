#### 12 STR PROCESSING #########################################################

#' This script is very time-consuming to run, and should be rerun when STR data 
#' has changed.
#' 
#' Output:
#' - `str_processed.qsm` (updated)
#' - `str_bc_processed.qsm`
#' 
#' Script dependencies:
#' - `04_str_bc_data_import.R`
#' - `11_str_listing_match.R`
#' 
#' External dependencies:
#' - None

source("R/01_startup.R")
library(foreach)
doParallel::registerDoParallel()


# Load previous data ------------------------------------------------------

qload("output/str_processed.qsm", nthreads = availableCores())
qload("output/str_bc_raw.qsm", nthreads = availableCores())


# Recalculate active date -------------------------------------------------

daily_active <- 
  daily %>% 
  filter(status != "B") %>% 
  group_by(property_ID) %>% 
  filter(date == max(date)) %>% 
  slice(1) %>% 
  ungroup() %>% 
  select(property_ID, active_new = date)

property <- 
  property %>% 
  left_join(daily_active) %>% 
  mutate(active = active_new) %>% 
  select(-active_new)

daily <- 
  daily %>% 
  group_by(property_ID, date, status) %>% 
  slice(1) %>% 
  ungroup() %>% 
  group_by(property_ID, date) %>% 
  filter(n() == 1 | (n() == 2 & status != "B")) %>% 
  ungroup()


# Calculate multilistings -------------------------------------------------

daily <- 
  daily %>% 
  strr_multi(host) %>% 
  as_tibble()

daily_bc <- 
  daily_bc %>% 
  strr_multi(host_bc) %>% 
  as_tibble()


# Calculate ghost hostels -------------------------------------------------

GH <- 
  property %>% 
  strr_ghost(start_date = "2016-01-01", end_date = max(daily$date))


# Add daily status to GH --------------------------------------------------

daily_GH <- 
  daily %>% 
  filter(property_ID %in% unique(unlist(GH$property_IDs)))

setDT(daily_GH)

daily_GH <- daily_GH %>% select(property_ID:status)

status_fun <- function(x, y) {
  status <- unique(daily_GH[date == x & property_ID %in% y, status])
  fcase("R" %in% status, "R", "A" %in% status, "A", "B" %in% status, "B")
}

upgo:::handler_upgo("Analyzing row")

with_progress({
  
  pb <- progressor(nrow(GH))

  status <- foreach(i = 1:nrow(GH), .combine = "c") %dopar% {
    pb()
    status_fun(GH$date[[i]], GH$property_IDs[[i]])
  }

})

GH$status <- status
GH <- GH %>% select(ghost_ID, date, status, host_ID:data, geometry)

rm(daily_GH, pb, status_fun, status)


# Add GH status to daily --------------------------------------------------

GH_daily <- 
  GH %>% 
  st_drop_geometry() %>% 
  select(date, property_IDs) %>% 
  unnest(property_IDs) %>% 
  mutate(GH = TRUE) %>% 
  select(property_ID = property_IDs, date, GH)

daily <- 
  daily %>% 
  left_join(GH_daily, by = c("property_ID", "date")) %>% 
  mutate(GH = if_else(is.na(GH), FALSE, GH))

rm(GH_daily)


# Save output -------------------------------------------------------------

qsavem(property, daily, GH, file = "output/str_processed.qsm",
       nthreads = availableCores())

qsavem(property_bc, daily_bc, file = "output/str_bc_processed.qsm",
       nthreads = availableCores())
