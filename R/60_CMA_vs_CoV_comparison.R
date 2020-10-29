#### CoV vs CMA CHAPTER ANALYSIS #####################################################

#' This script produces the tables and facts for chapter 2. It runs quickly.
#' 
#' Output:
#' - None
#' 
#' Script dependencies:
#' - `02_geometry_import.R`
#' - `09_str_processing.R`
#' - `12_FREH_model.R`
#' 
#' External dependencies:
#' - None

source("R/01_startup.R")

qload("output/str_processed.qs", nthreads = availableCores())
qload("output/FREH_model.qs", nthreads = availableCores())
qload("output/str_bc_processed.qs", nthreads = availableCores())
qload("output/geometry.qs", nthreads = availableCores())


# Prepare new objects -----------------------------------------------------

# Active listings Vancouver
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

# Active listings BC
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

# Active listings indexed
active_listings_indexed <-
  active_listings %>%
  filter(date >= key_date_regulations - years(1)) %>%
  mutate(index = 100*n/n[date == key_date_regulations]) %>%
  mutate(group = "CoV")

active_listings_bc_indexed <-
  active_listings_bc %>%
  filter(date >= key_date_regulations - years(1)) %>%
  mutate(index = 100*n/n[date == key_date_regulations]) %>%
  mutate(group = "CMA")

active_listings_both <-
rbind(active_listings_indexed, active_listings_bc_indexed)

# Revenue 
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

# Revenue indexed
revenue_indexed <-
  revenue %>%
  mutate(revenue = slide_dbl(revenue, mean, .before = 6, .complete = TRUE)) %>%
  filter(date >= key_date_regulations - years(1)) %>%
  mutate(index = 100*revenue/revenue[date == key_date_regulations]) %>%
  mutate(group = "CoV")

revenue_bc_indexed <-
  revenue_bc %>%
  mutate(revenue = slide_dbl(revenue, mean, .before = 6, .complete = TRUE)) %>%
  filter(date >= key_date_regulations - years(1)) %>%
  mutate(index = 100*revenue/revenue[date == key_date_regulations]) %>%
  mutate(group = "CMA")

revenue_both <-
  rbind(revenue_indexed, revenue_bc_indexed)

# FREH indexed 
FREH_indexed <- 
  daily %>% 
  filter(date >= key_date_regulations - years(1)) %>%
  group_by(date) %>% 
  summarize(n=sum(FREH_3)) %>% 
  mutate(index = 100*n/n[date == key_date_regulations]) %>%
  mutate(group = "CoV")

FREH_bc_indexed <- 
  daily_bc %>% 
  filter(date >= key_date_regulations - years(1)) %>%
  group_by(date) %>% 
  summarize(n=sum(FREH_3)) %>% 
  mutate(index = 100*n/n[date == key_date_regulations]) %>%
  mutate(group = "CMA")

FREH_both <- 
  rbind(FREH_indexed, FREH_bc_indexed)

# Commercial listings indexed
commercial_listings <- 
  daily %>% 
  filter(status != "B", date >= "2016-01-01") %>% 
  mutate(commercial = if_else(FREH_3 < 0.5 & !multi, FALSE, TRUE)) %>% 
  count(date, commercial) %>% 
  group_by(commercial) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6)) %>% 
  ungroup()

commercial_listings_indexed <-
  commercial_listings %>% 
  filter(date >= key_date_regulations - years(1)) %>%
  filter(commercial == TRUE) %>% 
  mutate(index = 100*n/n[date == key_date_regulations]) %>%
  mutate(group = "CoV")

commercial_listings_bc <- 
  daily_bc %>% 
  filter(status != "B", date >= "2016-01-01") %>% 
  mutate(commercial = if_else(FREH_3 < 0.5 & !multi, FALSE, TRUE)) %>% 
  count(date, commercial) %>% 
  group_by(commercial) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6)) %>% 
  ungroup()

commercial_listings_bc_indexed <-
  commercial_listings_bc %>% 
  filter(date >= key_date_regulations - years(1)) %>%
  filter(commercial == TRUE) %>% 
  mutate(index = 100*n/n[date == key_date_regulations]) %>%
  mutate(group = "CMA")

