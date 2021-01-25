---
title: "Short-term Rentals in the City of Vancouver: Regulatory Impact Analysis"
site: bookdown::bookdown_site
author: "David Wachsmuth, Maxime Bélanger De Blois and Cloé St-Hilaire"
date: "24 January 2021"
output: bookdown::html_book
new_session: yes
---
---
title: "Short-term Rentals in the City of Vancouver: Regulatory Impact Analysis"
site: bookdown::bookdown_site
author: "David Wachsmuth, Maxime Bélanger De Blois and Cloé St-Hilaire"
date: "24 January 2021"
output: bookdown::html_book
new_session: yes
---

\newpage

<!--chapter:end:index.Rmd-->

# Executive summary {-}

**This report analyzes the effect of the City of Vancouver’s short-term rental (STR) regulations, with specific reference to their initial 2018 implementation and to the 2020 Covid-19 pandemic. It assesses the impact of the City’s STR regulations on the size and character of the STR market, and compares Vancouver’s performance with peer cities and with the rest of Metro Vancouver. And it provides an analysis of STR units that have returned to the longer-term rental market during the pandemic, describing their spatial distribution, asking rents, the extent to which they are commercial operations, and whether they are likely to return to the STR market when conditions improve.**

\noindent\rule{\textwidth}{1pt}

**SHORT-TERM RENTALS IN VANCOUVER: REGULATORY IMPACTS**

- The City of Vancouver’s STR licensing system has significantly and durably reduced the size of Vancouver’s STR market and the domination of the market by dedicated commercial operators. Vancouver now fares substantially better on these metrics than either its peer cities Montreal and Toronto or the rest of the Metro Vancouver region.
- The 2018 implementation of the City’s regulations created a one-time negative shock in the number of listings displayed on STR platforms in Vancouver, which dropped by 2,540, or 30.8% of the total displayed listings. This decline was disproportionately concentrated among listings which were present on STR platforms but not actively being rented; active listings dropped by 810, or 17.8%.
- Over the longer-term, we estimate that the regulations have reduced active STR listings by 1,510, or 35.8% of the total number of listings in the second half of 2019. The plausible range is 600to 1,670, and comparisons with other jurisdictions uniformly suggest that the real impact is at the higher end of this range.
- We estimate that the City’s regulations have returned 810 housing units to the long-term market, compared to the counter-factual scenario where the regulations were not in place. This is 38.9% of the average number of dedicated entire-home STRs taking housing off the Vancouver market in the second half of 2019. The plausible range for housing units returned to the market by the City’s regulations is quite large—from 160 to 990—but again, comparison with other jurisdictions suggests that the real impact is at the higher end of this range.
- Before the onset of the Covid-19 pandemic there were still upward of 2,500 housing units operating as dedicated STRs in Vancouver.

**COVID-19: STRS RETURNING TO THE LONG-TERM MARKET**

- Due to the combination of the City of Vancouver's ongoing STR regulations and the collapse in tourism demand during the COVID-19 pandemic, the number of STRs operating in a fashion consistent with being dedicated, full-time operations in Vancouver is the lowest it has been since at least 2016. Because of the collapse of STR demand during the COVID-19 pandemic, the number of housing units being operated as dedicated STRs in Vancouver dropped from 2,680 in January 2020 to just 940 in August 2020. 
- Using image recognition techniques, we identified 1,339 unique Airbnb listings which were posted as long-term rentals (LTRs) on Craigslist or Kijiji between March and September 2020. 
- These former STRs have asking rents on average 25.6% higher than other LTR listings, but are correlated with a 13.5% decrease in overall asking rents in Vancouver.
- The evidence suggests that the overwhelming majority of STR listings transferred to LTR platforms are commercial operations.
- We estimate that 30.6% have fully transitioned back to the long-term market, 35.3% have been temporarily blocked on Airbnb and may return to being STRs in the future, and 34.1% failed to be rented on LTR platforms and instead remain active on Airbnb.

\newpage

<!--chapter:end:00-executive_summary.Rmd-->

# Introduction {-}

In October 2020, the Urban Politics and Governance research group (UPGo) at McGill University was commissioned by the City of Vancouver to conduct market research and analysis on the impact of the City’s April 2018 regulations on short-term rentals as well as the impact of the COVID-19 pandemic on the short-term rental market in the City of Vancouver. The group also investigated the possibility that short-term rentals are returning to the long-term market because of the pandemic. This report will shed light on the following topics: 

- The impact of the City of Vancouver’s STR registration system on the operation of short-term rentals in the City.
- Information about STRs returning to the LTR market during the COVID-19 pandemic, including the number of listings that have returned; their spatial distribution, size and asking rents; the extent to which they are commercial operations or casual home sharing operations; and whether they are likely to return to the STR market when conditions improve.

Data and methodology are discussed in the Appendix, and all the code used to generate the analysis in the report is available online at https://github.com/UPGo-McGill/vancouver-analysis. 

\newpage

<!--chapter:end:00-introduction.Rmd-->

# Short-term rentals in Vancouver: Regulatory impacts

<style type="text/css">
  body{
  font-family: Futura, Helvetica, Arial;
}
</style>

