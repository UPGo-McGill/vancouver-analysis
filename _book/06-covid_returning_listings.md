# Covid-19: STRs returning to the long-term market

<style type="text/css">
  body{
  font-family: Futura, Helvetica, Arial;
}
</style>

<br>





**Using image recognition techniques, we identified 1,339 unique Airbnb listings which were posted as long-term rentals (LTRs) on Craigslist or Kijiji between March and September 2020. These former STRs have asking rents on average 25.6% higher than other LTR listings, but are correlated with a 13.5% decrease in overall asking rents in Vancouver. The evidence suggests that the overwhelming majority of STR listings transferred to LTR platforms are commercial operations. We estimate that 30.6% have fully transitioned back to the long-term market, 35.3% have been temporarily blocked on Airbnb and may return to being STRs in the future, and 34.1% failed to be rented on LTR platforms and instead remain active on Airbnb.**

## How many STR listings have returned to the long-term market?





As demonstrated in section 5, the COVID-19 pandemic has caused an unprecedented decline in STR activity in Vancouver. Under these circumstances, it would be reasonable to imagine that some STR hosts—particularly commercial operators who had come to expect large income streams from their properties—may have decided to return their listings to the long-term housing market, either temporarily or permanently. To investigate this possibility, we collected listing images from all properties posted to Craigslist and Kijiji in Vancouver between March and September 2020, and used image recognition analysis to match STR listings on Airbnb and Vrbo to long-term rental (LTR) listings on Craigslist and Kijiji. These latter two platforms represent only a portion of the LTR market, but provide useful insight into how STR hosts have responded to the collapse in accommodation demand during the COVID-19 pandemic. If the exact same photo of an apartment’s living room was uploaded to Airbnb in August 2019 and then to Craigslist in April 2020, this provides proof that the property in question has moved from the STR market to the LTR market. The image recognition software we developed is able to identify matches between images which are identical, but also images which the host has modified slightly, and thus allows us to reliably identify every match which exists between STR and LTR platforms (Figure \@ref(fig:fig-6-1)).

\begin{figure}

{\centering \includegraphics{06-covid_returning_listings_files/figure-latex/fig-6-1-1} 

}

