source("R/01_startup.R")

load("output/str_province.Rdata")
load("output/str_processed.Rdata")
load("output/geometry_bc.Rdata")
load("output/geometry.Rdata")


### Active listings for BC and Vancou ##############################

active_listings <- 
  daily %>% 
  filter(housing, status != "B") %>% 
  count(date, listing_type) %>% 
  group_by(listing_type) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6, .complete = TRUE)) %>% 
  ungroup()

active_listings <- 
  daily %>% 
  filter(housing, status != "B") %>% 
  count(date) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6, .complete = TRUE),
         listing_type = "All listings") %>% 
  bind_rows(active_listings) %>% 
  arrange(date, listing_type)

active_listings_bc <- 
  daily_bc %>% 
  filter(housing, status != "B") %>% 
  count(date, listing_type) %>% 
  group_by(listing_type) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6, .complete = TRUE)) %>% 
  ungroup()

active_listings_bc <- 
  daily_bc %>% 
  filter(housing, status != "B") %>% 
  count(date) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6, .complete = TRUE),
         listing_type = "All listings") %>% 
  bind_rows(active_listings_bc) %>% 
  arrange(date, listing_type)

active_listings_indexed <- 
  active_listings %>%
  filter(date >= key_date_regulations) %>%
  mutate(index = 100*n/n[date == key_date_regulations]) %>% 
  mutate(group = "CoV")

active_listings_bc_indexed <- 
  active_listings_bc %>%
  filter(date >= key_date_regulations) %>%
  mutate(index = 100*n/n[date == key_date_regulations]) %>% 
  mutate(group = "CMA")

active_listings_both <- 
rbind(active_listings_indexed, active_listings_bc_indexed)

active_listings_both %>% 
  filter(listing_type == "All listings") %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 135, yend = 150, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 130,
           label = "COVID-19 \nAirbnb's response", family = "Futura Condensed") +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 150, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations", family = "Futura Condensed")+
  geom_line()

# Revenue for CoV and CMA

revenue <-
  daily %>%
  filter(housing, status == "R") %>%
  group_by(date) %>% 
  summarize(revenue = sum(price))

revenue_bc <-
  daily_bc %>%
  filter(housing, status == "R") %>%
  group_by(date) %>% 
  summarize(revenue = sum(price))

revenue_indexed <- 
  revenue %>%
  mutate(revenue = slide_dbl(revenue, mean, .before = 6, .complete = TRUE)) %>% 
  filter(date >= key_date_regulations) %>%
  mutate(index = 100*revenue/revenue[date == key_date_regulations]) %>% 
  mutate(group = "CoV")

revenue_bc_indexed <- 
  revenue_bc %>%
  mutate(revenue = slide_dbl(revenue, mean, .before = 6, .complete = TRUE)) %>% 
  filter(date >= key_date_regulations) %>%
  mutate(index = 100*revenue/revenue[date == key_date_regulations]) %>% 
  mutate(group = "CMA")

revenue_both <- 
  rbind(revenue_indexed, revenue_bc_indexed)

revenue_both %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  geom_line()







### Same but both sides of CoV ################################################

buffer_all_CoV <- st_buffer(st_cast(city,"MULTILINESTRING"),
                    1000, joinStyle = "MITRE", mitreLimit = 3)

buffer_VoC_Burnaby <- 
  st_intersection(select(st_cast(city,"MULTILINESTRING"), -everything()), 
                  select(filter(st_cast(CMA_CSDs,"MULTILINESTRING"), CSD == "Burnaby (CY)"), -everything())) %>% 
  st_cast("LINESTRING") %>%
  st_buffer(dist = 1000, joinStyle="MITRE", mitreLimit=0.1)

property_buffer <- 
property %>% 
  mutate(group = "CoV") %>% 
  select(property_ID, group) %>% 
  rbind(select(mutate(property_bc, group = "Burnaby"), property_ID, group)) %>%
  st_intersection(select(buffer_VoC_Burnaby, -everything()))

# Active listings for BC and Vancou

daily_buffer <- 
  rbind(select(daily,
               property_ID, date, status, price, listing_type, housing), 
        select(daily_bc,
               property_ID, date, status, price, listing_type, housing)) %>% 
  inner_join(st_drop_geometry(property_buffer))


active_listings <- 
  daily_buffer %>% 
  filter(housing, status != "B") %>% 
  count(date, group) %>% 
  group_by(group) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6, .complete = TRUE)) %>% 
  ungroup()

active_listings_indexed <- 
  active_listings %>%
  filter(date >= key_date_regulations) %>%
  group_by(group) %>% 
  mutate(index = 100*n/n[date == key_date_regulations])


active_listings_indexed %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 135, yend = 150, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 130,
           label = "COVID-19 \nAirbnb's response", family = "Futura Condensed") +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 150, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations", family = "Futura Condensed")+
  geom_line()+
  ggtitle("Daily active listings variation")



