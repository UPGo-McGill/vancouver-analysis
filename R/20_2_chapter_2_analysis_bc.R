#### 20 CHAPTER 2 BC ANALYSIS #####################################################

#' This script produces the tables and facts for chapter 2. It runs quickly.
#' 
#' Output:
#' - None
#' 
#' Script dependencies:
#' - `02_2_geometry_import_bc.R`
#' - `09_str_province.R`
#' 
#' External dependencies:
#' - None

source("R/01_startup.R")

load("output/str_province.Rdata")
load("output/geometry_bc.Rdata")

# Prepare new objects -----------------------------------------------------

# 2019 active
active_2019 <- 
  daily_bc %>%
  filter(housing, status %in% c("R", "A"), date <= LTM_end_date, 
         date >= LTM_start_date) %>%
  pull(property_ID) %>% 
  unique()

# 2019 revenue
revenue_2019 <-
  daily_bc %>%
  filter(housing, status == "R", date <= LTM_end_date, 
         date >= LTM_start_date) %>%
  group_by(property_ID) %>%
  summarize(revenue_LTM = sum(price)) %>% 
  inner_join(property_bc, .)


# Active daily_bc listings ---------------------------------------------------

#' [1] Average active and blocked daily_bc listings in 2019
daily_bc %>% 
  filter(housing, date >= LTM_start_date, date <= LTM_end_date) %>% 
  count(date, B = status == "B") %>% 
  group_by(B) %>% 
  summarize(round(mean(n), digit = -1))

#' [2] Average number of hosts (taking out blocked 365 days)
daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date, 
         date <= LTM_end_date) %>%
  count(date, host_ID) %>% 
  count(date) %>% 
  summarize(hosts = round(mean(n), digit = -1))

#' [3] Total annual revenue
prettyNum(round(sum(revenue_2019$revenue_LTM), digit = -5), ",")

#' [4] Average revenue per active listing
(sum(revenue_2019$revenue_LTM) /
    daily_bc %>% 
    filter(housing, status != "B", date >= LTM_start_date, 
           date <= LTM_end_date) %>% 
    count(date) %>% 
    summarize(avg_rev_per_active = round(mean(n)))) %>% 
  round(digit = -2) %>% 
  prettyNum(",")

#' [5] Average revenue per active host
(sum(revenue_2019$revenue_LTM) /
    daily_bc %>% 
    filter(housing, status != "B", date >= LTM_start_date, 
           date <= LTM_end_date) %>%
    group_by(date) %>% 
    summarize(n_hosts = length(unique(host_ID))) %>% 
    summarize(avg_n_hosts = round(mean(n_hosts)))) %>% 
  round(digit = -2) %>% 
  prettyNum(",")

#' [6] Average revenue per all listings
prettyNum(round(mean(revenue_2019$revenue_LTM), digit = -2), ",")

#' [7] Average revenue per all hosts
revenue_2019 %>% 
  # st_drop_geometry() %>% 
  filter(!is.na(host_ID)) %>%
  group_by(host_ID) %>% 
  summarize("host_rev" = sum(revenue_LTM)) %>% 
  summarize("avg_host_rev" = prettyNum(round(mean(host_rev), digit = -2), ","))

#' [8] Non-housing active listings
daily_bc %>% 
  filter(!housing, status != "B", date >= LTM_start_date, 
         date <= LTM_end_date) %>%
  count(date) %>% 
  summarize(non_housing = round(mean(n), digit = -1))

#' [9] Date and amount of highest activity
daily_bc %>% 
  filter(housing, status != "B") %>% 
  count(date) %>% 
  filter(n == max(n)) %>% 
  group_by(date) %>% 
  summarize(daily_bc_max = round((n), digit = -1))

#' [10] Active listing YOY change
daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(1), 
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(active_listings = n() / 365,
            revenue = sum(price[status == "R"])) %>% 
  summarize(across(c(active_listings, revenue), ~{(.x[2] - .x[1]) / .x[1]}))


# STR growth rates --------------------------------------------------------

#' [1] YOY listing growth, 2016-2017
daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(3),
         date <= LTM_end_date - years(2)) %>% 
  group_by(year_2017 = date >= LTM_start_date - years(2)) %>% 
  summarize(n = n() / 365) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [2] YOY listing growth, 2017-2018
daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(2),
         date <= LTM_end_date - years(1)) %>% 
  group_by(year_2018 = date >= LTM_start_date - years(1)) %>% 
  summarize(n = n() / 365) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [3] YOY listing growth, 2018-2019
daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(n = n() / 365) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [4] YOY listing growth, 2019-2020
daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date,
         date <= LTM_end_date + years(1),
         (date <= "2019-07-31" | date >= LTM_start_date + years(1)),
         date != "2020-02-29") %>%
  group_by(year_2020 = date >= LTM_start_date + years(1)) %>% 
  summarize(n = n() / 181) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [5] YOY reservation change, 2018-2019
daily_bc %>% 
  filter(housing, status == "R", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(n = n()) %>% 
  summarize(change = (n[2] - n[1]) / n[1])

#' [6] Reservation counts, 2018-2019
daily_bc %>% 
  filter(housing, status == "R", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(n = n())

#' [7] YOY revenue change, 2018-2019
daily_bc %>% 
  filter(housing, status == "R", date >= LTM_start_date - years(1),
         date <= LTM_end_date) %>% 
  group_by(year_2019 = date >= LTM_start_date) %>% 
  summarize(revenue = sum(price)) %>% 
  summarize(change = (revenue[2] - revenue[1]) / revenue[1])

#' [8] YOY revenue change, 2019-2020
daily_bc %>% 
  filter(housing, status == "R", date >= LTM_start_date,
         date <= LTM_end_date + years(1),
         (date <= "2019-07-31" | date >= LTM_start_date + years(1)),
         date != "2020-02-29") %>%
  group_by(year_2020 = date >= LTM_start_date + years(1)) %>% 
  summarize(revenue = sum(price)) %>% 
  summarize(change = (revenue[2] - revenue[1]) / revenue[1])


# Location of STR listings and revenue ------------------------------------

CSD_breakdown <- 
  daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(1), 
         date <= LTM_end_date) %>% 
  group_by(date, CSD) %>% 
  summarize(n = n(),
            revenue = sum(price[status == "R"])) %>% 
  left_join(st_drop_geometry(CMA_CSDs)) %>% 
  group_by(CSD, dwellings) %>% 
  summarize(active_listings = mean(n[date >= LTM_start_date]),
            active_2018 = mean(n[date < LTM_start_date]),
            active_growth = (active_listings - active_2018) / active_2018,
            annual_rev = sum(revenue[date >= LTM_start_date]),
            rev_2018 = sum(revenue[date < LTM_start_date]),
            rev_growth = (annual_rev - rev_2018) / rev_2018,
            .groups = "drop") %>% 
  mutate(listings_pct = active_listings / sum(active_listings),
         listings_pct_dwellings = active_listings / dwellings,
         rev_pct = annual_rev / sum(annual_rev)) %>% 
  select(CSD, active_listings, active_growth, listings_pct,
         listings_pct_dwellings, annual_rev, rev_pct, rev_growth)

CSD_breakdown %>% 
  left_join(select(CMA_CSDs, -dwellings), by = "CSD") %>% 
  st_as_sf() %>% 
  ggplot()+
  geom_sf(aes(fill = active_listings))+
  geom_sf_text(aes(label = CSD), colour = "grey75", size = 3)

#' [1] Figures for Burnaby and Richmond
CSD_breakdown %>% 
  slice(c(4, 22))

#' [2] Figures for Surrey, CY NV and DM NV
CSD_breakdown %>% 
  slice(c(24, 18, 17))


#' Table 2.2
CSD_breakdown %>% 
  select(CSD, active_listings, active_growth, listings_pct_dwellings,
         annual_rev, rev_growth) %>% 
  set_names(c("CSD",
              "daily_bc active listings (average)",
              "Active listing year-over-year growth rate",
              "Active listings as % of dwellings",
              "Annual revenue (CAD)",
              "Annual revenue growth")) %>% 
  filter(`daily_bc active listings (average)` > 100) %>% 
  arrange(desc(`daily_bc active listings (average)`)) %>%
  mutate(`daily_bc active listings (average)` = 
           round(`daily_bc active listings (average)`, digit = -1),
         `Annual revenue (CAD)` = round(`Annual revenue (CAD)`),
         `Annual revenue (CAD)` = 
           paste0("$", str_sub(`Annual revenue (CAD)`, 1, -7), ".",
                  str_sub(`Annual revenue (CAD)`, -6, -6), " million")) %>%
  gt() %>% 
  tab_header(
    title = "CSD breakdown",
    subtitle = "CMA_CSDs with more than 100 daily_bc active listings average, 2019"
  ) %>%
  opt_row_striping() %>% 
  fmt_percent(columns = c(3:4, 6), decimals = 1) %>% 
  fmt_number(columns = 2,
             decimals = 0)

# Need to add CMA of Vancouver row, with % listings per dwelling
daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date, 
         date <= LTM_end_date) %>% 
  count(date) %>% 
  summarize(active_listings = round(mean(n), digit = -1)) %>% 
  pull(active_listings) %>% 
  {. / sum(CMA_CSDs$dwellings)}


