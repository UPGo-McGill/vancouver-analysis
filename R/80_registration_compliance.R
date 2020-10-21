#### 80 CHAPTER X ANALYSIS & GRAPHS ##########################################

#' This script produces the tables and facts for chapter X. It runs quickly.
#' 
#' Output:
#' - None
#' 
#' Script dependencies:
#' - `02_geometry_import.R`
#' - `09_str_processing.R`
#' - `registration.R` # dont know yet which script it is or will be in
#' 
#' External dependencies:
#' - None

source("R/01_startup.R")

load("output/str_processed.Rdata")
load("output/geometry.Rdata")
load("output/registration.Rdata")


### Daily counts of displayed listings and licences --------------------------------

active_listings <- 
  daily %>% 
  data.table::setDT() %>% 
  count(date) %>% 
  rename(listings = n)

active_licences <- 
  BL_expand %>% 
  count(date) %>% 
  rename(licences = n)

licences_listings <- 
  left_join(filter(active_listings, date >= min(active_licences$date)), 
            filter(active_licences, date <= max(active_listings$date))) %>% 
  mutate(licences = slide_dbl(licences, mean, .before = 6, .complete = TRUE),
         listings = slide_dbl(listings, mean, .before = 6, .complete = TRUE)) %>% 
  filter(!is.na(licences))

licences_listings %>% 
  ggplot() +
  geom_col(aes(date, listings), color = col_palette[c(3)]) +
  geom_col(aes(date, licences), color = col_palette[c(5)])+
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = 0, yend = Inf, alpha = 0.3) +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = 0, yend = Inf, alpha = 0.3) +
  scale_y_continuous(name = NULL, label = scales::comma) +
  theme_minimal() +
  theme(legend.position = "bottom", 
        panel.grid.minor.x = element_blank(),
        text = element_text(face = "plain", #family = "Futura"
        ),
        legend.title = element_text(face = "bold", #family = "Futura", 
                                    size = 10),
        legend.text = element_text( size = 10, #family = "Futura"
        ))+
  ggtitle("All listings (pink) and valid licences (green), 7 day-average")


# New licences in fall/winter 2019
pull(active_licences[date == "2019-12-31"])-
  pull(active_licences[date == "2019-10-01"])

# Decrease of displyaed listings in fall/winter 2019
pull(active_listings[date == "2019-12-31"])-
  pull(active_listings[date == "2019-10-01"])

# New licences after COVID
pull(active_licences[date == max(date)])-
  pull(active_licences[date == key_date_covid])


### Tidy data for compliance status -------------------------------------------

registration <- 
registration %>% 
  mutate(registration_1 = str_extract(registration, "\\d{2}(-| |_)"),
         registration_1 = str_remove(registration_1, "(-| |_)"),
         registration_2 = str_extract(registration, "(-| |_)\\d{6}"),
         registration_2 = str_remove(registration_2, "(-| |_)"),
         registration_8 = str_extract(registration, "\\d{8}"),
         registration_1 = ifelse(!is.na(registration_8), str_extract(registration_8, "^\\d{2}"), registration_1),
         registration_2 = ifelse(!is.na(registration_8), str_extract(registration_8, "\\d{6}$"), registration_2)) %>% 
  mutate(registration = ifelse(!is.na(registration_1) & !is.na(registration_2),
                               str_glue("{registration_1}-{registration_2}"), registration)) %>% 
  select(property_ID, registration) %>% 
  mutate(registration = ifelse(!str_detect(registration, "\\d{2}-\\d{6}") &
                               !registration == "NO LISTING" &
                               !registration == "HOMEAWAY" &
                               !is.na(registration), NA, registration))

# Joining data about business licence to registration df
registration <- 
  registration %>% 
  left_join(BL, by = "registration")

# Joining the registration data to each property_ID
property <- 
  property %>% 
  select(property_ID, host_ID, property_type:housing, active, area, ab_property) %>% 
  left_join(select(registration, -area))


### Class by conformity -------------------------------------------------

# Prepare a conformity vector
conformity_status <- 
  property %>% 
  filter(!is.na(ab_property)) %>% 
  mutate(registration_analyzed = ifelse(str_detect(registration, "\\d{2}-\\d{6}") & is.na(issued),
                                        "Fake licence, never issued", "TBD"),
         registration_analyzed = ifelse(str_detect(registration, "\\d{2}-\\d{6}") & !is.na(issued) & expired < "2020-10-13", 
                                        "Operating with expired licence", registration_analyzed),
         registration_analyzed = ifelse(str_detect(registration, "\\d{2}-\\d{6}") & !is.na(issued) & expired > "2020-10-13",
                                        "Conform", registration_analyzed),
         registration_analyzed = ifelse(registration == "NO LISTING", 
                                        "Inactive listing", registration_analyzed),
         registration_analyzed = ifelse(is.na(registration), 
                                        "Operating without licence", registration_analyzed)) 

