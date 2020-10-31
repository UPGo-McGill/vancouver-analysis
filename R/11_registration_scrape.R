#### 11 REGISTRATION SCRAPE ####################################################

#' This script should be rerun when new STR listings are added to the dataset.
#' 
#' Output:
#' - `str_processed.qs` (updated)
#' 
#' Script dependencies:
#' - `10_str_processing.R`
#' 
#' External dependencies:
#' - Access to the UPGo database

source("R/01_startup.R")


# Load previous data ------------------------------------------------------

qload("output/str_processed.qs", nthreads = availableCores())


# Get existing registration scrapes from server ---------------------------

upgo_connect(registration = TRUE)

registration_old <- 
  registration_remote %>% 
  filter(property_ID %in% !!property$property_ID) %>% 
  collect()

registration <- registration_old


# Scrape new properties ---------------------------------------------------

upgo_scrape_connect()

n <- 1

while (nrow(filter(property, !property_ID %in% registration$property_ID)) > 0 && 
       n < 20) {
  
  n <- n + 1
  
  new_scrape <- 
    property %>% 
    filter(!property_ID %in% registration$property_ID) %>% 
    dplyr::slice(1:2000) %>% 
    upgo_scrape_ab_registration(proxies = .proxy_list, cores = 10)
  
  registration <- 
    registration %>% 
    bind_rows(new_scrape)
  
  qsave(registration, file = "output/registration.qs",
        nthreads = availableCores())  
  
}


# Add new scrapes to server -----------------------------------------------

registration_new <- 
  registration %>% 
  anti_join(registration_old)

RPostgres::dbWriteTable(.con, "registration", registration_new, append = TRUE)

upgo_disconnect()


# Add results to property table -------------------------------------------

if (!is.null(property$registration)) property$registration <- NULL

property <- 
  registration %>% 
  group_by(property_ID) %>% 
  filter(date == max(date)) %>% 
  slice(1) %>% 
  ungroup() %>% 
  select(-date) %>% 
  left_join(property, .)


# Save output -------------------------------------------------------------

qsavem(property, daily, GH, file = "output/str_processed.qs",
       nthreads = availableCores())