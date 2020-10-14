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

### Tidy data  --------------------------------------------------------------

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


### Look at their conformity ------------------------------------------------
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
  ylab("Listing number")+
  guides(x = guide_axis(angle = 10))+
  scale_fill_discrete(name = "Registration conformity")

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


# Graphing the conformity status of all scrapable listings
conformity_status %>% 
  filter(registration_analyzed != "Inactive listing") %>%
  ggplot()+
  geom_histogram(stat = "count", aes(registration_analyzed, fill = registration_analyzed))+
  xlab("")+
  ylab("Listing number")+
  guides(x = guide_axis(angle = 10))+
  scale_fill_discrete(name = "Registration conformity")

# percentage of non-conform scrapable listings
conformity_status %>% 
  filter(registration_analyzed != "Inactive listing",
         registration_analyzed != "Conform") %>%
  nrow() /
  conformity_status %>% 
  filter(registration_analyzed != "Inactive listing") %>% nrow()

# percentage of all conformity status category for scrapable listings
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
  scale_fill_gradientn(colors = col_palette[c(3, 4, 1)], na.value = "grey80",
                       # limits = c(0, 0.5), oob = scales::squish, 
                       labels = scales::percent)  +
  guides(fill = guide_colourbar(title = "Non-conform listings in %",
                                title.vjust = 1)) + 
  theme_void()+
  geom_sf_text(aes(label = n), colour = "black")+
  ggtitle("      Percentage of non-conform listings in color, and absolute number\n      of non-conform listings on local area")
