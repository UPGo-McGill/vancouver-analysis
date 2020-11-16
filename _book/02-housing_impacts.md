# Short-term rentals in Vancouver: Housing impacts

<style type="text/css">
  body{
  font-family: Futura, Helvetica, Arial;
}
</style>

<br>







**Short-term rentals removed 2,570 housing units from Vancouver’s long-term market in 2019 — an increase of 41.9% from 2018. The 2018 regulations returned between 300 and 500 dedicated STRs to the long-term market in the early days of their existence, but those gains have since been partially offset by a rapid growth in dedicated STRs throughout 2019. Almost two thirds of all entire-home listings and four in ten private-room listings are dedicated STRs. In the Downtown area, 1.9% of all housing has been converted to dedicated STRs, while the figure is 1.5% in Riley Park and 1.4% in Shaughnessy. Between 2015 and 2019, STRs have been responsible for a 2.1% increase in average monthly rent, and the average renter household in Vancouver has paid an additional $1,390 in rent because of the impact of STRs.**

<br>

## STR-induced housing loss

Vancouver’s housing market has been under considerable stress in the past years, with housing prices and rents rising, and rental vacancy rates falling. These are symptoms of a market where the supply of housing is insufficient to meet demand. One possible explanation for both the insufficient supply and elevated demand for housing in Vancouver is the growth in short-term rentals. Tourists are now able to compete with residents for housing—adding demand to the local housing market—while landlords are now able to shift their properties out of the conventional housing market to become dedicated STRs—reducing the supply of conventional housing. Research has found that renting a housing unit on the STR market frequently offers landlords greater potential revenue than conventional leases (Wachsmuth & Weisler 2018), especially in transit-accessible neighborhoods (Deboosere et al. 2019). Multiple studies have also found that Airbnb and other STR platforms increase housing costs (Barron, Kung, & Proserpio 2017; Horn & Merante 2017; Garcia-Lopez et al. 2019).

One of the major considerations when gauging the impacts of short-term rentals (STRs) on a city, therefore, is the extent to which STRs are removing long-term housing from the market. This process can occur either directly, where tenants of a unit are evicted or not replaced at the end of a lease and the unit is converted to a STR, or indirectly by absorbing new construction or investment properties which otherwise would have gone onto the long-term market. To obtain the exact number of units that have been occupied as STRs, landlords or units would need to be individually surveyed, which is infeasible because STR hosts are mostly anonymous on major STR platforms such as Airbnb and VRBO. Instead, we use the daily activity of listings, alongside structural characteristics such as listing type and location, to estimate which listings are operating as dedicated STRs and are therefore not available as conventional long-term housing.

_Frequently Rented Entire-Home (FREH) listings:_ The number of frequently-rented units is one way to estimate STR-induced housing loss. If a STR is available for reservations the majority of the year and receives many bookings, it is reasonable to assume that it is not serving as an individual’s principal residence at the same time. Along these lines, we define frequently rented entire-home (FREH) listings as entire-home listings which were available on Airbnb or VRBO the majority of the year (at least 183 nights) and were booked a minimum of 90 nights. We then apply a statistical model (described in the appendix) to the FREH data in order to generate an estimate of FREH activity based on three months of listing activity. This allows us to detect listings which are operating in a full-time manner but have not yet been listed for an entire year, and allows us to account for relatively short-term changes in market conditions.

_Ghost hostels:_ In addition to FREH listings, it is possible that entire housing units have been subdivided into multiple private-room listings, each of which appearing to be a spare bedroom or the like, while actually collectively representing an apartment removed from the long-term housing market. We call these clusters of private-room listings “ghost hostels”, building on the advocacy group Fairbnb.ca’s term “ghost hotels”—multiple FREH listings located in a single building, collectively serving as de facto hotels instead of long-term housing (Wieditz 2017). We detect ghost hostels by finding clusters of three or more private-room listings operated by a single host, whose reported locations are close enough to each other that they are likely to have originated in the same actual housing unit. (Airbnb and VRBO obfuscate listing locations by shifting them randomly up to 200 m.)






At the end of 2019, there were 2,320 FREH listings in the City of Vancouver, and 250 more housing units which were operating as ghost hostels. In total, therefore, short-term rentals removed 2,570 housing units from Vancouver’s long-term market last year (Figure \@ref(fig:fig-2-1)). Notably, while the number of active daily listings declined by 2.8% over 2019, the number of housing units which STRs took off of Vancouver’s housing market increased by 41.9% in that same time period, from 1,810 to 2,570. This high growth rate reflects a rebound following a previous substantial decline in dedicated STRs associated with the introduction of the 2018 regulations. On the eve of Airbnb’s mass removal of non-compliant listings (August 2018), 2,370 housing units were operating as dedicated STRs, and this number dropped by more than 2,070 the following month, before ultimately bottoming out at 1,750 in January 2019. Taking the seasonality of the underlying pattern into account, this nevertheless implies that between 300 and 450 housing units were (at least temporarily) restored to the long-term rental market by the introduction of the 2018 regulations—something between 12 and 24% of the total.