\caption{(ref:fig-6-1)}(\#fig:fig-6-1)
\end{figure}

(ref:fig-6-1) _Examples of listings matched between STR and LTR platforms. The first pair of images (A & B) is matched despite the images being tinted differently. The second pair of images (C&D) is matched despite the first image being digitally altered._



Our image matching algorithm recognized 1,339 unique Airbnb listings which matched with 2,690 different LTR listings (as some units are posted multiple times) in the City of Vancouver. The matching LTR listings were predominantly found on Craigslist (2,495 listings, or 92.8%), with a small portion posted on Kijiji (195 listings, or 7.2%). Out of the 1,339 matching Airbnb listings, 54.6% (731 listings) were created or still active in 2020. We suspect that many or most of the remaining properties were also still active under a different listing ID and with a different photo, since commercial STRs are delisted and relisted quite frequently, and we thus consider the 1,339 Airbnb listings which we matched to Craigslist and Kijiji to be a lower bound for the number of unique housing units that went from the STR market to the LTR market due to the COVID-19 pandemic. (Each listing which we matched is guaranteed to have been listed first on Airbnb and then on either Kijiji or Craigslist, but there are certain to be additional listings which we did not match because they did not reuse the same photographs.) 

All of the Craigslist listings we matched were long-term rentals. Out of the 107 Airbnb listings which we matched to Kijiji, 67.3% were identified by their hosts as “long-term rentals” and 32.7% were identified as “short-term rentals”. Among matched Kijiji listings, 36% specified lease lengths of one year, 30% specified month-to-month, and 35% did not specify.

## When did STR listings move to the long-term market?





The first COVID-19 case in Vancouver was confirmed on January 28, 2020, but the pandemic did not fully erupt until the second week of March 2020, when public facilities and private businesses began to close, culminating in a Provincial declaration of public emergency on March 12. Consistent with this timeline, what was in early March a trickle of Airbnb listings moving to Craigslist or Kijiji began to accelerate in the middle of the month (Figure \@ref(fig:fig-6-2)). By the end of the March, the number of daily transfers reached 27 listings. Daily numbers remained high through April (its peak being 62 listings transferred on April 21), but even from May through September an average of 5.2 new Airbnb listings were transferred to Craigslist or Kijiji each day.

\begin{figure}

{\centering \includegraphics{06-covid_returning_listings_files/figure-latex/fig-6-2-1} 

}

\caption{(ref:fig-6-2)}(\#fig:fig-6-2)
\end{figure}

(ref:fig-6-2) _The date on which matched Airbnb listings were first detected on Craigslist or Kijiji in the City of Vancouver (3-day average)_

## Spatial distribution of matched listings





Out of the 1,339 unique STR listings matched to LTR listings in the City of Vancouver, nearly half (46.8%) were located in the Downtown area, with the remaining matches more evenly split between the other areas. 10.8% of matches were in West End, following by 7.8% in Kitsilano and 4.6% in Mount Pleasant. This distribution is distorted compared to general distribution of STR listings in the city: Downtown is highly over-represented in these matches. When controlling for the density of STR listings, Downtown is still slightly over-represented with respect to the number of STRs being relisted as long-term rentals. However, other areas have a listing density close to Downtown’s (Figure \@ref(fig:fig-6-3)). The number of STR listings matched to LTR listings in Downtown is equivalent to more than half (54.1%) of all the STR listings active in the area on March 1, 2020, and 29.1% of all the listings active in the borough in 2020. 

\begin{figure}

{\centering \includegraphics{06-covid_returning_listings_files/figure-latex/fig-6-3-1} 

}

\caption{(ref:fig-6-3)}(\#fig:fig-6-3)
\end{figure}

(ref:fig-6-3) _Total number of STR listings matched to LTR listings (L), and matched STR listings as a percentage of daily active listings on 2020-03-01 (R), by local area_

## Asking rents





The left panel of Figure \@ref(fig:fig-6-4) shows the average asking rents of listings posted to Craigslist and Kijiji between March and July 2020. (We do not have complete asking rent data for August and September, so those months are excluded.) The asking rents have remained dramatically higher than non-matched LTR listings. On March 13, when the average asking rent on LTR platforms in the City of Vancouver was $2,438, the average asking rent among listings which we matched to Airbnb was $3,117— 27.8% higher. Over the course of March, average asking rents for LTR listings matched to Airbnb declined sharply, before increasing gradually for the next few months. At the end of July, the average asking rent was $2,082 for all Craigslist and Kijiji listings and $2,634 for the matches. Overall, from April to July, asking rents for properties matched to STR listings were 25.6% higher than the city-wide average.

\begin{figure}

{\centering \includegraphics{06-covid_returning_listings_files/figure-latex/fig-6-4-1} 

}

\caption{(ref:fig-6-4)}(\#fig:fig-6-4)
\end{figure}

(ref:fig-6-4) _Average asking rents on Craigslist and Kijiji in the City of Vancouver (L) and Downtown (R) (7-day average)_

The right panel of Figure \@ref(fig:fig-6-4) shows asking rents only in Downtown. A large portion of the divergence in asking rents between LTR listings matched to Airbnb and listings not matched is a compositional effect of the much greater frequency of a Downtown location (which commands higher prices than the rest of the city) among matched listings. Even in Downtown, however, LTR listings matched to Airbnb have been on average 4.2% higher than listings not matched. Overall STRs returning to the long-term market are correlated with a significant decline in asking rents. The average city-wide asking rent on Craigslist and Kijiji declined 13.5% from $2,386 in late March 2020 to $2,102 in late July 2020.

## Listing amenities



_Size:_ Table \@ref(tab:tab-bedrooms) shows the distribution of units by number of bedrooms for entire-home STRs, as well as all the units that were posted for rent on LTR platforms (both the ones that matched with an STR listing and the ones that did not match), and for the City of Vancouver’s overall primary (i.e. apartment and townhouse) rental housing stock. Two-bedrooms were overrepresented in both the matches (39.5%) and the non-matches (41.0%) compared to the STR market (5.2%) and the City (17.3%). Studios were overrepresented among LTR listings which matched to Airbnb or Vrbo (8.2%) compared with LTR listings which did not match (3.9%) and STR listings (5.2%), but were underrepresented when compared to Vancouver’s rental stock of studios (15.2%. Units with three bedrooms or more were far more common on STR and LTR platforms than their prevalence in the city would predict, while one-bedroom units were significantly less common on STR platforms than on LTR platforms or among all city apartments. The implication is that two-bedrooms and studios apartments were disproportionately likely to be moved from STR platforms to the long-term rental market, while one-bedroom apartments were disproportionately likely not to have been moved.

\begin{table}

\caption{(\#tab:tab-bedrooms)STR and LTR listings by bedroom count}
\centering
\begin{tabular}[t]{l|r|r|r|r}
\hline
Category & Studio & 1-bedroom & 2-bedroom & 3+-bedroom\\
\hline
City of Vancouver rental stock & 15.2\% & 66.3\% & 17.3\% & 1.2\%\\
\hline
STR market (2019) & 5.2\% & 57.1\% & 24.8\% & 12.9\%\\
\hline
LTRs matched to STR & 8.2\% & 40.1\% & 39.5\% & 12.2\%\\
\hline
LTRs not matched & 3.9\% & 38.0\% & 41.0\% & 17.1\%\\
\hline
\end{tabular}
\end{table}



_Furnished vs. unfurnished:_ To accommodate temporary guests, STR properties are overwhelmingly furnished. Unsurprisingly, properties that have moved from the STR to LTR market during the pandemic are listed as furnished at much higher rates than other listings on Craigslist and Kijiji. Of the 61,393 LTR listings we analyzed, 25.0% were listed as furnished and 74.8% as unfurnished (The remainder did not provide this information.) Listings which matched with STRs had a significantly higher proportion classified as furnished: 75.9% furnished and 24.1% unfurnished. These proportions suggest that, in approximately three quarters of the cases of STR operators listing their units on LTR platforms, the operators may intend to return their units to the STR market when demand returns, while in a quarter of cases the move to the LTR market appears to be reasonably permanent, since the host has gone through the effort of emptying the unit of furniture.

## Are matched listings commercial operations?



Nearly all of the STR listings which we matched to LTR listings on Craigslist or Kijiji are likely to have been dedicated, commercial STRs. This is because it is highly unlikely that a casual home sharer operating a STR out of their principal residence would decide to vacate their home, list it on Craigslist or Kijiji, and reuse the photo they had used to advertise the short-term rental. It is therefore also likely that the STR listings found on LTR platform were non-compliant with the City's STR regulations, since the fact that they were commercial operators makes it extremely difficult to also have the listing be operated out of a principal residence. We can test this intuition by examining the characteristics of the STR listings which we matched to an LTR platform.

Of the 1,339 unique STR listings that matched with the LTR market, 1,097 (83.5%) are entire-home listings and 206 (15.7%) are private-room listings. Examining the entire-home listings, 53.4% of them were identified as frequently rented entire-home (FREH) listings at some point, which means they were almost certainly operated commercially. Moreover, `r_match_eh_multi_pct` of entire-home STR listings which matched to LTR listings were multilistings at some point, which means they were operated by hosts controlling multiple listings simultaneously. In total, two thirds (66.8%) of entire-home listings had one of these two strong indicators of commercial activity.

The 206 private-room listings require some further analysis, because each of these listings matched to a Craigslist or Kijiji listing advertised as an entire housing unit. Our analysis suggests that these listings break down into three categories. The first is miscategorizations. 7 (3.4%) of the LTR listings that matched to STR private-room listings had titles such as “1 fully furnished bedroom” or “swap”. This suggests either that these listings were rooms located in the host’s principal residence incorrectly listed as entire homes, or that images of the Airbnb private room listing were reused to conduct an exchange of leases between tenants. These STR listings are not commercial listings and their appearance on LTR platforms likewise does not constitute housing being returned to the market.

The second category of private-room Airbnb listings matched to entire-home LTR listings is ghost hostels—clusters of private-room listings which may appear as a series of “spare bedrooms” on Airbnb or Vrbo but are in fact one or more housing units converted to a dedicated STR. 113 (54.9%) of the 206 private-room listings which matched to Craigslist or Kijiji belong to ghost hostels in Vancouver. The remaining 86 private-room Airbnb listings which matched to Craigslist or Kijiji are likely to be ghost hostels which our algorithms failed to identify, or smaller housing units similarly subdivided into private rooms. (Our procedure for identifying ghost hostels only considers clusters of three or more private rooms, but two-bedrooms apartments can also be listed as pairs of private rooms.) On balance, the likelihood is that these listings also represent commercial STRs returning to the long-term market.

Focusing on the unambiguous case of the entire-home listings which matched between STR and LTR platforms, 27.1% of the commercial listings active at any point in 2020 have been transferred to Craigslist or Kijiji since March. But, given the rapidity with which individual listings are posted and removed, this significantly understates the scope of listings moving from Airbnb to the long-term market. Expressed as a percentage of the commercial listings active on March 1, 2020, at the onset of the pandemic, the matches represent 47.8% of these listings. In other words, something between a quarter and a half of Vancouver’s commercial short-term rentals may have shifted to the long-term rental market between March and September.



Figure \@ref(fig:fig-6-5) shows the age in years of STR listings which matched a LTR platform (left panel) and which did not match (right panel). The age distribution of matched listings is skewed to the left, which means that a large proportion of matched listings are less than a year old. By contrast, STR listings which did not match tend to be older. This pattern suggests that newer commercial STR listings may have been in a weaker financial position at the onset of the pandemic, prompting their hosts to change strategies more rapidly than established hosts.

\begin{figure}

{\centering \includegraphics{06-covid_returning_listings_files/figure-latex/fig-6-5-1} 

}

\caption{(ref:fig-6-5)}(\#fig:fig-6-5)
\end{figure}

(ref:fig-6-5) _STR listing age distributions for listings matched to LTR listings (L) and not matched (R)_

## Which STR hosts transferred their listings to Craigslist and Kijiji?



In Vancouver, 743 unique Airbnb and Vrbo host IDs were linked to the 1,339 STR listings which we matched to LTR listings. 160 of these hosts posted more than one of their STR units on Craigslist or Kijiji. Almost two-thirds (62.2%) of the active properties of these 160 hosts were found on either Kijiji, Craigslist, or both. The fact that only a portion of the hosts’ listings were found on LTR platforms suggests that the matches we have identified might be an underestimate of the total quantity of STRs that were posted on LTR platforms since the COVID-19 pandemic began. It would be intuitive to assume that a host who decides to post several of its listings on a LTR platform would post all or most of them. There are several factors which were likely at work here: some listings may have been posted, rented, and removed in between our weekly scrapes so we did not detect them; hosts may have not posted their higher-performing STR listings; and hosts may have used updated photographs for some of their listings, making it impossible to detect matches through our image matching algorithm. 



STR hosts which transferred listings to the long-term rental market had substantially higher STR revenue in 2019 than hosts who did not transfer listings. The median listing revenue was $9,000 in the entire City of Vancouver in 2019. The annual median revenue of hosts who transferred listings to the LTR market was $19,600, while the median revenue of hosts who did not transfer listings was somewhat less at $15,600. Moreover, many of Vancouver’s highest earning STR hosts turned to LTR platforms during the COVID-19 pandemic. For example, 14 of the 28 hosts that made more than $250,000 in the past year listed at least one of their STR units on an LTR platform. On average these top earning hosts listed 11 units on LTR platforms, compared to 1.6 units for all other hosts. Figure \@ref(fig:fig-6-6) compares the 2019 annual revenue distribution of STR hosts that shifted listings to the long-term market and hosts that did not. Hosts whose STR listings matched to LTR listings have a revenue distribution shifted substantially to the right, indicating that they earned more money.

\begin{figure}

{\centering \includegraphics{06-covid_returning_listings_files/figure-latex/fig-6-6-1} 

}

\caption{(ref:fig-6-6)}(\#fig:fig-6-6)
\end{figure}

(ref:fig-6-6) _STR host revenue distributions for hosts whose listings matched to LTR listings (L) and did not match (R)_

## Are matched listings successfully rented, or still active on Airbnb?



The mere presence of current or former Airbnb listings on LTR platforms is no guarantee that the actual housing units have shifted back onto the long-term market. In particular, these listings might have been posted but not successfully rented. It is not possible to determine with certainty whether a given listing was rented and therefore permanently transferred from the short-term to the long-term market, but we can use two indicators to estimate this: the length of time the listing was posted on an LTR platform, and the current activity status of the listing on the STR market.



On average, the STR matches found on LTR platforms stayed longer than the non-matches. STR matches were listed an average of 23.1 days on LTR platforms, while non-matches were listed only three quarters as long—17.1 days on average. This simplest plausible explanation for this disparity is the fact that listings coming from the STR market were both significantly more expensive than other listings and much more likely to be furnished, both of which factors may have decreased their viability in the rental market. Figure \@ref(fig:fig-6-7) shows the distribution of the length of stay for both matches and non-matches. The figure reveals quantitatively and qualitatively different patterns among matched and non-matched listings. Most non-matched listings were present for less than a week on Craigslist or Kijiji before being removed (and presumably rented), and the number of listings still present declines relatively smoothly as the length of time increases. By contrast, most matched listings were not rented after a week, and in fact the proportion which took a month or more to be taken down is higher not lower than the proportion which were taken down after several weeks. Our conclusion is that, regardless of their host’s intentions, STR units listed on LTR platforms have been relatively unsuccessful at transitioning back to long-term rentals.

\begin{figure}

{\centering \includegraphics{06-covid_returning_listings_files/figure-latex/fig-6-7-1} 

}

\caption{(ref:fig-6-7)}(\#fig:fig-6-7)
\end{figure}

(ref:fig-6-7) _LTR listing posting length distributions for listings matched to STR listings (L) and not matched (R)_

Further evidence about the extent to which STR hosts are successfully transferring their listings to the long-term market can be found by examining the activity of the STR listings themselves. Are hosts planning on renting on the long-term only temporarily, leaving the STR listing running for future bookings? Or have they deactivated the STR listing? Out of the total 1,339 STR listings which we identified on LTR platforms, 771 (57.6%) were present on Airbnb or Vrbo at the beginning of 2020. Out of this number, 467 (60.6%) were still present on September 30, while the other 304 (39.4%) had been deactivated. Extrapolating this proportion across the entire set of matched listings we identified, we estimate that 527.9584955 matched listings have been deactivated from Airbnb or Vrbo during the pandemic, while 811.0415045 remain on the platforms. Listings removed from STR platforms are likely to have been durably shifted to the long-term market. However, 74.8% of these listings were rented as furnished rentals on Craigslist or Kijiji. These listings should therefore be considered at relatively high risk of returning to the STR market if demand recovers.

Listings which remain on Airbnb and Vrbo can nevertheless be inactive. If a host successfully rents their listing on Craigslist for several months, they can choose to block their calendar on their STR platform to make sure no new reservations occur, while keeping the listing intact for when the STR market recovers. Of the 467 matched listings present on Airbnb or Vrbo at the beginning of 2020 and still present by the end of Sep, 324 (69.4%) were blocked for the entirety of the month of September. This suggests that these listings are not active on the STR market and therefore have been rented on the LTR market, but the fact that the STR listings have not been taken down suggests that the hosts may plan to reactivate their units once STR demand recovers.

In total, taking into account the matched listings which have continued to see activity on Airbnb or Vrbo, we estimate that, of the total 1,339 STR listings which were advertised on Craigslist or Kijiji, 410 (30.6%) have been deactivated from Airbnb and Vrbo and have likely transitioned back to long-term housing (albeit often as furnished rentals which could be reconverted to STRs), 472 (35.3%) have been temporarily blocked on the STR platforms and have likely been rented in the long-term market but may return to being STRs in the future, and 457 (34.1%) failed to be rented on LTR platforms and instead remain active as STRs.

\newpage