commercial_listings_both <- 
  rbind(commercial_listings_indexed, commercial_listings_bc_indexed)


# Active daily listings Cov vs CMA, indexed ---------------------------------------------------

active_listings_both %>%
  filter(listing_type == "All listings") %>%
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 135, yend = 150, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 130,
           label = "COVID-19 \nAirbnb's response") + #, family = "Futura Condensed"
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 150, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations")+ #, family = "Futura Condensed"
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())


# Revenue Cov vs CMA, indexed ---------------------------------------------------

revenue_both %>%
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(3, 2)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())


# FREH Cov vs CMA, indexed ---------------------------------------------------

FREH_both %>%
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 140, yend = 145, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 135,
           label = "COVID-19 \nAirbnb's response") + #, family = "Futura Condensed"
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 130, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations")+  #, family = "Futura Condensed"
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(3, 2)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())


# Commercial listings Cov vs CMA, indexed ---------------------------------------------------

commercial_listings_both %>%
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 140, yend = 145, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 135,
           label = "COVID-19 \nAirbnb's response") + #, family = "Futura Condensed"
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 125, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations")+  #, family = "Futura Condensed"
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())


# Spatial comparisons both sides of eastern boundary ---------------------------------------------------

buffer_all_CoV <- st_buffer(st_cast(city,"MULTILINESTRING"),
                            1000, joinStyle = "MITRE", mitreLimit = 3)

buffer_VoC_Burnaby <- 
  st_intersection(select(st_cast(city,"MULTILINESTRING"), -everything()), 
                  select(filter(st_cast(CMA,"MULTILINESTRING"), name == "Burnaby (CY)"), -everything())) %>% 
  st_cast("LINESTRING") %>%
  st_buffer(dist = 1000, joinStyle="MITRE", mitreLimit=0.1)

property_buffer <- 
  property %>% 
  mutate(group = "CoV") %>% 
  select(property_ID, group) %>% 
  rbind(select(mutate(property_bc, group = "Burnaby"), property_ID, group)) %>%
  st_intersection(select(buffer_VoC_Burnaby, -everything()))

# Active listings for Burnaby and CoV

daily_buffer <- 
  rbind(select(daily,
               property_ID, date, status, price, listing_type, housing, multi, FREH_3), 
        select(daily_bc,
               property_ID, date, status, price, listing_type, housing, multi, FREH_3)) %>% 
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
  filter(date >= key_date_regulations - years(1)) %>%
  group_by(group) %>% 
  mutate(index = 100*n/n[date == key_date_regulations])

commercial_listings_buffer <- 
  daily_buffer %>% 
  filter(status != "B", date >= "2016-01-01") %>% 
  mutate(commercial = if_else(FREH_3 < 0.5 & !multi, FALSE, TRUE)) %>% 
  count(date, commercial, group) %>% 
  group_by(commercial, group) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6)) %>% 
  ungroup()

commercial_listings_buffer_indexed <-
  commercial_listings_buffer %>% 
  filter(date >= key_date_regulations - years(1)) %>%
  filter(commercial == TRUE) %>% 
  mutate(index = 100*n/n[date == key_date_regulations])

FREH_buffer_indexed <- 
  daily_buffer %>% 
  filter(date >= key_date_regulations - years(1)) %>%
  group_by(date, group) %>% 
  summarize(n=sum(FREH_3)) %>% 
  group_by(group) %>% 
  mutate(index = 100*n/n[date == key_date_regulations]) 


# Active listings buffer, indexed ---------------------------------------------------
active_listings_indexed %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 135, yend = 140, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 130,
           label = "COVID-19 \nAirbnb's response") + #, family = "Futura Condensed"
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 130, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations")+ #, family = "Futura Condensed"
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())


# Commercial listings buffer, indexed ---------------------------------------------------
commercial_listings_buffer_indexed %>%
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 140, yend = 145, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 135,
           label = "COVID-19 \nAirbnb's response") + #, family = "Futura Condensed"
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 125, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations")+  #, family = "Futura Condensed"
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())