# Listing types and sizes -------------------------------------------------

listing_type_breakdown <- 
  daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date,
         date <= LTM_end_date) %>% 
  group_by(listing_type) %>% 
  summarize(
    active_listings = n() / 365,
    revenue = sum(price[status == "R"]),
    .groups = "drop") %>% 
  mutate(pct_of_listings = active_listings / sum(active_listings),
         pct_of_revenue = revenue / sum(revenue))

listing_type_breakdown <- 
  daily_bc %>% 
  filter(housing, status != "B", date >= LTM_start_date - years(1), 
         date <= LTM_end_date - years(1)) %>% 
  group_by(listing_type) %>% 
  summarize(active_2018 = n() / 365) %>% 
  left_join(listing_type_breakdown, .) %>% 
  mutate(pct_listing_growth = (active_listings - active_2018) / active_2018) %>% 
  select(-active_2018)

#' [1] Bedroom counts
property_bc %>% 
  st_drop_geometry() %>% 
  filter(property_ID %in% active_2019, listing_type == "Entire home/apt") %>% 
  mutate(bedrooms = if_else(bedrooms >= 3, "3+", as.character(bedrooms))) %>% 
  count(bedrooms) %>% 
  mutate(percentage = n / sum(n))

#' [2] EH listings and revenue
listing_type_breakdown %>% 
  filter(listing_type == "Entire home/apt") %>% 
  select(-active_listings, -revenue)

#' Table 2.3
listing_type_breakdown %>%
  mutate(active_listings = round(active_listings, digits = -1),
         revenue = round(revenue, digits = -5),
         pct_of_listings = round(pct_of_listings, digits = 3),
         pct_of_revenue = round(pct_of_revenue, digits = 3),
         pct_listing_growth = round(pct_listing_growth, digits = 3)) %>% 
  rename(`Listing type` = listing_type,
         `daily_bc active listings (average)` = active_listings,
         `Annual revenue (CAD)` = revenue,
         `% of active listings` = pct_of_listings,
         `% of annual revenue` = pct_of_revenue,
         `% average daily_bc listing growth (YOY 2018-2019)` = pct_listing_growth
  ) %>% 
  gt() %>% 
  tab_header(
    title = "Listing type breakdown",
    subtitle = "2019"
  ) %>%
  opt_row_striping() %>% 
  fmt_percent(columns = 4:6, decimals = 1) %>% 
  fmt_number(columns = 2, decimals = 0) %>% 
  fmt_currency(columns = 3, decimals = 0)


# Revenue distribution ----------------------------------------------------

host_rev <-
  daily_bc %>%
  filter(housing, date >= LTM_start_date, date <= LTM_end_date, 
         status == "R", !is.na(host_ID)) %>%
  group_by(host_ID) %>%
  summarize(rev = sum(price))


#' [1] Median host revenue
median(host_rev$rev) %>% round(-2)

#' [2] Top earner
max(host_rev$rev) %>% round(-5)

#' [3] Hosts above $250,000
host_rev %>% 
  filter(rev >= 250000) %>% 
  nrow()

#' [4] Total annual revenue
prettyNum(round(sum(revenue_2019$revenue_LTM), digit = -5), ",")