<br>

















**The City of Vancouver's STR licensing system has significantly and durably reduced the size of Vancouver's STR market and the domination of the market by dedicated commercial operators. Vancouver now fares substantially better on these metrics than either its peer cities Montreal and Toronto or the rest of the Metro Vancouver region. The 2018 implementation of the City's regulations created a one-time negative shock in the number of listings displayed on STR platforms in Vancouver, which dropped by 2,540, or 30.8% of the total displayed listings. This decline was disproportionately concentrated among listings which were present on STR platforms but not actively being rented; active listings dropped by 810, or 17.8%. Over the longer-term, we estimate that the regulations have reduced active STR listings by 1,510, or 35.8% of the total number of listings in the second half of 2019. We estimate that the City's regulations have returned 810 housing units to the long-term market, compared to the counter-factual scenario where the regulations were not in place. This is 38.9% of the average number of dedicated entire-home STRs taking housing off the Vancouver market in the second half of 2019. Before the onset of the Covid-19 pandemic there were still upward of 2,500 housing units operating as dedicated STRs in Vancouver.**

<br>

## The City of Vancouver's STR regulations

In April 2018, the City of Vancouver enacted regulations on the operations of short-term rentals in the City, defined as rentals offered for thirty or fewer consecutive days (City of Vancouver, 2020a). Under these regulations, each STR operator is required to obtain a license for their rental unit; these licenses are only issued for STRs operated out of a host’s principal residence, and are valid for a single calendar year. Licensed listings can either be the entire principal residence or individual rooms within the residence. Although the regulations apply to STRs listed on any platform, Airbnb is the only STR platform that agreed to require hosts in Vancouver to fill out a license field in their online listing, to engage in data sharing, and to undertake operator education (City of Vancouver, 2020b). In August 2018, shortly before the City's announced start date for enforcement of the registration system, Airbnb removed approximately 2,400 listings which had not received licenses.

In what follows we assemble evidence about the of the City's regulations on the STR market. Given the significant restraints which the regulations impose on the market, their impacts should be highly visible if the regulations have been effective. If, by contrast, few impacts can be discerned, that implies that the regulations have not been effective. We carry out this task by analyzing the trajectory of STR activity in the City of Vancouver over time, and by comparing the City with a set of peer jurisdictions. This analysis collectively demonstrates that the City’s STR regulations have been effective at reducing STR activity and growth in Vancouver, and have accomplished that reduction in part by driving incoming visits to other municipalities within Metro Vancouver.

## The trajectory of post-regulation STR activity in Vancouver



The impact of the City's regulations can be directly measured in two ways: changes in the total number of listings on STR platforms in Vancouver, and changes in commercial listings which are highly likely to be non-compliant. Because all Vancouver STR listings are required to be licensed whether or not they are active, in Figure \@ref(fig:fig-3-1) we show the total number of listings displayed each day alongside our standard metric of active daily listings. Displayed listings comprise active listings (i.e. listings which are either reserved or available for reservation) and inactive (blocked) listings which are visible on Airbnb or VRBO. Both indicators show a sharp drop following Airbnb's mass removal of non-licensed listings in August 2018, but the decline is proportionally twice as large for displayed listings, which decreased 2,540 (30.8%) from August 20 to September 7, as it is for active listings, which decreased 810 (17.8%) over the same date range. Furthermore, displayed listings have never come close to regaining their pre-regulation numbers in Vancouver, while active listings had mostly recovered by the summer of 2019, a year after Airbnb's mass removal. Put differently, a disproportionate share of the large decline in STRs which followed Airbnb's mass removal was listings which were not actually in use on the platform anymore.

<div class="figure" style="text-align: center">
<img src="01-regulatory_impacts_files/figure-html/fig-3-1-1.png" alt="(ref:fig-3-1)" width="672" />
<p class="caption">(ref:fig-3-1)</p>
</div>

(ref:fig-3-1) _Displayed and active listings in the City of Vancouver (7-day average)_