# Graphing the conformity status of active listings
conformity_status %>% 
  filter(active >= max(active, na.rm = T) - days(30),
         registration_analyzed != "Inactive listing") %>%
  ggplot()+
  geom_histogram(stat = "count", aes(registration_analyzed, fill = registration_analyzed))+
  xlab("")+
  ylab("Number of listings")+
  guides(x = guide_axis(angle = 10))+
  scale_fill_manual(name = "Registration conformity", values = col_palette[c(4,2,3,6)])+
  theme_minimal()

# percentage of non-conform active listings
conformity_status %>% 
  filter(registration_analyzed != "Inactive listing",
         registration_analyzed != "Conform") %>%
  filter(active >= max(active, na.rm = T) - days(30)) %>% 
  nrow() /
conformity_status %>% 
  filter(registration_analyzed != "Inactive listing") %>%
  filter(active >= max(active, na.rm = T) - days(30)) %>% nrow()


# percentage of all conformity status category for active listings
conformity_status %>% 
  st_drop_geometry() %>% 
  filter(registration_analyzed != "Inactive listing",
         active >= max(active, na.rm = T) - days(30)) %>% 
  count(registration_analyzed) %>% 
  mutate(per = n/sum(n))


# Graphing the conformity status of displayed listings
conformity_status %>% 
  filter(registration_analyzed != "Inactive listing") %>%
  ggplot()+
  geom_histogram(stat = "count", aes(registration_analyzed, fill = registration_analyzed))+
  xlab("")+
  ylab("Number of listings")+
  guides(x = guide_axis(angle = 10))+
  scale_fill_manual(name = "Registration conformity", values = col_palette[c(4, 2, 3, 6)])+
  theme_minimal()


# percentage of non-conform displayed listings
conformity_status %>% 
  filter(registration_analyzed != "Inactive listing",
         registration_analyzed != "Conform") %>%
  nrow() /
  conformity_status %>% 
  filter(registration_analyzed != "Inactive listing") %>% nrow()


# percentage of all conformity status category for displayed listings
conformity_status %>% 
  st_drop_geometry() %>% 
  filter(registration_analyzed != "Inactive listing") %>% 
  count(registration_analyzed) %>% 
  mutate(per = n/sum(n))


### Geography of conformity status -------------------------------------------

# percentage of non-conform listings per area
LA %>% 
  st_join(conformity_status) %>% 
  filter(registration_analyzed != "Inactive listing",
         active >= max(active, na.rm = T) - days(30)) %>% 
  mutate(registration_analyzed = ifelse(registration_analyzed != "Conform",
                                        "Non-conform", registration_analyzed)) %>% 
  count(area.x, registration_analyzed) %>% 
  group_by(area.x) %>% 
  mutate(non_conform_per = n/sum(n)) %>% 
  filter(registration_analyzed == "Non-conform") %>%
  ggplot()+
  geom_sf(aes(fill = non_conform_per), colour = "white") +
  scale_fill_gradientn(colors = col_palette[c(6, 3, 1)], na.value = "grey80",
                       # limits = c(0, 0.5), oob = scales::squish, 
                       labels = scales::percent)  +
  guides(fill = guide_colourbar(title = "Non-conform listings in %",
                                title.vjust = 0.5)) + 
  theme_void()+
  geom_sf_text(aes(label = n), colour = "black")+
  ggtitle("      Percentage of non-conform listings (gradient) and\n      number of non-conform listings (numerical) per local area")


### Non-conformity lucrativity ----------------------------------------------
property_lucrativity <- 
conformity_status %>% 
  filter(registration_analyzed != "Inactive listing",
         active >= max(active, na.rm = T) - days(30)) %>% 
  filter(listing_type == "Entire home/apt")

# revenue per listing since COVID
revenue_covid <- 
daily %>% 
  filter(status == "R", date >= key_date_covid) %>%
  group_by(property_ID) %>% 
  summarize(revenue = sum(price), first_reserved = min(date)) %>% 
  mutate(revenue = revenue / as.numeric(max(daily$date) - first_reserved)) %>% 
  filter(revenue != Inf)

property_lucrativity %>% 
  st_drop_geometry() %>% 
  left_join(revenue_covid, by = "property_ID") %>% 
  group_by(registration_analyzed) %>% 
  summarize(`Revenue per day` = round(mean(revenue, na.rm = T), digit = 2)) %>%
  mutate(label = str_glue("{`Revenue per day`}$")) %>% 
  ggplot()+
  geom_bar(stat = "identity", aes(registration_analyzed, `Revenue per day`, fill = registration_analyzed))+
  xlab("")+
  ylab("Average daily revenue")+
  ggtitle("Average daily revenue since COVID-19, per registration conformity")+
  guides(x = guide_axis(angle = 10))+
  scale_fill_manual(name = "Registration conformity", values = col_palette[c(4, 2, 3, 6)])+
  geom_text(aes(registration_analyzed, `Revenue per day`, label = label), vjust=1.6, color="white")+
  theme_minimal()

