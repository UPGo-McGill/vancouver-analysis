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
qload("output/FREH_model.qsm", nthreads = availableCores())
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

# Commercial listings indexed
commercial_listings <- 
  daily %>% 
  filter(status != "B", date >= "2016-01-01") %>% 
  mutate(commercial = if_else(FREH_3 < 0.5 & !multi, FALSE, TRUE)) %>% 
  count(date, commercial) %>% 
  group_by(commercial) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6)) %>% 
  ungroup()

commercial_listings_bc <- 
  daily_bc %>% 
  filter(status != "B", date >= "2016-01-01") %>% 
  mutate(commercial = if_else(FREH_3 < 0.5 & !multi, FALSE, TRUE)) %>% 
  count(date, commercial) %>% 
  group_by(commercial) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6)) %>% 
  ungroup()


# YOY listings, revenue and reservation growth ------------------------------------------------

#' [1] YOY listing growth, COV 2018-2019
daily %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(n = n() / 365) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [2] YOY listing growth, CMA 2018-2019
daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(n = n() / 365) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [3] YOY reservation change, COV 2018-2019
daily %>% 
  filter(housing, status == "R", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(n = n()) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [4] YOY revenue change, COV 2018-2019
daily %>% 
  filter(housing, status == "R", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(revenue = sum(price)) %>% 
  summarize(change = (revenue[2] - revenue[1]) / revenue[1])

#' [5] YOY reservation change, CMA 2018-2019
daily_bc %>% 
  filter(housing, status == "R", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(n = n()) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [6] YOY revenue change, CMA 2018-2019
daily_bc %>% 
  filter(housing, status == "R", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(revenue = sum(price)) %>% 
  summarize(change = (revenue[2] - revenue[1]) / revenue[1])

# Regulatory impacts: displayed listings ------------------------------------------------------

displayed_listings <- 
  daily %>% 
  filter(housing) %>% 
  count(date, listing_type) %>% 
  group_by(listing_type) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6, .complete = TRUE)) %>% 
  ungroup()

displayed_listings <- 
  daily %>% 
  filter(housing) %>% 
  count(date) %>% 
  mutate(n = slide_dbl(n, mean, .before = 6, .complete = TRUE),
         listing_type = "All listings") %>% 
  bind_rows(displayed_listings) %>% 
  arrange(date, listing_type)

figure_3_2_1 <- 
  displayed_listings %>% 
  ggplot(aes(date, n, colour = listing_type, size = listing_type)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  geom_line() +
  scale_y_continuous(name = NULL, label = scales::comma) +
  scale_x_date(name = NULL, limits = c(as.Date("2016-01-01"), NA)) +
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1:3)],
                      guide = guide_legend(
                        override.aes = list(size = c(1.5, 0.75, 0.75, 0.75)))) +
  scale_size_manual(values = c("All listings" = 1.5, "Entire home/apt" = 0.75,
                               "Private room" = 0.75, "Shared room" = 0.75),
                    guide = "none") +
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank(),
        text = element_text(family = "Futura"))

ggsave("output/figures/figure_3_2_1.pdf", plot = figure_3_2_1, width = 8, 
       height = 5, units = "in", useDingbats = FALSE)

extrafont::embed_fonts("output/figures/figure_3_2_1.pdf")

# Actual and expected number of active listings after regulations -----------------------------

figure_3_2_2 <- 
  
ggsave("output/figures/figure_3_2_2.pdf", plot = figure_3_2_2, width = 8, 
         height = 5, units = "in", useDingbats = FALSE)

extrafont::embed_fonts("output/figures/figure_3_2_2.pdf")

# Regulations’ impact on commercialization ----------------------------------------------------

#' [1] Number of listings removed in August 2018 that were active during the year before
daily %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(n = n() / 365) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [2] Number of listings removed in August 2018 
daily %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(n = n() / 365) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [3] Number of listings considered as commercial the day they were removed


#' [4] Percentage of listings considered as commercial the day they were removed


figure_3_3_1 <- 