Trend analysis allows for a more precise estimate of the impact of regulation on active listings. Figure \@ref(fig:fig-3-2) compares the actual number of active listings with two scenarios for the listings which would have been expected based on pre-August-2018 trends. The red line is a scenario where the growth rate of active listings from the previous two years continued into 2019. This is the most plausible "business as usual" scenario for what "natural" STR listing growth in Vancouver might have looked like in the absence of regulations. The lower, blue line is a scenario where aggregate growth in active listings stops, although seasonal variation continues. This latter scenario represents a lower bound on what the STR market might have looked like in the absence of regulations. The higher, green line is a scenario where Vancouver's STR market followed the trend of Toronto's market from mid-2018 onward. This is a quite similar to, although slightly higher than, the continued-growth scenario. (As we discuss below, the no-growth scenario is similar to Montreal's STR market trajectory.)

<div class="figure" style="text-align: center">
<img src="01-regulatory_impacts_files/figure-html/fig-3-2-1.png" alt="(ref:fig-3-2)" width="672" />
<p class="caption">(ref:fig-3-2)</p>
</div>

(ref:fig-3-2) _Actual and expected active listings after implementation of regulations_

What Figure \@ref(fig:fig-3-2) demonstrates is that, under any scenario, the City's regulations have had two different impacts on the number of active listings in Vancouver. The first is a one-time negative shock corresponding to Airbnb's mass listing removal, which has proven to be at least partially temporary. As of mid-2019, active listings were closer to their post-shock level than in the early days of the registration system in 2018. (The shaded areas of the graph show the difference between each of the scenarios and the actual number of active listings at any point in time, and the size of the shaded area is largest in late 2018 and early 2019.) The second impact is a more durable shift downward in the STR listing growth curve. In the second half of 2019, the average difference between actual active listings and the two no-regulation counterfactuals was 1,510 under the continued-growth scenario, 600 under the no-growth scenario, and 1,670 under the Toronto-growth scenario. Based on the interjurisdictional comparisons performed below, we believe that the continued-growth scenario is the most plausible. Our conclusion is therefore that the City's STR regulations have, in the long-term, likely resulted in 1,510 fewer active listings in Vancouver's STR market each day. This number represents 35.8% of the total number of active STRs in the city. The plausible lower and upper bounds, meanwhile, are 600 - 1,670, which is 14.2% - 39.5% of the total number of active STRs in the city.

## Commercial STR operations



Since the 2018 regulations do not prohibit short-term rentals but merely limit them to hosts' principal residences, the fact that active listings in Vancouver have been significantly reduced by the regulations is not on its own decisive evidence of the effectiveness of the regulations. A harder to measure—but arguably more important—metric is the number of commercial STRs operating in Vancouver, given that they are necessarily non-compliant with the City's regulations. 

We measure commercial STRs in two ways. First, we measure the number of frequently-rented STR units, which are the simplest way to estimate STR-induced housing loss. If a STR is available for reservations the majority of the year and receives many bookings, it is reasonable to assume that it is not serving as an individual’s principal residence at the same time. Along these lines, we define frequently rented entire-home (FREH) listings as entire-home listings which were available on Airbnb or VRBO the majority of the year (at least 183 nights) and were booked a minimum of 90 nights. We then apply a statistical model (described in the appendix) to the FREH data in order to generate an estimate of FREH activity based on three months of listing activity. This allows us to detect listings which are operating in a full-time manner but have not yet been listed for an entire year, and allows us to account for relatively short-term changes in market conditions.

Secondly, we identify "multilistings"—STR listings operated by hosts which are simultaneously operating other listings. Some hosts operate multiple STR units, which can be an indication of a commercial operator rather than a casual home sharer. To take the simplest case, a host with two or more entire-home listings active on the same day cannot be operating both listings out of their principal residence, regardless of the frequency they are rented throughout the year. This means that these operators are not respecting the by-law, which prevents a person from operating a STR outside their principal residence. We consider entire-homes to be multilistings if they are operated by hosts who are simultaneously operating other entire-home listings. We define private-room multilistings as cases where a host has three or more private-room listings operating on the same day. Since 93.8% of entire-home listings have three or fewer bedrooms, there will be extremely few cases where a host operating three private-room STR listings in a dwelling unit has not converted the entire unit into a dedicated STR. Intuitively, multilistings that are still operating since the City’s STR regulations were enacted in April 2018 are almost certainly non-compliant.

Figure \@ref(fig:fig-3-3) decomposes the trajectory of active listings shown above (in Figure \@ref(fig:fig-3-1)) into commercial and non-commercial listings. The former are all listings which are either frequently rented entire-home (FREH) listings or multilistings. The graph shows that non-commercial listings experienced a noticeable drop when Airbnb carried out its August 2018 mass listing removal, but that the number of these listings was already in decline. The quantity of commercial listings, meanwhile, experienced a much sharper drop in August 2018 (21.6% of all commercial listings were removed by Airbnb) and continued to decline for the rest of 2018. Commercial operations recovered throughout 2019, however, and reached a new all-time high (3,090) by the end of 2019.

<div class="figure" style="text-align: center">
<img src="01-regulatory_impacts_files/figure-html/fig-3-3-1.png" alt="(ref:fig-3-3)" width="672" />
<p class="caption">(ref:fig-3-3)</p>
</div>

(ref:fig-3-3) _Non-commercial and commercial active daily listings in Vancouver (7-day average)_



Narrowing in on frequently rented entire-home (FREH) listings, Figure \@ref(fig:fig-3-4) offers a closer look at how the actual number of FREH listings compares with three scenarios where the mid-2018 regulations are not enacted: a growth-as-usual scenario where the FREH growth trend from the previous two years continues, a no-growth scenario where FREH growth had stopped by the time that the City's regulations were enacted, and a Toronto trend where FREH growth post-regulation followed the same growth rate as Toronto. Unlike the trend analysis of all active listings, above, where under all scenarios the regulations are likely to have substantially reduced the number of daily active listings, the effect of the City's regulations on commercial listings is highly sensitive to the scenario chosen. In the second half of 2019, the average difference between actual commercial listings and the two no-regulation counterfactuals was 810 under the continued-growth scenario, 160 under the no-growth scenario, and 990 under the Toronto-growth scenario. This is an six-fold difference. As with active listings above, we consider it most likely that FREH listing growth would have continued on its pre-regulation trend, and thus that the City's regulations have returned 810 housing units to the long-term market—a reduction of 38.9%. But the actual number could plausibly be anywhere within the range 160 - 990, or 7.6% - 47.4% of the average number of FREH listings which were active on STR platforms in the second half of 2019.

<div class="figure" style="text-align: center">
<img src="01-regulatory_impacts_files/figure-html/fig-3-4-1.png" alt="(ref:fig-3-4)" width="672" />
<p class="caption">(ref:fig-3-4)</p>
</div>

(ref:fig-3-4) _Actual and expected FREH listings after implementation of regulations_



Applying the same modelling to multilistings, we estimate that the City's regulations have reduced the number of these commercial STR operations by 620, which corresponds to the continued-growth scenario, and is 42.5% of the total amount of multilistings still active in Vancouver in late 2019. Two lower estimates, corresponding to the no-growth and Toronto-growth scenarios respectively, are 110 and 110. To be clear, however, in a scenario where the City's regulations were perfectly enforced, the value for the "actual FREH listings" and "actual multilistings" lines in Figure \@ref(fig:fig-3-4) and Figure \@ref(fig:fig-3-4a) would be zero, given that all non-principal-residence STRs are forbidden under the rules. Even allowing for some error in the measurement of commercial operators, at the end of 2019 there were almost certainly 2,500 or more listings operating in violation of the City's principal residence rules.

<div class="figure" style="text-align: center">
<img src="01-regulatory_impacts_files/figure-html/fig-3-4a-1.png" alt="(ref:fig-3-4a)" width="672" />
<p class="caption">(ref:fig-3-4a)</p>
</div>

(ref:fig-3-4a) _Actual and expected multilistings after implementation of regulations_


## The City of Vancouver in comparison with Montreal and Toronto

The preceding analysis varies significantly with the underlying assumptions being made about the growth of Vancouver's STR market prior to the introduction of the City's regulations. If we assume that growth would have continued along its previous trajectory, then the regulations have had a major impact on the number of active listings, and in particular on the number of commercial operations. If growth were already leveling off prior to the introduction of the regulations, by contrast, then it is likely that the regulations have somewhat reduced the number of active listings, but have less effective at targeting the commercial operations which are not permitted under the rules. We also compared Vancouver's STR trajectories with the City of Toronto's, as 

There is no way to determine with certainty which of these scenarios would have occurred, but a promising strategy is to compare Vancouver with a set of similar jurisdictions which did not regulate their STR markets in mid-2018. In what follows we do this at multiple spatial scales, beginning with the other two largest STR markets in the country: Toronto and Montreal. The City of Toronto has recently implemented mandatory host registration and a principal-residence requirement which are very similar to Vancouver's rules, but these were not active during the study period. The City of Montreal has rules which vary across the city, but in the key central-city boroughs commercial short-term rentals are largely forbidden. However, with no registration system in place during the study period, it has been widely understood that Montreal's enforcement mechanisms have not been sufficiently strong to significantly affect the operation of commercial STRs. Toronto and Montreal thus represent zero- or low-regulation cases with which to compare Vancouver.





Figure \@ref(fig:fig-3-5) compares the active listing (left), FREH listing (middle), and multilisting (right) trajectories in Montreal, Toronto and Vancouver. (Commercial listings are disaggregated into FREH listings and multilistings in order to clarify the key patterns.) The figure lends significant weight to the conclusion that Vancouver's STR regulations have significantly reduced the commercial portion of the STR market. The left panel demonstrates that the growth trajectory of active listings in Vancouver was on a very similar trajectory to Montreal and Toronto prior to 2018. In 2018 the three cities diverged, with listings in Vancouver plummeting in response to the new registration system, listings in Toronto continuing to grow quickly, and listings in Montreal beginning a long period of stagnation and decline. By the end of 2019 Vancouver's active listings had caught up to Montreal's in relative terms (in both cases with total numbers similar to the beginning of 2017), but were far behind Toronto's, which grew by more than 50% from 2017 through 2019. Montreal was the first Canadian city to have a large STR market, driven by a combination of strong tourism and cheap housing (which incentivized conversions to STRs), and it has followed a trajectory comparable to other large tourist destinations—early growth then stagnation. Toronto and Vancouver began their periods of growth somewhat later, probably due in part to much higher housing prices reducing the financial incentives to operate STRs. Toronto thus represents the most likely counterfactual for how Vancouver's STR market would have evolved in the absence of regulations. Over the second half of 2019, Toronto had on average 38.9% more active listings than Vancouver, relative to each city's market size on January 1, 2017. In 2017, by contrast, the difference was only 1.0%. If the 2017 relationship between the two cities had remained consistent through 2019, Vancouver would have had 5,830 active listings at the end of the year—compared to the 4,230 listings it actually did. This establishes a plausible upper-bound estimate for the impact of the City of Vancouver's regulations on the number of active STR listings, and lends support to our 35.8% estimate for the impact of Vancouver's regulations on active STR listings.

<div class="figure" style="text-align: center">
<img src="01-regulatory_impacts_files/figure-html/fig-3-5-1.png" alt="(ref:fig-3-5)" width="672" />
<p class="caption">(ref:fig-3-5)</p>
</div>

(ref:fig-3-5) _Active listings (L), FREH listings (C), and multilistings (R) in Montreal, Toronto and Vancouver (2017-01-01 = 100)_

The divergence between Vancouver and Montreal and Toronto is even more significant with respect to commercial listings, which were prohibited by Vancouver's regulations but were either de jure (Toronto) or de facto (Montreal) permitted in the other cases. The center and right panels of Figure \@ref(fig:fig-3-5) show, respectively, the trajectory of FREH listings and multilistings in the three cities. In both cases the three cities were on highly similar growth trajectories through 2017. Montreal's FREH listings were growing at a 15.2% higher rate than Vancouver, while Toronto's FREH growth rate was identical to Vancouver's. Montreal's multilistings were growing at a 6.9% higher rate than Vancouver, while Toronto's were growing 2.1% faster. In the second half of 2019, by which point the temporary impacts of Airbnb's mass listing removal in Vancouver would have subsided, the commercial side of Vancouver's market looked dramatically different from either Montreal or Toronto. Montreal's FREH listings had grown 40.6% faster than Vancouver's, while Toronto's had grown an incredible 54.6% faster. The numbers are similar for multilistings: Montreal outpaced Vancouver by 18.4%, and Toronto outpaced Vancouver by 40.9%.

These differences are summarized in Table \@ref(tab:tab-MTV). They strongly support the conclusion that the City of Vancouver's regulations have durably reduced the commercial part of Vancouver's STR market. Our "growth-as-usual" counterfactual had suggested that the regulations have reduced FREH listings by 38.9% and multilistings by 42.5%. Comparison with Montreal and Toronto adds additional evidence suggesting that this estimate is plausible.

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>Montreal and Toronto listing trajectories in comparison with Vancouver (values are the growth rates since 1 January 2017 relative to Vancouver's growth rates in the same time period)</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> City </th>
   <th style="text-align:left;"> Time period </th>
   <th style="text-align:right;"> Active listings </th>
   <th style="text-align:right;"> FREH listings </th>
   <th style="text-align:right;"> Multilistings </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Montreal </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 2.3% </td>
   <td style="text-align:right;"> 15.2% </td>
   <td style="text-align:right;"> 6.9% </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 2019 (2H) </td>
   <td style="text-align:right;"> -3.0% </td>
   <td style="text-align:right;"> 40.6% </td>
   <td style="text-align:right;"> 18.4% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Toronto </td>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 1.0% </td>
   <td style="text-align:right;"> 0.0% </td>
   <td style="text-align:right;"> 2.1% </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> 2019 (2H) </td>
   <td style="text-align:right;"> 38.9% </td>
   <td style="text-align:right;"> 54.6% </td>
   <td style="text-align:right;"> 40.9% </td>
  </tr>
</tbody>
</table>

## The City of Vancouver in comparison with the rest of the Vancouver region







Another point of comparison for assessing the impact of the City's STR regulations is the rest of Metro Vancouver. While many visitors to Vancouver will be determined to stay within the City itself regardless of price or availability, others will be more flexible. So if the City's regulations have reduced the prevalence of commercial STRs, we should expect to see some redistribution of STR activity to neighbouring municipalities. We test this possibility by comparing the City of Vancouver with the remainder of the Vancouver Census Metropolitan Area (CMA), which is roughly coterminous with Metro Vancouver (Figure \@ref(fig:fig-3-6)).

<div class="figure" style="text-align: center">
<img src="01-regulatory_impacts_files/figure-html/fig-3-6-1.png" alt="(ref:fig-3-6)" width="672" />
<p class="caption">(ref:fig-3-6)</p>
</div>

(ref:fig-3-6) _The Vancouver Census Metropolitan Area (CMA)_

STR activity in the outlying municipalities of the Vancouver CMA is mostly concentrated in the cities of Richmond, Burnaby and Surrey, and there are substantial differences between the STR markets of the City of Vancouver and the these outlying municipalities. For example, the median listing in the City of Vancouver earned $7,200 in 2019, while the median listing in the rest of the CMA earned $5,800. However, examining the relative trajectories of listing growth since 2017, as was done above with Toronto and Montreal, provides additional context for the drop in active and commercial listings experienced in the City of Vancouver since mid-2018.



Figure \@ref(fig:fig-3-7) shows the relative trajectories of active listings, FREH listings, and multilistings for the City of Vancouver and the rest of the Vancouver CMA since 2017. It demonstrates dramatic and widening divergences between the two geographies. While throughout 2017 active listings were already growing 7.7% faster in the rest of the CMA than in Vancouver, by the second half of 2019 the difference was 77.2%. FREH listings and multilistings reveal even larger divergences, from 13.2% to 123.4% for FREH listings and from -1.6% to 63.1% for multilistings.

<div class="figure" style="text-align: center">
<img src="01-regulatory_impacts_files/figure-html/fig-3-7-1.png" alt="(ref:fig-3-7)" width="672" />
<p class="caption">(ref:fig-3-7)</p>
</div>

(ref:fig-3-7) _Active listings (L), FREH listings (C), and multilistings (R) in the City of Vancouver and the rest of the Vancouver CMA (2017-01-01 = 100)_

How much of this divergence can be explained by Vancouver's STR regulations? At least some of the divergence was already underway by the time the City implemented its new rules, and in particular by the time that Airbnb undertook its mass removal of listings in August 2018. However, the divergence between Vancouver and the rest of the region widened significantly after August 2018—from 31.0% to 73.7% for active listings, from 47.7% to 101.8% for FREH listings, and from 11.5% to 52.5% for multilistings (Table \@ref(tab:tab-bc)). This suggests that the regulations were the most important (although not only) force shifting STR activity from the City of Vancouver to outlying municipalities.

<table class="table" style="margin-left: auto; margin-right: auto;">
<caption>Vancouver CMA listing trajectories in comparison with the City of Vancouver (values are the growth rates since 1 January 2017 relative to the City of Vancouver's growth rates in the same time period)</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Time period </th>
   <th style="text-align:right;"> Active listings </th>
   <th style="text-align:right;"> FREH listings </th>
   <th style="text-align:right;"> Multilistings </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2017 </td>
   <td style="text-align:right;"> 7.7% </td>
   <td style="text-align:right;"> 13.2% </td>
   <td style="text-align:right;"> -1.6% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 before listing takedown </td>
   <td style="text-align:right;"> 31.0% </td>
   <td style="text-align:right;"> 47.7% </td>
   <td style="text-align:right;"> 11.5% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2018 after listing takedown </td>
   <td style="text-align:right;"> 73.7% </td>
   <td style="text-align:right;"> 101.8% </td>
   <td style="text-align:right;"> 52.5% </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2019 (2H) </td>
   <td style="text-align:right;"> 77.2% </td>
   <td style="text-align:right;"> 123.4% </td>
   <td style="text-align:right;"> 63.1% </td>
  </tr>
</tbody>
</table>





Another way to examine the relationship between the City of Vancouver and the rest of the CMA is to compare the proportion of total regional active listings, FREH listings and multilistings located in the central city with the same proportion in the Montreal and Toronto regions. Figure \@ref(fig:fig-3-8) shows this comparison, and makes clear that Vancouver's STR market has long had an atypical relationship with that of its surrounding municipalities. In Montreal and Vancouver, the central city dominates the regional STR market in terms of total active listings, and on top of that has disproportionately high shares of FREH listings and multilistings. While in both cases outlying municipalities are slowly increasing their share of the regional market, as of the end of 2019 the central cities still had between 75% and 90% of the regional share of the various listing types. Vancouver had both a substantially lower share of its regional STR market in 2016 (where the graph begins) and a much sharper decrease in regional share across all listing categories.

<div class="figure" style="text-align: center">
<img src="01-regulatory_impacts_files/figure-html/fig-3-8-1.png" alt="(ref:fig-3-8)" width="672" />
<p class="caption">(ref:fig-3-8)</p>
</div>

(ref:fig-3-8) _The share of active listings, FREH listings and multilistings in the central city of the Montreal, Toronto and Vancouver CMAs_

The fact that more STR activity is located in outer municipalities of the Vancouver region than in Montreal or Toronto is not surprising, given that the City of Vancouver makes up a much smaller part of its CMA than the other two cities. Vancouver's declining share of regional STR activity began well before the City's regulations were put into place. At the same time, the City's share of regional STR activity dropped noticeably in 2018, and the drop has proven to be durable. These facts suggest that the City's 2018 regulations accelerated a shift of STR activity from Vancouver to the neighbouring municipalities that was already underway. It is also notable that Vancouver now has a much smaller share of the region's multilistings than it does of active listings as a whole, but that it has a _higher_ share of FREH listings than it does of active listings as a whole. This pattern indicates that Vancouver's registration system has discouraged hosts from operating multiple listings simultaneously—a prima facie violation of the principal residence requirement—but that the system has not proven as effective at deterring full-time operation of a single listing, which is equally prohibited under the rules but arguably harder to detect.

## The eastern edge of the City of Vancouver in comparison with the western edge of the City of Burnaby







We conducted a final comparison at a smaller scale designed to directly assess the impact of the City's regulations on STR growth trajectories, by examining listings lying within one kilometre of the Vancouver-Burnaby border, in both Vancouver and Burnaby. Listings located in the study zone on either side of the Vancouver-Burnaby will be highly comparable from a visitor's perspective. The only significant difference between these listings is that some are located in the City of Vancouver, and are subject to its regulations, while some are located in the City of Burnaby, and are not. (We conducted an additional analysis of listings within walking distance of SkyTrain stations on both sides of the Vancouver border to reduce non-regulatory variations between listings even more, but the results were very similar to this analysis, so we have not presented them.) If listings in the study zone on the Vancouver side of the border display growth trajectories similar to their counterparts on the Burnaby side, this implies that the City's regulations are not meaningfully constraining STR operators in Vancouver. By contrast, if listings in the study zone on the Vancouver side of the border display growth trajectories dissimilar to their counterparts on the Burnaby side but similar to the rest of the City of Vancouver, this implies that the City's regulations are have a significant impact.

<div class="figure" style="text-align: center">
<img src="01-regulatory_impacts_files/figure-html/fig-3-9-1.png" alt="(ref:fig-3-9)" width="672" />
<p class="caption">(ref:fig-3-9)</p>
</div>

(ref:fig-3-9) _Study area for comparison: a 1-km strip on either side of the Vancouver-Burnaby border_



The results of the comparison, shown in Figure \@ref(fig:fig-3-10) are highly illuminating. Listings located in Vancouver but near the border with Burnaby have been on a growth trajectory which resembles nearby listings in Burnaby in some respects, and which resembles the rest of the City of Vancouver in others. First of all, growth trajectories across all listing types have been significantly lower in the Vancouver border listings than the Burnaby border listings since the implementation of the City's STR regulations in 2018. This provides clear and compelling evidence that the regulations have reduced STR activity. However, there is a substantial difference between the patterns with respect to FREH listings (dedicated STRs which have removed housing from the long-term market) and multilistings (listings operated by a host who is simultaneously operating other listings). Multilistings in the Vancouver border area have grown far less quickly since 2018 than their counterparts in Burnaby, and nearly identically to multilistings elsewhere in Vancouver. But FREH listings in the Vancouver border area have grown extremely rapidly—not as quickly their counterparts in Burnaby, but more than twice as quickly as the rest of Vancouver. Both of these categories of listings will be in violation of the City's principal residence requirement, but multilistings have evidently been much more significantly restrained by the regulations than FREH listings have been. This is the same pattern that the comparison of the City of Vancouver with the rest of the Vancouver CMA revealed.

<div class="figure" style="text-align: center">
<img src="01-regulatory_impacts_files/figure-html/fig-3-10-1.png" alt="(ref:fig-3-10)" width="672" />
<p class="caption">(ref:fig-3-10)</p>
</div>

(ref:fig-3-10) _Active listings (L), FREH listings (C), and multilistings (R) along the Vancouver-Burnaby border (2017-01-01 = 100)_

## Conclusions

This chapter has presented a variety of comparisons designed to isolate the impact of the City of Vancouver's 2018 STR regulations on Vancouver's STR market. Across the different comparisons, the following findings emerged:

- The initial implementation of the City's licensing system and Airbnb's subsequent mass removal of non-licensed listings created a one-time negative shock in the number of STR listings in Vancouver in mid-2018. But this shock was disproportionately concentrated among listings which were present on STR platforms but not actively being rented, and active listings grew more quickly in 2019 to partially counteract the effects of this shock.
- Trend analysis suggests that the City's regulations have reduced active STR listings in Vancouver by 1,510, or 35.8% of total active listings, within a plausible range of 600 - 1,670. We estimate that the regulations have returned 810 housing units to the long-term market, within a plausible range of 160 - 990.
- Comparisons with other jurisdictions uniformly suggest that the real impact of the City's STR regulations is at the higher end of the trend analysis scenarios. Since 2018, Vancouver's STR market has developed more slowly and in a less commercialized direction than Montreal or Toronto, while a substantial amount of commercial STR activity has relocated to nearby municipalities in Metro Vancouver.
- Comparisons with nearby municipalities suggest that, among commercial STR operations, multilistings have been particularly constrained by the City's regulations, while dedicated FREH listings have grown less than they otherwise would have, but at something closer to the rate expected in the absence of regulations. This pattern is consistent with a scenario where the City's licensing system has been extremely successful at discouraging hosts from licensing multiple listings, but has been less successful at discouraging hosts from operating single listings in a full-time fashion, despite the fact that both these categories of use are non-compliant with the City's principal residence requirement.

\newpage

<!--chapter:end:01-regulatory_impacts.Rmd-->


# Covid-19: STRs returning to the long-term market

Placeholder


## The dramatic decrease in full-time STRs during the pandemic
## How many STR listings have returned to the long-term market?
## When did STR listings move to the long-term market?
## Spatial distribution of matched listings
## Asking rents
## Are matched listings commercial operations?
## Which STR hosts transferred their listings to Craigslist and Kijiji?
## Are matched listings successfully rented, or still active on Airbnb?

<!--chapter:end:02-covid_returning_listings.Rmd-->

# Appendix: Data and methodology {-}

The analysis in this report is based on a combination of private and public data sources. The key sources are the following:

- Listing and activity data about Airbnb and VRBO short-term rental listings gathered by the consulting firm AirDNA. This data includes canonical information about every short-term rental (STR) listing on the Airbnb and VRBO (including HomeAway) platforms which was active in the City of Vancouver between January 1, 2016 and September 31, 2020. The data includes “structural” information such as the listing type (entire home, private room, shared room or hotel room), the number of bedrooms, and the approximate location of the listing. AirDNA collects this information through frequent web scrapes of the public Airbnb and VRBO websites. The data also includes estimates of listing activity (was the listing reserved, available, or blocked, and what was the nightly price?), which AirDNA produces by applying a machine-learning model to the publicly available calendar information of each listing. We use this data for our core analysis of the STR market, including our counts of active listings, our breakdown of different listing types, our estimates of STR-induced housing loss, and our estimates of listings which are commercial operations.

- Additional data about Airbnb listings collected by UPGo researchers. This includes information to verify activity and location, and listing photographs which were obtained through web scrapes.

- Data about long-term rental listings on Kijiji and Craigslist. This data includes the geographic location of listings advertised, the asking rent, the number of bedrooms, the number of bathrooms, the title, and the photographs attached to the posting. This data was collected by UPGo through web scrapes conducted each Monday from March 30 to October 12, 2020. We use this data to analyze the long-term rental market in Vancouver, and to identify STR listings which have been transferred to the long-term market.

- Data from Statistics Canada and the Canada Mortgage and Housing Corporation (CMHC). We use this governmental data to analyze population and dwelling counts, average rents, and rental vacancy rates.

- Data about property regulation of short-term rentals from the City of Vancouver. We use this data to conduct the regulation compliance analysis for the purposes of determining the impact and effectiveness of Vancouver’s STR by-laws.

This report analyzes the City of Vancouver, and, unless otherwise specified, “Vancouver” refers to the city. When other cities are compared to Vancouver, we are likewise referring to the municipalities (e.g. “Montreal” refers to the City of Montreal).

_Data cleaning:_ We process the raw STR data we receive from AirDNA through an extensive data cleaning pipeline, using our `strr` software package (Wachsmuth 2021b), the code for which is available at [https://github.com/UPGo-McGill/strr](https://github.com/UPGo-McGill/strr). With the Craigslist and Kijiji data we scraped, we cleaned the dataset using techniques such as string distance, duplicate removal, and outlier filtering, following similar approaches used with comparable datasets, such as Boeing and Waddell (2017) and RCLALQ (2020).

_Image matching:_ We used our own image recognition algorithm to match listings posted both to Airbnb and to either Craigslist or Kijiji. The algorithm converts the sequence of pixels in an image into a string of numbers representing the average brightness of regions of the image, which serves as a distinctive “signature” of the image, similar to a fingerprint. We compare these signatures to each other using the Pearson correlation coefficient. When the correlation is sufficiently high, we repeat the procedure using separate signatures for the images’ red, blue and green colour channels. All potential matches are then individually verified by human observation. The software package we developed to conduct this image matching is called `matchr` (Wachsmuth 2021a) and is available at [https://github.com/UPGo-McGill/matchr](https://github.com/UPGo-McGill/matchr).

_FREH modelling:_ We define “frequently rented entire-home listings” as entire-home STR listings which are available for a majority of the year (so 183 days or more in a 365-day period), and which are reserved at least 90 days of that year. This is a consistent and conservative way to estimate listings operated sufficiently often that they are unlikely to be their host’s principal residence. But this indicator is slow to adapt to sudden shocks in STR activity, since it incorporates the past 12 months of a listing’s activity. Given that the COVID-19 pandemic caused STR activity to drop dramatically, we wanted to capture the associated changes at shorter timescales than the one year which our FREH concept allows us to. So we developed a linear regression model which predicts FREH status based on three months of listing activity instead of a full year, and which is calibrated both to routine seasonal variation and to a given market’s specific dynamics. All of the FREH results reported here are the results of this model rather than the raw FREH calculations themselves.

In order to facilitate public understanding and scrutiny of our work, complete methodological details, along with all the code used to produce this analysis, are freely available under an MIT license on the UPGo GitHub page at https://github.com/UPGo-McGill/vancouver-analysis.

\newpage

<!--chapter:end:03-appendix.Rmd-->

# Glossary {-}

Active daily listings: listings which were displayed on the Airbnb.ca or VRBO.ca website on a given day, and were either reserved or available for a reservation. It is the clearest means of determining the overall size of the short-term rental market in a location, particularly with respect to change over time.

FREH (frequently rented entire-home listings): Entire-home listings which were available on Airbnb or VRBO a majority of the year (at least 183 nights) and were booked a minimum of 90 nights. Alongside ghost hostels, used as a proxy for long-term housing loss. For buildings that contain multiple FREH listings, see ghost hotel. For clusters of private rooms, see ghost hostel.

Listing type: One of “entire home or apartment”, “private room”, “shared room”, or “hotel room”, which an STR host chooses on Airbnb or VRBO to characterize their listing. Entire-home listings are the most common listing type in Vancouver, and they include any STR unit that is available entirely to the guests, which could be a single-family home, a townhouse, a condominium unit, or a secondary suite.

LTR (long-term rental): In this report, a long-term rental is a housing unit available for rent for extended periods of time (generally a year), in contrast to a short-term rental. It can include monthly or yearly rental arrangements. In this report, data from the online classified ad sites Kijiji and Craigslist were used to analyze the LTR market.  

Multilisting: A listing operated by a host who is simultaneously operating other listings in such a manner that the listings cannot all be located at the host’s principal residence. If one host has two or more entire-home listings or three or more private-room listings active on the same day, those are multilistings.

STR (short-term rental): A housing unit available for rent for 31 days or fewer, typical of vacation rental platforms. In this report, we use STR to refer to a rental advertised on Airbnb or VRBO.  

\newpage

<!--chapter:end:04-glossary.Rmd-->


# References {-}

Placeholder



<!--chapter:end:05-references.Rmd-->