# number of reservations
active_listings <- 
  daily_buffer %>% 
  filter(housing, status == "A") %>% 
  count(date, group) %>% 
  group_by(group) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6, .complete = TRUE)) %>% 
  ungroup()

active_listings_indexed <- 
  active_listings %>%
  filter(date >= key_date_regulations) %>%
  group_by(group) %>% 
  mutate(index = 100*n/n[date == key_date_regulations])

active_listings_indexed %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 135, yend = 150, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 130,
           label = "COVID-19 \nAirbnb's response", family = "Futura Condensed") +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 150, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations", family = "Futura Condensed")+
  geom_line()+
  ggtitle("Reservations")

# Revenue for CoV and CMA

revenue <-
  daily_buffer %>%
  filter(housing, status == "R") %>%
  group_by(date, group) %>% 
  summarize(revenue = sum(price)) %>% 
  group_by(group) %>% 
  mutate(revenue = slide_dbl(revenue, mean, .before = 6, .complete = TRUE))

revenue_indexed <- 
  revenue %>%
  filter(date >= key_date_regulations) %>%
  group_by(group) %>% 
  mutate(index = 100*revenue/revenue[date == key_date_regulations])



revenue_indexed %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  geom_line() +
  ggtitle("Revenue")










### closest station to the boundaries of Vancouver City ####################

stations_CMA <- 
skytrain  %>% 
  # mutate(in_city = ifelse(station %in% st_intersection(skytrain, city)$station, T, F)) %>% 
  st_intersection(CMA_CSDs) %>% 
  mutate(distance = st_distance(geometry, st_cast(city, "MULTILINESTRING"))) %>%
  # group_by(in_city) %>% 
  arrange(distance) %>%
  slice(1:8) %>% 
  select(-distance, -CSD, -dwellings)

near_burnaby <- 
skytrain %>% 
  st_intersection(city) %>% 
  mutate(distance = st_distance(geometry, st_cast(filter(CMA_CSDs, CSD == "Burnaby (CY)"), "MULTILINESTRING"))) %>%
  arrange(distance) %>%
  slice(1:4) %>% 
  select(-distance, -dwellings)

near_richmond <- 
skytrain %>% 
  st_intersection(city) %>% 
  mutate(distance = st_distance(geometry, st_cast(filter(CMA_CSDs, CSD == "Richmond (CY)"), "MULTILINESTRING"))) %>%
  arrange(distance) %>%
  slice(1:4) %>% 
  select(-distance, -dwellings)
  
stations_city <- 
rbind(near_burnaby, near_richmond)

# Get the properties inside 500m of the metro stations closest to CoV boundaries
stations_buffer <- 
  stations_city %>% 
  select(-GeoUID) %>% 
  rbind(stations_CMA) %>% 
  mutate(in_city = ifelse(station %in% st_intersection(skytrain, city)$station, T, F)) %>% 
  st_buffer(., 500)


property_buffer <- 
st_intersection(stations_buffer, rbind(select(property, property_ID), select(property_bc, property_ID)))


stations_buffer %>%
  st_join(property) %>% 
  count(in_city) %>% 
  ggplot()+geom_sf(data= city)+geom_sf(aes(color=in_city))

# Active listings for BC and Vancou

daily_buffer <- 
  rbind(select(daily,
               property_ID, date, status, price, listing_type, housing), 
        select(daily_bc,
               property_ID, date, status, price, listing_type, housing)) %>% 
  inner_join(st_drop_geometry(property_buffer))



stations_buffer %>%
  st_join(property) %>% 
  count(in_city) %>% 
  ggplot()+geom_sf()active_listings <- 
  daily_buffer %>% 
  filter(housing, status != "B") %>% 
  count(date, in_city) %>% 
  group_by(in_city) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6, .complete = TRUE)) %>% 
  ungroup()

active_listings_indexed <- 
  active_listings %>%
  filter(date >= key_date_regulations) %>%
  group_by(in_city) %>% 
  mutate(index = 100*n/n[date == key_date_regulations])


active_listings_indexed %>% 
  ggplot(aes(date, index, colour = in_city)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 135, yend = 150, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 130,
           label = "COVID-19 \nAirbnb's response", family = "Futura Condensed") +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 150, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations", family = "Futura Condensed")+
  geom_line()+
  ggtitle("Daily active listings variation")

# Revenue for CoV and CMA

revenue <-
  daily_buffer %>%
  filter(housing, status == "R") %>%
  group_by(date, in_city) %>% 
  summarize(revenue = sum(price)) %>% 
  group_by(in_city) %>% 
  mutate(revenue = slide_dbl(revenue, mean, .before = 6, .complete = TRUE))

revenue_indexed <- 
  revenue %>%
  filter(date >= key_date_regulations) %>%
  group_by(in_city) %>% 
  mutate(index = 100*revenue/revenue[date == key_date_regulations])


revenue_indexed %>% 
  ggplot(aes(date, index, colour = in_city)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  geom_line() +
  ggtitle("Revenue")



                