# Conform vs non-conform listings, average daily revenue
property_lucrativity %>% 
  st_drop_geometry() %>% 
  left_join(revenue_covid, by = "property_ID") %>% 
  mutate(registration_analyzed = ifelse(registration_analyzed != "Conform",
                                        "Non-conform", registration_analyzed)) %>% 
  group_by(registration_analyzed) %>% 
  summarize(`Revenue per day` = round(mean(revenue, na.rm = T), digit = 2))
    
  
# revenue per listing since regulations
revenue_regulations <- 
  daily %>% 
  filter(status == "R", date >= key_date_regulations) %>%
  group_by(property_ID) %>% 
  summarize(revenue = sum(price), first_reserved = min(date)) %>% 
  mutate(revenue = revenue / as.numeric(max(daily$date) - first_reserved)) %>% 
  filter(revenue != Inf)

property_lucrativity %>% 
  st_drop_geometry() %>% 
  left_join(revenue_regulations, by = "property_ID") %>%
  group_by(registration_analyzed) %>% 
  summarize(`Revenue per day` = round(mean(revenue, na.rm = T), digit = 2)) %>%
  mutate(label = str_glue("{`Revenue per day`}$")) %>% 
  ggplot()+
  geom_bar(stat = "identity", aes(registration_analyzed, `Revenue per day`, fill = registration_analyzed))+
  xlab("")+
  ylab("Average daily revenue ($)")+
  ggtitle("Average daily revenue since regulation, per registration conformity")+
  guides(x = guide_axis(angle = 10))+
  scale_fill_manual(name = "Registration conformity", values = col_palette[c(4, 2, 3, 6)])+
  geom_text(aes(registration_analyzed, `Revenue per day`, label = label), vjust=1.6, color="white")+
  theme_minimal()

# average nights available
available_covid <- 
  daily %>% 
  filter(status == "A", date >= key_date_covid) %>%
  group_by(property_ID) %>% 
  summarize(nights_available = n(), first_available = min(date)) %>% 
  mutate(nights_available = round(nights_available / as.numeric(max(daily$date) - first_available), digit=2)) %>% 
  filter(nights_available != Inf)

property_lucrativity %>% 
  st_drop_geometry() %>% 
  left_join(available_covid, by = "property_ID") %>% 
  group_by(registration_analyzed) %>% 
  summarize(nights_available = round(mean(nights_available, na.rm = T), digit = 2)) %>%
  mutate(label = str_glue("{nights_available}%")) %>%
  ggplot()+
  geom_bar(stat = "identity", aes(registration_analyzed, nights_available, fill = registration_analyzed))+
  xlab("")+
  ylab("Average nights available (%)")+
  ggtitle("Percentage of nights available since COVID-19, per registration conformity")+
  guides(x = guide_axis(angle = 10))+
  scale_fill_manual(name = "Registration conformity", values = col_palette[c(4, 2, 3, 6)])+
  geom_text(aes(registration_analyzed, nights_available, label = label), vjust=1.6, color="white")+
  theme_minimal()

# average nights reserved
reserved_covid <- 
  daily %>% 
  filter(status == "R", date >= key_date_covid) %>%
  group_by(property_ID) %>% 
  summarize(nights_reserved = n(), first_reserved = min(date)) %>% 
  mutate(nights_reserved = round(nights_reserved / as.numeric(max(daily$date) - first_reserved), digit=2)) %>% 
  filter(nights_reserved != Inf)

property_lucrativity %>% 
  st_drop_geometry() %>% 
  left_join(reserved_covid, by = "property_ID") %>% 
  group_by(registration_analyzed) %>% 
  summarize(nights_reserved = round(mean(nights_reserved, na.rm = T), digit = 2)) %>%
  mutate(label = str_glue("{nights_reserved}%")) %>%
  ggplot()+
  geom_bar(stat = "identity", aes(registration_analyzed, nights_reserved, fill = registration_analyzed))+
  xlab("")+
  ylab("Average nights available (%)")+
  ggtitle("Percentage of nights reserved since COVID-19, per registration conformity")+
  guides(x = guide_axis(angle = 10))+
  scale_fill_manual(name = "Registration conformity", values = col_palette[c(4, 2, 3, 6)])+
  geom_text(aes(registration_analyzed, nights_reserved, label = label), vjust=1.6, color="white")+
  theme_minimal()