# Comparative analysis: CMA and CoV’s ---------------------------------------------------------

active_bc_2019 <- 
  daily_bc %>%
  filter(housing, status %in% c("R", "A"), date <= LTM_end_date, 
         date >= LTM_start_date) %>%
  pull(property_ID) %>% 
  unique()

revenue_bc_2019 <-
  daily_bc %>%
  filter(housing, status == "R", date <= LTM_end_date, 
         date >= LTM_start_date) %>%
  group_by(property_ID) %>%
  summarize(revenue_LTM = sum(price)) %>% 
  inner_join(property_bc, .)

revenue_2019 <-
  daily %>%
  filter(housing, status == "R", date <= LTM_end_date, 
         date >= LTM_start_date) %>%
  group_by(property_ID) %>%
  summarize(revenue_LTM = sum(price)) %>% 
  inner_join(property, .)

#' [1] Average active and blocked daily listings in 2019 CMA
daily_bc %>% 
  filter(housing, date >= LTM_start_date, date <= LTM_end_date) %>% 
  count(date, B = status == "B") %>% 
  group_by(B) %>% 
  summarize(round(mean(n), digit = -1))

#' [2] Average number of hosts (taking out blocked 365 days) CMA
daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date, 
         date <= LTM_end_date) %>%
  count(date, host_ID) %>% 
  count(date) %>% 
  summarize(hosts = round(mean(n), digit = -1))

#' [3] Total annual revenue CMA
prettyNum(round(sum(revenue_bc_2019$revenue_LTM), digit = -5), ",")

#' [4] Average revenue per active listing CMA
(sum(revenue_bc_2019$revenue_LTM) /
    daily_bc %>% 
    filter(housing, status != "B", date >= LTM_start_date, 
           date <= LTM_end_date) %>% 
    count(date) %>% 
    summarize(avg_rev_per_active = round(mean(n)))) %>% 
  round(digit = -2) %>% 
  prettyNum(",")

#' [5] Average revenue per active host CMA
(sum(revenue_bc_2019$revenue_LTM) /
    daily_bc %>% 
    filter(housing, status != "B", date >= LTM_start_date, 
           date <= LTM_end_date) %>%
    group_by(date) %>% 
    summarize(n_hosts = length(unique(host_ID))) %>% 
    summarize(avg_n_hosts = round(mean(n_hosts)))) %>% 
  round(digit = -2) %>% 
  prettyNum(",")

#' [6] Average revenue per active host COV
(sum(revenue_2019$revenue_LTM) /
    daily %>% 
    filter(housing, status != "B", date >= LTM_start_date, 
           date <= LTM_end_date) %>%
    group_by(date) %>% 
    summarize(n_hosts = length(unique(host_ID))) %>% 
    summarize(avg_n_hosts = round(mean(n_hosts)))) %>% 
  round(digit = -2) %>% 
  prettyNum(",")

#' [7] Active listings growth 2018-2019 CMA
daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(n = n() / 365) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [8] Active listings growth 2018-2019 COV
daily %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(n = n() / 365) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [9] Active listings by CMA region 
active_listings_bc 
  

# Active daily listings variation Cov vs CMA, indexed ---------------------------------------------------

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

figure_3_4_1 <- 
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

ggsave("output/figures/figure_3_4_1.pdf", plot = figure_3_4_1, width = 8, 
       height = 5, units = "in", useDingbats = FALSE)

extrafont::embed_fonts("output/figures/figure_3_4_1.pdf")


# Revenue Cov vs CMA, indexed ---------------------------------------------------

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

figure_3_4_2 <- 
  revenue_both %>%
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())

ggsave("output/figures/figure_3_4_2.pdf", plot = figure_3_4_2, width = 8, 
       height = 5, units = "in", useDingbats = FALSE)

extrafont::embed_fonts("output/figures/figure_3_4_2.pdf")