# FREH buffer, indexed ---------------------------------------------------
FREH_buffer_indexed %>%
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(3, 2)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())


# Availabilities (R or A) for buffer ---------------------------------------------------
# number of A and B facet_wrap
active_listings <- 
  daily_buffer %>% 
  filter(housing, status != "B") %>% 
  count(date, group, status) %>% 
  group_by(group, status) %>% 
  mutate(n = slide_dbl(n, mean, .before = 13, .complete = TRUE)) %>% 
  ungroup()

active_listings_indexed <- 
  active_listings %>%
  filter(date >= key_date_regulations - years(1)) %>%
  group_by(group, status) %>% 
  mutate(index = 100*n/n[date == key_date_regulations])

active_listings_indexed %>% 
  ungroup() %>% 
  mutate(status = ifelse(status == "R", "Reserved", "Available")) %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 140, yend = 145, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-8-16"), y = 135,
           label = "COVID-19 \nAirbnb's response") + #, family = "Futura Condensed"
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 125, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations")+  #, family = "Futura Condensed"
  facet_wrap(~status)+
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(3, 2)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())
  ggtitle("Availabilities (L) and reservations (A), 14 days rolling window")
  
  
# Revenue for CoV and Burnaby ---------------------------------------------------
revenue <-
  daily_buffer %>%
  filter(housing, status == "R") %>%
  group_by(date, group) %>% 
  summarize(revenue = sum(price)) %>% 
  group_by(group) %>% 
  mutate(revenue = slide_dbl(revenue, mean, .before = 6, .complete = TRUE))

revenue_indexed <- 
  revenue %>%
  filter(date >= key_date_regulations - years(1)) %>%
  group_by(group) %>% 
  mutate(index = 100*revenue/revenue[date == key_date_regulations])

revenue_indexed %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 140, yend = 145, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-8-16"), y = 135,
           label = "COVID-19 \nAirbnb's response") + #, family = "Futura Condensed"
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 125, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations")+  #, family = "Futura Condensed"
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())


# Prices variation after regulations for Burnaby and Vancou ---------------------------------------------------
avg_price <-
  daily_buffer %>%
  filter(housing, status == "R") %>%
  group_by(date, group) %>% 
  summarize(avg_price = mean(price)) %>% 
  group_by(group) %>% 
  mutate(avg_price = slide_dbl(avg_price, mean, .before = 6, .complete = TRUE))

daily_buffer %>% 
  distinct(property_ID, .keep_all = T) %>% 
  count(group)

avg_price_indexed <- 
  avg_price %>%
  filter(date >= key_date_regulations - years(1)) %>%
  group_by(group) %>%
  mutate(index = 100*avg_price/avg_price[date == key_date_regulations])