#' [5] Top 10% revenue
host_rev %>% summarize(top_10 = sum(rev[rev > quantile(rev, .9)]) / sum(rev))

#' [6] Top 5% revenue
host_rev %>% summarize(top_10 = sum(rev[rev > quantile(rev, .95)]) / sum(rev))

#' [7] Top 1% revenue
host_rev %>% summarize(top_10 = sum(rev[rev > quantile(rev, .99)]) / sum(rev))

#' Table 2.5
host_rev %>% 
  pull(rev) %>% 
  quantile() %>% 
  as.list() %>% 
  as_tibble() %>% 
  select(-`0%`) %>% 
  set_names(c("25th percentile", "Median", "75th percentile", 
              "100th percentile")) %>% 
  mutate_all(round, -2) %>% 
  drop_na() %>% 
  gt() %>% 
  tab_header(
    title = "Host income",
  ) %>%
  opt_row_striping() 


#' # Multilistings -----------------------------------------------------------
#' 
#' commercial_listings <- 
#'   daily_bc %>% 
#'   filter(status != "B", date >= "2016-01-01") %>% 
#'   mutate(commercial = if_else(FREH_3 < 0.5 & !multi, FALSE, TRUE)) %>% 
#'   count(date, commercial) %>% 
#'   group_by(commercial) %>% 
#'   mutate(n = slide_dbl(n, mean, .before = 6)) %>% 
#'   ungroup()
#' 
#' 
#' 
#' #' [1] Bedrooms
#' property_bc %>% 
#'   filter(housing, created <= LTM_end_date, scraped >= LTM_start_date, 
#'          listing_type == "Entire home/apt", !is.na(bedrooms)) %>% 
#'   st_drop_geometry() %>% 
#'   summarize(bedrooms_3_or_fewer = mean(bedrooms <= 3))
#' 
#' #' [1] 2019 ML listings
#' daily_bc %>% 
#'   filter(housing, status != "B", date >= LTM_start_date, 
#'          date <= LTM_end_date) %>% 
#'   count(multi) %>% 
#'   summarize(multi_listings = n[2] / sum(n))
#' 
#' #' [2] 2019 ML revenue
#' daily_bc %>% 
#'   filter(housing, status == "R", date >= LTM_start_date, 
#'          date <= LTM_end_date) %>% 
#'   group_by(multi) %>% 
#'   tally(price) %>% 
#'   summarize(multi_rev = n[2] / sum(n))
#' 
#' #' [3] June 2020 ML revenue
#' daily_bc %>% 
#'   filter(housing, status == "R", date >= "2020-06-01", date <= "2020-06-30") %>% 
#'   group_by(multi) %>% 
#'   tally(price) %>% 
#'   summarize(multi_rev = n[2] / sum(n))
#' 
#' #' The pinnacle in the number of commercial listings in 2018 was 3,270 [1] in 
#' #' August, and this figure was close to being reached exactly one year 
#' #' later at 3,190 [2.
#' 
#' #' [1] Peak of commercial listings in 2018
#' commercial_listings %>% 
#'   filter(date >= "2018-01-01", date <= "2018-12-31", commercial) %>% 
#'   arrange(desc(n)) %>% 
#'   slice(c(1)) %>% 
#'   mutate(n = round(n, -1))
#' 
#' #' [2] Peak of commercial listings in 2019
#' commercial_listings %>% 
#'   filter(date >= "2019-01-01", date <= "2019-10-01", commercial) %>% 
#'   arrange(desc(n)) %>% 
#'   slice(c(1)) %>%
#'   mutate(n = round(n, -1))

# Clean up ----------------------------------------------------------------

rm(active_tenure_2017, active_tenure_2019, CSD_tenure, CMA_CSDs,
   CSD_breakdown, CMA_CSDs_raw, city, commercial_listings, DA_CMA,
   DA_CMA_probabilities_2017, DA_CMA_probabilities_2019, host_rev, 
   listing_probabilities_2017, listing_probabilities_2019, 
   listing_type_breakdown, national_comparison, province, revenue_2019,
   streets, streets_downtown, tenure_breakdown, active_2019, high_condos)