\begin{figure}

{\centering \includegraphics{02-housing_impacts_files/figure-latex/fig-2-1-1} 

}

\caption{(ref:fig-2-1)}(\#fig:fig-2-1)
\end{figure}

(ref:fig-2-1) _Housing units converted to dedicated STRs in the City of Vancouver (monthly average)_





However, the result of falling numbers of listings but increasing numbers of listings contributing to housing loss is that the proportion of all active listings which are either FREH or ghost hostels has increased enormously from 2018 to 2019. At the end of 2019 close to two thirds (66.5%) of entire-home listings and more than four in ten (45.2%) private-room listings were taking housing off the market in Vancouver (Figure \@ref(fig:fig-2-2)). Three years earlier, the proportions were only 39.5% and 26.4% respectively. It is possible but highly unlikely that FREH listings were operating out of their host’s principal residences, since these are cases where the entire home is available for rent most of the year. FREH listings, like multilistings, are thus a probable indicator of non-conformity with the City’s regulations.

\begin{figure}

{\centering \includegraphics{02-housing_impacts_files/figure-latex/fig-2-2-1} 

}

\caption{(ref:fig-2-2)}(\#fig:fig-2-2)
\end{figure}

(ref:fig-2-2) _The percentage of active STR listings contributing to housing loss each day in Vancouver (14-day average)_

Table \@ref(tab:tab-2-1) summarizes STR-induced housing loss patterns by neighbourhood. It demonstrates that the City-wide trend of shrinking total numbers of active listings but growing numbers of dedicated STRs also holds in most neighbourhoods. Also, year-over-year growth of housing loss has been evenly distributed between virtually all areas, with an average of 45.0% city-wide, returning, in absolute numbers, to 2017 levels already by the end of 2019. This indicates that, although the regulations might have decreased the number of commercial operations in the short run (2018), there seems to be a return to business-as-usual in 2019.

\begin{table}

\caption{(\#tab:tab-2-1)STR-induced housing loss by local area in the Cityof Vancouver (for boroughs with at least 50 housing units lost in 2019)}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{l|r|r|r|r}
\hline
Area & Housing loss (2018) & Housing loss (2019) & Annual growth (\%) & \% of housing lost (2019)\\
\hline
\cellcolor[HTML]{99CC66}{City of Vancouver} & \cellcolor[HTML]{99CC66}{1810} & \cellcolor[HTML]{99CC66}{2570} & \cellcolor[HTML]{99CC66}{0.4190} & \cellcolor[HTML]{99CC66}{0.0084}\\
\hline
Downtown & 520 & 740 & 0.4291 & 0.0186\\
\hline
Kitsilano & 150 & 200 & 0.3791 & 0.0083\\
\hline
Mount Pleasant & 120 & 170 & 0.4285 & 0.0088\\
\hline
Kensington-Cedar Cottage & 90 & 160 & 0.7663 & 0.0082\\
\hline
West End & 130 & 150 & 0.2196 & 0.0048\\
\hline
Riley Park & 90 & 140 & 0.6158 & 0.0147\\
\hline
Grandview-Woodland & 80 & 120 & 0.4289 & 0.0076\\
\hline
Hastings-Sunrise & 90 & 120 & 0.3102 & 0.0085\\
\hline
Renfrew-Collingwood & 80 & 110 & 0.4108 & 0.0051\\
\hline
Marpole & 50 & 70 & 0.5196 & 0.0064\\
\hline
Strathcona & 60 & 70 & 0.0591 & 0.0095\\
\hline
Sunset & 40 & 60 & 0.5718 & 0.0046\\
\hline
Victoria-Fraserview & 40 & 60 & 0.6751 & 0.0056\\
\hline
Fairview & 40 & 50 & 0.3183 & 0.0027\\
\hline
Kerrisdale & 30 & 50 & 0.6402 & 0.0085\\
\hline
\end{tabular}}
\end{table}





The 2,570 housing units taken off of Vancouver’s housing market in 2019 are 0.8% of the total amount of housing in the city, and this housing loss has been concentrated in small parts of the city. This is more or less the same in relative to the total housing stock: Figure \@ref(fig:fig-2-3) shows the proportion of each area or dissemination area’s housing stock which was operated as a dedicated short-term rental as of the end of 2019. The maps show a tale of two cities: in most of Vancouver, there are relatively few dedicated STRs, while in the center of the city as well as Downtown, they are ubiquitous. In the Downtown area, 1.9% of all housing units have been converted to dedicated STRs. The figure is 1.5% for Riley Park and 1.4% for Shaughnessy. In Downtown, the rental vacancy rate was 1.4% in 2019. This means that there are more dedicated STRs in this neighbourhood than there are vacant apartments for rent.

\begin{figure}

{\centering \includegraphics{02-housing_impacts_files/figure-latex/fig-2-3-1} 

}

\caption{(ref:fig-2-3)}(\#fig:fig-2-3)
\end{figure}

(ref:fig-2-3) _The percentage of housing units converted to dedicated STRs in the City of Vancouver, by local area (L) and dissemination area (R)_

## The impact of STRs on rental housing supply and vacancy rates



In 2019, the City of Vancouver’s rental vacancy rate stood at only 1.0%—a crisis-level rate, albeit slightly higher than the previous few years. The standard rule of thumb is that a healthy rental market should have a vacancy rate of at least 3%, and all 10 of the CMHC's zones in Vancouver are substantially below that. Downtown has the highest vacancy rate at only 1.4%, which means that, of the zone’s approximately 11,000 rental apartments, fewer than  were available to be rented by prospective tenants in October 2019, when CMHC’s survey was conducted. In general, vacancy rates are even lower for family-sized housing units (defined by CMHC as units with two or more bedrooms). For example, the vacancy rate for units with three or more bedrooms was 0.0% for the Downtown zone.

Given the thousands of housing units which we have documented as having been converted to dedicated STRs in Vancouver, it is highly likely that the STR market is negatively affecting rental housing supply and the vacancy rate. One way to evaluate this possibility is to compare the net change in rental housing units in an area with the effective reductions in rental housing supply caused by the growth in dedicated STRs. Figure \@ref(fig:fig-2-4) makes this comparison, showing the change in primary rental housing units (i.e. apartments and townhouses, but not condominiums being used as rentals) per CMHC zone between 2018 and 2019, and the effective change in housing units once the impact of STRs taking housing off of the market is factored in. We assume that STR conversions happen in the same proportion as existing tenure arrangements in the neighbourhood. For example, in the South Granville/Oak zone, 55.3% of households are renters, so we assume that 55.3% of housing units converted to dedicated STRs would have been rental housing, and the remaining 44.7% would have been ownership housing. (We also assume CMHC has not removed dedicated STRs from their counts of primary rental units. In principle CMHC would not consider dedicated STRs to be rental units, but the difficulty in identifying dedicated STRs implies that the safest approach is to assume that dedicated STRs remain in the CMHC rental count.)



Between 2018 and 2019, the City of Vancouver as a whole saw an 740-unit increase, more than half of which occurred in Southeast Vancouver. In a zone like Downtown, where there is a high concentration of STR operations and a growth in housing loss, the zone’s net rental housing change is greatly affected by new STR conversions in 2019. In almost every single of the ten CMHC zones (shown in Figure \@ref(fig:fig-2-4)), new STR conversions in 2019 either mostly cancelled out new rental housing production, or substantially decreased the net rental housing supply from 2018 to 2019.

\begin{figure}

{\centering \includegraphics{02-housing_impacts_files/figure-latex/fig-2-4-1} 

}

\caption{(ref:fig-2-4)}(\#fig:fig-2-4)
\end{figure}

(ref:fig-2-4) _Nominal and effective changes in rental housing supply, 2018-2019, by CMHC zone_



Another way to contextualize the impact of housing units being converted to dedicated STRs is to examine the relationship between the quantity of dedicated STRs and the rental vacancy rate. The left panel of Figure \@ref(fig:fig-2-5) displays the 2019 rental vacancy rate in the 10 CMHC zones with the largest number of active STR listings. The right panel displays a hypothetical vacancy rate if all dedicated STRs returned to the long-term market in these neighbourhoods. As with the calculations of net housing supply changes above, we assume that these units return to the market in the same proportion as existing tenure arrangements in the neighbourhood. The map shows that, in virtually every zone, the number of dedicated STRs is enough to dramatically increase housing supply if they were to be returned to the housing market. In every zone, the vacancy rate could double. 

\begin{figure}

{\centering \includegraphics{02-housing_impacts_files/figure-latex/fig-2-5-1} 

}

\caption{(ref:fig-2-5)}(\#fig:fig-2-5)
\end{figure}

(ref:fig-2-5) _Current rental vacancy rate in the City of Vancouver (L), and hypothetical vacancy rate if dedicated STRs returned to rental market (R), by CMHC zone_

To be clear, in a scenario where thousands of dedicated STRs returned to the long-term market, these units would not actually remain vacant, but would be absorbed into the rental housing supply. Eventually the result would be a combination of lower rents and a vacancy rate lower than depicted in the map but higher than the current vacancy rate. Nevertheless, Figure \@ref(fig:fig-2-5) demonstrates that the number of housing units which have left Vancouver’s long-term market to be operated as STRs is sufficient to significantly constrain housing availability in the city.

## The impact of STRs on residential rents



Residential rents are rising rapidly in Vancouver. Between 2018 and 2019, CMHC recorded a 6.0% increase in average rents in the City of Vancouver, with even higher numbers for studios and 1-bedrooms—increases which far outstripped inflation or local income growth. Are STRs responsible for any of this growth in rents? STRs could plausibly affect rents in the long-term housing market through two channels. On the one hand, if housing units which otherwise could house residents are converted into tourist accommodations, this will shrink the size of the local rental market, which, in the face of constant demand, will result in higher rents. Second, by offering a new revenue stream to homeowners and potentially some tenants who are willing to become part-time home sharers, STRs can increase the economic value of residential properties. Both phenomena would be expected to increase housing costs and rents, since there is less available housing stock, and since the economic potential of the existing stock is increased.



A US study evaluated the impact of STR growth on housing prices and rents using an analysis of STR listings across the United States from 2012 to 2016 (Barron et al. 2017). The researchers found that 1% growth in the number of STR listings predicts a 0.018% increase in monthly rents and 0.026% increase in house prices. While these numbers may seem small, they were multiplied by STR listing growth rates, which had been quite high over the study period. This model was developed to account for a wide range of locations, so we are able to apply the average values of their model to Vancouver to obtain a rough estimate of the impact which STR growth has had on residential rents. Between 2015 and 2019, we estimate that STRs have been responsible for a -2.1% increase in the average monthly rent. As average rents have risen 33.3% in this time period, this implies that approximately -6% of the total rent increases over the last five years have been caused by the growth of STRs. Put differently, from 2015 to 2019, the average renter household in Vancouver has paid an additional $1,390 in rent because of the impact of STRs on the housing market. Figure \@ref(fig:fig-2-6) shows the estimated rent increases by CMHC zone, for the zones where enough data is present to make reliable calculations. Table \@ref(tab:tab-rent) summarizes our rent increase estimates and other related data by CMCH zone. (These results, along with those in the previous paragraph, should be interpreted as rough estimates, as the parameters of the model were developed in the United States.)

\begin{figure}

{\centering \includegraphics{02-housing_impacts_files/figure-latex/fig-2-6-1} 

}

\caption{(ref:fig-2-6)}(\#fig:fig-2-6)
\end{figure}

(ref:fig-2-6) _Estimated cumulative asking rent increases in the City of Vancouver, by CMHC zone_

\begin{table}

\caption{(\#tab:tab-rent)STR impacts on residential rents in the City of of Vancouver, by CMHC zone}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{l|r|r|r|r|r|r|r}
\hline
CMHC Zone & Active listings (2019) & Avg. rent (2015) & Avg. rent (2019) & Rent increase (2015-2019) & STR-induced rent increase (2015-2019) & STR share of rent increase & Avg. extra rent paid due to STRs (2015-2019\\
\hline
\cellcolor[HTML]{99CC66}{City of Vancouver} & \cellcolor[HTML]{99CC66}{3,890} & \cellcolor[HTML]{99CC66}{\$1,240} & \cellcolor[HTML]{99CC66}{\$1,570} & \cellcolor[HTML]{99CC66}{27.0\%} & \cellcolor[HTML]{99CC66}{2.1\%} & \cellcolor[HTML]{99CC66}{7.7\%} & \cellcolor[HTML]{99CC66}{\$1,390}\\
\hline
Downtown & 1,060 & \$1,360 & \$1,730 & 27.3\% & 2.1\% & 7.7\% & \$1,590\\
\hline
Mount Pleasant/Renfrew Heights & 620 & \$1,080 & \$1,380 & 28.1\% & 1.8\% & 6.5\% & \$1,090\\
\hline
East Hastings & 560 & \$1,000 & \$1,320 & 31.8\% & 1.8\% & 5.8\% & \$1,030\\
\hline
Southeast Vancouver & 490 & \$1,120 & \$1,520 & 35.8\% & 2.6\% & 7.2\% & \$1,550\\
\hline
Kitsilano/Point Grey & 390 & \$1,280 & \$1,660 & 29.2\% & 1.9\% & 6.4\% & \$1,350\\
\hline
Westside/Kerrisdale & 350 & \$1,390 & \$1,770 & 27.0\% & 3.0\% & 11.2\% & \$2,220\\
\hline
South Granville/Oak & 230 & \$1,260 & \$1,540 & 21.9\% & 1.9\% & 8.7\% & \$1,350\\
\hline
\end{tabular}}
\end{table}

\newpage