avg_price_indexed %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 140, yend = 145, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-8-16"), y = 135,
           label = "COVID-19 \nAirbnb's response") + #, family = "Futura Condensed"
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 125, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations")+  #, family = "Futura Condensed"
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())
# 
# 
# 
# 
# 
# 
# 
# 
# 
#
## closest station to the boundaries of Vancouver City ####################
# 
# stations_CMA <- 
# skytrain  %>% 
#   # mutate(in_city = ifelse(station %in% st_intersection(skytrain, city)$station, T, F)) %>% 
#   st_intersection(filter(CMA, name == "Burnaby (CY)")) %>% 
#   mutate(distance = st_distance(geometry, st_cast(city, "MULTILINESTRING"))) %>%
#   # group_by(in_city) %>% 
#   arrange(distance) %>%
#   slice(1:4) %>% 
#   transmute(station)
# 
# near_burnaby <- 
# skytrain %>% 
#   st_intersection(city) %>% 
#   mutate(distance = st_distance(geometry, st_cast(filter(CMA, name == "Burnaby (CY)"), "MULTILINESTRING"))) %>%
#   arrange(distance) %>%
#   slice(1:4) %>% 
#   select(-distance, -dwellings, -GeoUID)
# 
# # near_richmond <- 
# # skytrain %>% 
# #   st_intersection(city) %>% 
# #   mutate(distance = st_distance(geometry, st_cast(filter(CMA, CSD == "Richmond (CY)"), "MULTILINESTRING"))) %>%
# #   arrange(distance) %>%
# #   slice(1:4) %>% 
# #   select(-distance, -dwellings)
#   
# stations_city <- near_burnaby
# # rbind(near_burnaby, near_richmond)
# 
# # Get the properties inside 500m of the metro stations closest to CoV boundaries
# stations_buffer <- 
#   stations_city %>% 
#   rbind(stations_CMA) %>% 
#   mutate(in_city = ifelse(station %in% st_intersection(skytrain, city)$station, T, F)) %>% 
#   st_buffer(., 500)
# 
# 
# property_buffer <- 
# st_intersection(stations_buffer, rbind(select(property, property_ID), select(property_bc, property_ID)))
# 
# 
# stations_buffer %>%
#   st_join(property) %>% 
#   count(in_city) %>% 
#   ggplot()+geom_sf(data= city)+geom_sf(aes(color=in_city))
# 
# # Active listings 
# 
# daily_buffer <- 
#   rbind(select(daily,
#                property_ID, date, status, price, listing_type, housing), 
#         select(daily_bc,
#                property_ID, date, status, price, listing_type, housing)) %>% 
#   inner_join(st_drop_geometry(property_buffer))
# 
# 
# 
# stations_buffer %>%
#   st_join(property) %>% 
#   count(in_city) %>% 
#   ggplot()+geom_sf()
# 
# active_listings <- 
#   daily_buffer %>% 
#   filter(housing, status != "B") %>% 
#   count(date, in_city) %>% 
#   group_by(in_city) %>% 
#   mutate(n = slide_dbl(n, mean, .before = 6, .complete = TRUE)) %>% 
#   ungroup()
# 
# active_listings_indexed <- 
#   active_listings %>%
#   filter(date >= key_date_regulations - years(1)) %>%
#   group_by(in_city) %>% 
#   mutate(index = 100*n/n[date == key_date_regulations])
# 
# 
# active_listings_indexed %>% 
#   ggplot(aes(date, index, colour = in_city)) +
#   annotate("segment", x = key_date_covid, xend = key_date_covid,
#            y = -Inf, yend = Inf, alpha = 0.3) +
#   annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
#            y = 135, yend = 150, curvature = .2, lwd = 0.25,
#            arrow = arrow(length = unit(0.05, "inches"))) +
#   annotate("text", x = as.Date("2020-06-16"), y = 130,
#            label = "COVID-19 \nAirbnb's response", family = "Futura Condensed") +
#   annotate("segment", x = key_date_regulations, xend = key_date_regulations,
#            y = -Inf, yend = Inf, alpha = 0.3) +
#   annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
#            y = 130, yend = 150, curvature = .2, lwd = 0.25,
#            arrow = arrow(length = unit(0.05, "inches"))) +
#   annotate("text", x = as.Date("2018-12-01"), y = 127,
#            label = "Regulations", family = "Futura Condensed")+
#   geom_line()+
#   ggtitle("Daily active listings variation")
# 
# # Revenue 
# 
# revenue <-
#   daily_buffer %>%
#   filter(housing, status == "R") %>%
#   group_by(date, in_city) %>% 
#   summarize(revenue = sum(price)) %>% 
#   group_by(in_city) %>% 
#   mutate(revenue = slide_dbl(revenue, mean, .before = 6, .complete = TRUE))
# 
# revenue_indexed <- 
#   revenue %>%
#   filter(date >= key_date_regulations - years(1)) %>%
#   group_by(in_city) %>% 
#   mutate(index = 100*revenue/revenue[date == key_date_regulations])
# 
# 
# revenue_indexed %>% 
#   ggplot(aes(date, index, colour = in_city)) +
#   annotate("segment", x = key_date_covid, xend = key_date_covid,
#            y = -Inf, yend = Inf, alpha = 0.3) +
#   annotate("segment", x = key_date_regulations, xend = key_date_regulations,
#            y = -Inf, yend = Inf, alpha = 0.3) +
#   geom_line() +
#   ggtitle("Revenue")
# 
# 

                