# FREH Cov vs CMA, indexed ---------------------------------------------------
#
## FREH indexed 
#FREH_indexed <- 
#  daily %>% 
#  filter(date >= key_date_regulations - years(1)) %>%
#  group_by(date) %>% 
#  summarize(n=sum(FREH_3)) %>% 
#  mutate(index = 100*n/n[date == key_date_regulations]) %>%
#  mutate(group = "CoV")
#
#FREH_bc_indexed <- 
#  daily_bc %>% 
#  filter(date >= key_date_regulations - years(1)) %>%
#  group_by(date) %>% 
#  summarize(n=sum(FREH_3)) %>% 
#  mutate(index = 100*n/n[date == key_date_regulations]) %>%
#  mutate(group = "CMA")
#
#FREH_both <- 
#  rbind(FREH_indexed, FREH_bc_indexed)
#
#FREH_both %>%
#  ggplot(aes(date, index, colour = group)) +
#  annotate("segment", x = key_date_covid, xend = key_date_covid,
#           y = -Inf, yend = Inf, alpha = 0.3) +
#  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
#           y = -Inf, yend = Inf, alpha = 0.3) +
#  geom_line(lwd = 1)+
#  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
#  scale_y_continuous(name = NULL) +
#  scale_x_date(name = NULL)+
#  theme_minimal() +
#  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())
#
#
# Commercial listings Cov vs CMA, indexed ---------------------------------------------------

# Commercial listings indexed 
commercial_listings_indexed <-
  commercial_listings %>% 
  filter(date >= key_date_regulations - years(1)) %>%
  filter(commercial == TRUE) %>% 
  mutate(index = 100*n/n[date == key_date_regulations]) %>%
  mutate(group = "CoV")

commercial_listings_bc_indexed <-
  commercial_listings_bc %>% 
  filter(date >= key_date_regulations - years(1)) %>%
  filter(commercial == TRUE) %>% 
  mutate(index = 100*n/n[date == key_date_regulations]) %>%
  mutate(group = "CMA")

commercial_listings_both <- 
  rbind(commercial_listings_indexed, commercial_listings_bc_indexed)

figure_3_4_3 <- 
  commercial_listings_both %>%
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())

ggsave("output/figures/figure_3_4_3.pdf", plot = figure_3_4_3, width = 8, 
       height = 5, units = "in", useDingbats = FALSE)

extrafont::embed_fonts("output/figures/figure_3_4_3.pdf")


# Spatial comparisons both sides of eastern boundary ---------------------------------------------------

# Prepare new objects
buffer_all_CoV <- st_buffer(st_cast(city,"MULTILINESTRING"),
                            1000, joinStyle = "MITRE", mitreLimit = 3)

buffer_VoC_Burnaby <- 
  st_intersection(select(st_cast(city,"MULTILINESTRING"), -everything()), 
                  select(filter(st_cast(CMA,"MULTILINESTRING"), name == "Burnaby (CY)"), -everything())) %>% 
  st_cast("LINESTRING") %>%
  st_buffer(dist = 1000, joinStyle="MITRE", mitreLimit=0.1)

# Properties within the buffer
property_buffer <- 
  property %>% 
  mutate(group = "CoV") %>% 
  select(property_ID, group) %>% 
  rbind(select(mutate(property_bc, group = "Burnaby"), property_ID, group)) %>%
  st_intersection(select(buffer_VoC_Burnaby, -everything()))

# Active listings within the buffer
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

# Active listings for the Burnaby-Vancouver buffer, indexed --------------------------------

active_listings_indexed <- 
  active_listings %>%
  filter(date >= key_date_regulations - years(1)) %>%
  group_by(group) %>% 
  mutate(index = 100*n/n[date == key_date_regulations])

figure_3_5_1 <- 
  active_listings_indexed %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 135, yend = 140, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 130,
           label = "COVID-19 \nAirbnb's response", family = "Futura Condensed") +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 130, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations", family = "Futura Condensed")+
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())

ggsave("output/figures/figure_3_5_1.pdf", plot = figure_3_5_1, width = 8, 
       height = 5, units = "in", useDingbats = FALSE)

extrafont::embed_fonts("output/figures/figure_3_5_1.pdf")


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

