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

qload("output/str_processed.qsm", nthreads = availableCores())
qload("output/geometry.qsm", nthreads = availableCores())
load("output/registration.Rdata")


### Daily counts of displayed listings and licences ----------------------------

active_listings <- 
  daily %>% 
  data.table::setDT() %>% 
  count(date) %>% 
  rename(listings = n)

active_licences <- 
  BL_expanded %>% 
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


### Class by conformity --------------------------------------------------------

# Prepare a conformity vector
conformity_status <- 
  property %>% 
  left_join(select(BL, registration, issued, expired), by = "registration") %>% 
  filter(!is.na(ab_property)) %>% 
  mutate(registration_analyzed = ifelse(str_detect(registration, "\\d{2}-\\d{6}") & is.na(issued),
                                        "Fake licence", "TBD"),
         registration_analyzed = ifelse(str_detect(registration, "\\d{2}-\\d{6}") & !is.na(issued) & expired < "2020-10-13", 
                                        "Expired licence", registration_analyzed),
         registration_analyzed = ifelse(str_detect(registration, "\\d{2}-\\d{6}") & !is.na(issued) & expired > "2020-10-13",
                                        "Conform", registration_analyzed),
         registration_analyzed = ifelse(registration == "NO LISTING", 
                                        "Inactive listing", registration_analyzed),
         registration_analyzed = ifelse(registration == "EXEMPT", 
                                        "Exempt", registration_analyzed),
         registration_analyzed = ifelse(registration == "INVALID",
                                        "Invalid", registration_analyzed),
         registration_analyzed = ifelse(is.na(registration), 
                                        "No licence", registration_analyzed))

# Graphing the conformity status of active listings
conformity_status %>% 
  filter(active >= max(active, na.rm = T) - days(30),
         registration_analyzed != "Inactive listing") %>% 
  ggplot()+
  geom_histogram(stat = "count", aes(registration_analyzed, fill = registration_analyzed))+
  xlab("")+
  ylab("Number of listings")+
  guides(x = guide_axis(angle = 10))+
  # scale_fill_manual(name = "Registration conformity", values = col_palette[c(4, 1, 2, 3, 6)])+
  theme_minimal()


# percentage of all conformity status category for active listings
conformity_status %>% 
  st_drop_geometry() %>% 
  filter(registration_analyzed != "Inactive listing",
         active >= max(active, na.rm = T) - days(30)) %>% 
  count(registration_analyzed) %>% 
  mutate(per = n/sum(n))

# How many of the conform listings use a licence used by multiple listings
conformity_status %>% 
  st_drop_geometry() %>% 
  filter(registration_analyzed == "Conform",
         active >= max(active, na.rm = T) - days(30)) %>% 
  filter(listing_type == "Entire home/apt") %>% 
  count(registration) %>% 
  arrange(desc(n)) %>% 
  filter(n>1) %>% 
  summarize(sum(n)) %>% pull() /
  conformity_status %>% 
  st_drop_geometry() %>% 
  filter(registration_analyzed == "Conform",
         active >= max(active, na.rm = T) - days(30)) %>% 
  filter(listing_type == "Entire home/apt") %>% 
  nrow()


# Graphing the conformity status of displayed listings
conformity_status %>% 
  filter(registration_analyzed != "Inactive listing") %>%
  ggplot()+
  geom_histogram(stat = "count", aes(registration_analyzed, fill = registration_analyzed))+
  xlab("")+
  ylab("Number of listings")+
  guides(x = guide_axis(angle = 10))+
  # scale_fill_manual(name = "Registration conformity", values = col_palette[c(4, 1, 2, 3, 6)])+
  theme_minimal()


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


LA %>% 
  st_join(conformity_status) %>% 
  filter(registration_analyzed != "Inactive listing",
         active >= max(active, na.rm = T) - days(30)) %>% 
  mutate(registration_analyzed = ifelse(registration_analyzed != "Conform",
                                        "Non-conform", registration_analyzed)) %>% 
  count(area.x, registration_analyzed) %>% 
  group_by(area.x) %>% 
  mutate(non_conform_per = n/sum(n)) %>% 
  arrange(desc(non_conform_per))



### Non-conformity lucrativity table ------------------------------------------
entire_home_conformity <- 
  conformity_status %>% 
  st_drop_geometry() %>% 
  filter(registration_analyzed != "Inactive listing",
         active >= max(active, na.rm = T) - days(30)) %>% 
  filter(listing_type == "Entire home/apt") %>%
  select(property_ID, registration_analyzed)

daily_status <- 
daily %>% 
  filter(date >= key_date_covid,
         property_ID %in% entire_home_conformity$property_ID) %>%
  group_by(property_ID) %>% 
  count(status) %>% 
  mutate(sum_status = sum(n)) %>% 
  ungroup() %>% 
  pivot_wider(id_cols = c("property_ID", "sum_status"), names_from = "status", values_from = "n") %>% 
  mutate(A = ifelse(is.na(A), 0, A),
         R = ifelse(is.na(R), 0, R),
         B = ifelse(is.na(B), 0, B),
         per_A = A/sum_status,
         per_R = R/sum_status,
         per_B = B/sum_status) %>% 
  select(-sum_status, -A, -R, -B)

