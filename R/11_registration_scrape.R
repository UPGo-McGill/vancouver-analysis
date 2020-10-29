library(upgo)
rm(daily, host, exchange_rates)



test2 <- 
  property %>% 
  slice(1:100) %>% 
  upgo_scrape_ab_registration(.proxy_list, 10)

test2 %>% 
  count(registration)

# test2 %>% 
property %>% 
  slice(1:100) %>% 
  filter(property_ID == "ab-359942")

test3 <- 
  property %>% 
  slice(1:100) %>% 
  upgo_scrape_ab_registration(.proxy_list, 10)

test3 %>% 
  count(registration)

registration_1 <- 
  property %>%
  slice(1:5000) %>% 
  upgo_scrape_ab_registration(.proxy_list, 10)

registration <- registration_1

save(registration, file = "output/registration.Rdata")

load("output/registration.Rdata")
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
    rbind(new_scrape)
  
  save(registration, file = "output/registration.Rdata")  
  
}