figure_3_5_2 <- 
  revenue_indexed %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 135, yend = 140, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 130,
           label = "COVID-19 \nAirbnb's response", family = "Futura Condensed") +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 130, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations", family = "Futura Condensed")+
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())

ggsave("output/figures/figure_3_5_2.pdf", plot = figure_3_5_2, width = 8, 
       height = 5, units = "in", useDingbats = FALSE)

extrafont::embed_fonts("output/figures/figure_3_5_2.pdf")

# Availabilities (R or A) for buffer ---------------------------------------------------

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

figure_3_5_3 <- 
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
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank()) #+
  #ggtitle("Availabilities (L) and reservations (A), 14 days rolling window")

ggsave("output/figures/figure_3_5_3.pdf", plot = figure_3_5_3, width = 8, 
       height = 5, units = "in", useDingbats = FALSE)

extrafont::embed_fonts("output/figures/figure_3_5_3.pdf")


# Prices variation after regulations for Burnaby and Vancou ----------------------------

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

figure_3_5_4 <- 
  avg_price_indexed %>% 
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 140, yend = 145, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-8-16"), y = 135,
           label = "COVID-19 \nAirbnb's response", family = "Futura Condensed") +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 125, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations", family = "Futura Condensed")+
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())

ggsave("output/figures/figure_3_5_4.pdf", plot = figure_3_5_4, width = 8, 
       height = 5, units = "in", useDingbats = FALSE)

extrafont::embed_fonts("output/figures/figure_3_5_4.pdf")


# Commercial listings buffer, indexed ---------------------------------------------------

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

figure_3_5_5 <- 
  commercial_listings_buffer_indexed %>%
  ggplot(aes(date, index, colour = group)) +
  annotate("segment", x = key_date_covid, xend = key_date_covid,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2020-07-01"), xend = key_date_covid + days(10),
           y = 140, yend = 145, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2020-06-16"), y = 135,
           label = "COVID-19 \nAirbnb's response", family = "Futura Condensed") +
  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
           y = -Inf, yend = Inf, alpha = 0.3) +
  annotate("curve", x = as.Date("2018-12-01"), xend = key_date_regulations + days(10),
           y = 130, yend = 125, curvature = .2, lwd = 0.25,
           arrow = arrow(length = unit(0.05, "inches"))) +
  annotate("text", x = as.Date("2018-12-01"), y = 127,
           label = "Regulations", family = "Futura Condensed") +
  geom_line(lwd = 1)+
  scale_colour_manual(name = NULL, values = col_palette[c(5, 1)])+
  scale_y_continuous(name = NULL) +
  scale_x_date(name = NULL)+
  theme_minimal() +
  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())

ggsave("output/figures/figure_3_5_5.pdf", plot = figure_3_5_5, width = 8, 
       height = 5, units = "in", useDingbats = FALSE)

extrafont::embed_fonts("output/figures/figure_3_5_5.pdf")


# FREH buffer, indexed ---------------------------------------------------
#
##FREH_buffer_indexed <- 
#  daily_buffer %>% 
#  filter(date >= key_date_regulations - years(1)) %>%
#  group_by(date, group) %>% 
#  summarize(n=sum(FREH_3)) %>% 
#  group_by(group) %>% 
#  mutate(index = 100*n/n[date == key_date_regulations]) 
#
#FREH_buffer_indexed %>%
#  ggplot(aes(date, index, colour = group)) +
#  annotate("segment", x = key_date_covid, xend = key_date_covid,
#           y = -Inf, yend = Inf, alpha = 0.3) +
#  annotate("segment", x = key_date_regulations, xend = key_date_regulations,
#           y = -Inf, yend = Inf, alpha = 0.3) +
#  geom_line(lwd = 1)+
#  scale_colour_manual(name = NULL, values = col_palette[c(3, 2)])+
#  scale_y_continuous(name = NULL) +
#  scale_x_date(name = NULL)+
#  theme_minimal() +
#  theme(legend.position = "bottom", panel.grid.minor.x = element_blank())