conformity_table <- 
  inner_join(entire_home_conformity, daily_status, by = "property_ID")

revenue_covid <- 
  daily %>% 
  filter(status == "R", date >= key_date_covid,
         property_ID %in% entire_home_conformity$property_ID) %>%
  group_by(property_ID) %>% 
  summarize(revenue = sum(price)) %>% 
  left_join(st_drop_geometry(select(conformity_status, property_ID, created)), by = "property_ID") %>% 
  mutate(created_or_covid = as.Date(ifelse(created <= key_date_covid, key_date_covid, created), origin = "1970-01-01")) %>% 
  mutate(revenue = revenue / as.numeric(max(daily$date) - created_or_covid)) %>% 
  filter(revenue != Inf) %>% 
  select(property_ID, revenue)
  
conformity_table <- 
  inner_join(conformity_table, revenue_covid, by = "property_ID") %>% 
  mutate(revenue = ifelse(is.na(revenue), 0, revenue))

revenue_regulations <- 
  daily %>% 
  filter(status == "R", date >= key_date_regulations,
         property_ID %in% entire_home_conformity$property_ID) %>%
  group_by(property_ID) %>% 
  summarize(revenue = sum(price)) %>% 
  left_join(st_drop_geometry(select(conformity_status, property_ID, created)), by = "property_ID") %>% 
  mutate(created_or_regulations = as.Date(ifelse(created <= key_date_regulations, key_date_regulations, created), origin = "1970-01-01")) %>% 
  mutate(revenue = revenue / as.numeric(max(daily$date) - created_or_regulations)) %>% 
  filter(revenue != Inf) %>% 
  select(property_ID, revenue_reg = revenue)

conformity_table <- 
  inner_join(conformity_table, revenue_regulations, by = "property_ID") %>% 
  mutate(revenue_reg = ifelse(is.na(revenue_reg), 0, revenue_reg))

non_conform <- 
conformity_table %>% 
  filter(registration_analyzed != "Conform", registration_analyzed != "Exempt") %>% 
  summarize(n = n(), across(per_A:revenue_reg, mean)) %>% 
  mutate(registration_analyzed = "Non-Conform")

all_listings <- 
  conformity_table %>% 
  summarize(n = n(), across(per_A:revenue_reg, mean))  %>% 
  mutate(registration_analyzed = "All listings")

conformity_table <- 
  all_listings %>% 
  rbind(
    conformity_table %>% 
      group_by(registration_analyzed) %>%
      summarize(n = n(), across(per_A:revenue_reg, mean))
  ) %>% 
  rbind(non_conform) %>% 
  select(registration_analyzed, everything())

conformity_table <- conformity_table[c(1,2,3,8,4,5,6,7),]

conformity_table %>% 
  set_names(c("Conformity status", "Number of listings", "Available", 
              "Reserved", "Blocked", "Revenue per night since COVID-19", 
              "Revenue per night since regulations")) %>% 
  gt() %>% 
  fmt_currency(
    columns = 6:7,
    currency = "CAD"
  ) %>% 
  fmt_percent(
    columns = 3:5, 
    decimals = 1)



### Commercial listings compliance ---------------------------------

commercial_2020 <- 
  daily %>% 
  filter(date >= "2020-01-01", # because current registration IDs starts at beginning of year
         FREH_3 >= 0.5 | multi) %>% 
  pull(property_ID) %>% unique()

conformity_status %>% 
  filter(property_ID %in% commercial_2020, 
         active >= max(active, na.rm = T) - days(30),
         registration_analyzed != "Inactive listing") %>% nrow()

conformity_status %>% 
  filter(property_ID %in% commercial_2020, 
         active >= max(active, na.rm = T) - days(30),
         registration_analyzed != "Inactive listing") %>% nrow()/
  conformity_status %>% 
  filter(active >= max(active, na.rm = T) - days(30),
         registration_analyzed != "Inactive listing") %>% nrow()

conformity_status %>% 
  st_drop_geometry() %>% 
  filter(property_ID %in% commercial_2020, 
         active >= max(active, na.rm = T) - days(30),
         registration_analyzed != "Inactive listing") %>% 
  count(registration_analyzed) %>% 
  mutate(per = n/sum(n))

conformity_status %>% 
  st_drop_geometry() %>% 
  filter(property_ID %in% commercial_2020, 
         active >= max(active, na.rm = T) - days(30),
         registration_analyzed != "Inactive listing") %>% 
  ggplot()+
  geom_histogram(stat = "count", aes(registration_analyzed, fill = registration_analyzed))+
  xlab("")+
  ylab("Number of listings")+
  guides(x = guide_axis(angle = 10))+
  # scale_fill_manual(name = "Registration conformity", values = col_palette[c(4, 1, 2, 3, 6)])+
  theme_minimal()




