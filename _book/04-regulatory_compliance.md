# Short-term rentals in Vancouver: Regulatory compliance

<style type="text/css">
  body{
  font-family: Futura, Helvetica, Arial;
}
</style>

<br>



**Throughout 2019, the percentage of STR listings operating with valid STR licenses increased consistently, from 30.7% at the  beginning of the year to 77.0% at the end. Among listings active in mid-October 2020, 29.0% were operating with a valid license, 32.2% with an expired license, and 33.7% with an invalid or fake license, or with no license at all. FREH listings had the highest rate of valid licenses (56.9%) among listing categories, although all commercial listings are per se in violation of the City's principal residence requirement. 10.6% of active entire-home listings displayed a license number used by at least one other active entire-home listing, suggesting that license numbers are being shared in violation of the regulations. Non-conforming listings are concentrated in and around Downtown Vancouver; the West End is the area with the highest percentage of non-conforming listings (79.4%). Entire-home listings with license numbers are booked more frequently and earn more revenue than listings without licenses, but there is no substantial difference between listings with valid or non-conforming license numbers, suggesting that STR guests are reluctant to book reservations in listings without a license number.**

## How many listings have licenses?



As of mid-2018, all STR operators in Vancouver are required to have a municipal license. This means that all listings displayed on Airbnb and VRBO (with the exception of properties rented exclusively for 30 days at a time or longer, and hotels and other tourist accommodations which are regulated separately) must have a license. For listings currently operating in Vancouver, license numbers are publicly displayed, and below we compare listing activity with license status. However, it is not possible to exhaustively connect past individual listings with past individual licenses in the past, since many listings have been removed from STR platforms. So we instead compare the total number of displayed STR listings to the total number of non-expired licenses to evaluate aggregate compliance levels in Vancouver. 



Figure \@ref(fig:fig-4-1) shows the total number of listings that were displayed on the Airbnb platform on a given day in comparison with the number of non-expired STR licenses active on a given day. In a situation of complete regulatory compliance, these two indicators should be close to equal, but in 2019 the number of licenses ranged from 30.7% at the beginning of the year to 77.0% at the end. Because licenses expire on December 31 each year, the license rate plummets at the beginning of each year as many or most listings expire, and then gradually increases as hosts receive new licenses. In 2020 the rate at which hosts acquired STR licenses flattened noticeably after the onset of the Covid-19 pandemic in March. Between March 14 and September 30, only 307 new licenses were issued. but because the total number of displayed STR listings has plummeted, 2020 is on track to see similar license rates by the end of the year as 2019.

\begin{figure}

{\centering \includegraphics{04-regulatory_compliance_files/figure-latex/fig-4-1-1} 

}

\caption{(ref:fig-4-1)}(\#fig:fig-4-1)
\end{figure}

(ref:fig-4-1) _Displayed STR listings and non-expired STR licenses in Vancouver (7-day average), in absolute (L) and relative (R) terms_

## Listing regulatory compliance




In order to analyze regulatory compliance among currently active listings, we scraped all Vancouver listings on the Airbnb website in mid-October (then again at the end of October for verification purposes) and recorded the license number displayed on each listing.



Figure \@ref(fig:fig-4-2) shows the 4,976 listings that displayed on Airbnb in mid-October when we performed our scrape of license numbers. The top row (A) organizes listings by their license status. Out of the total 4,976 listings, 29.0% had a valid license. A further 5.1% claimed to be exempt, and 32.2% had a license which had previously been valid but which had expired. This leaves 33.7% of listings which either had an invalid license number (an entry in the license field which was not in the proper format of YY-####), a fake license number (an entry which was in the proper format but which did not correspond to an actual license number issued by the City), or no license number at all. Commercial STRs (either FREH listings or multilistings) are over-represented among listings which have valid licenses, while listings with expired licenses or no liceneses at all were disporportionately likely to be listings which had not been active on Airbnb in the month of September.

\begin{figure}

{\centering \includegraphics{04-regulatory_compliance_files/figure-latex/fig-4-2-1} 

}

\caption{(ref:fig-4-2)}(\#fig:fig-4-2)
\end{figure}

(ref:fig-4-2) _License status and listing status (in September 2020) for listings displayed on Airbnb in mid-October 2020_

The bottom row (B) of Figure \@ref(fig:fig-4-2) organizes listings by their activity status on Airbnb in the month of September 2020. It demonstrates that FREH listings are the only category of listing for which a majority (56.9%) had valid licenses. To be clear, all commercial operations are per se non-compliant with the City's licensing rules, since a host cannot operate a frequently rented entire-home listing or multiple entire-home listings in their principal residence. But these listings were disproportionately likely to have a license. Only 6.4% of FREH listings were missing a license, compared to the 27.8% of other listings which were missing a license. It is not a safe assumption that listings displaying a valid number are in fact operating in conformity with the City's regulation, however. 83 (10.6%) of active entire-home listings displayed a license number which was being used by at least one other active listing. Unless these listings are duplicates of the same property, most of them must be operating in violation of the City's regulations. Most (41.8%) listings which had been inactive on Airbnb in September had a license number which had previously been invalid but was now expired—the highest rate of any listing category, and an indication that many of these inactive listings are no longer operating as STRs despite continuing to be displayed on Airbnb.

## Geographic distribution of non-conforming listings







Listing validity displays a clear spatial pattern. The local areas with the most non-conforming listings (i.e. listings with fake, invalid, expired, or missing license numbers) in both absolute and relative numbers are those closest to Downtown Vancouver (Figure \@ref(fig:fig-4-3)). The area with the highest percentage of non-conforming listings is the West End (78.2%), followed by Fairview (76.9%). 

\begin{figure}

{\centering \includegraphics{04-regulatory_compliance_files/figure-latex/fig-4-3-1} 

}

\caption{(ref:fig-4-3)}(\#fig:fig-4-3)
\end{figure}

(ref:fig-4-3) _Geographical distribution of non-conforming listings._

## Daily activity of entire-home listings by regulatory compliance



How does registration conformity impact business in the short-term rental market? We analyzed reservation, availability and revenue patterns of all active entire-home listings to understand the relationship between displaying a valid license number and STR activity. Table \@ref(tab:tab-license) summarizes this information. Entire-home listings with valid licenses have significantly higher reservation rates (40.6%) than listings with non-conforming licenses (29.7%). They have also earned more revenue per night since the 2018 regulations were introduced and since the onset of the Covid-19 pandemic. However, among listings which do not have a valid license number, it is listings with fake license numbers (i.e. numbers which follow the correct YY-#### format but do not correspond to a number actually issued by the City) which have earned the most revenue since the onset of the pandemic, at $61 compared to $52 for listings with valid licenses. Listings operating without displaying any license at all have earned dramatically less revenue than any other listing category—less than half the average revenue of listings with valid licenses over both time periods.

\begin{table}

\caption{(\#tab:tab-license)STR activity by license status}
\centering
\resizebox{\linewidth}{!}{
\begin{tabular}[t]{l|r|r|r|r|r|r}
\hline
License status & Listings & Nights available & Nights reserved & Nights blocked & Revenue per night since Covid-19 & Revenue per night since regulations\\
\hline
All listings & 1,810 & 33.7\% & 34.9\% & 31.4\% & \$46 & \$72\\
\hline
Valid & 833 & 31.6\% & 40.6\% & 27.8\% & \$52 & \$80\\
\hline
Exempt & 71 & 38.8\% & 34.4\% & 26.7\% & \$46 & \$69\\
\hline
Non-conforming & 906 & 35.2\% & 29.7\% & 35.1\% & \$40 & \$64\\
\hline
Expired & 458 & 37.6\% & 28.9\% & 33.5\% & \$40 & \$78\\
\hline
Invalid & 28 & 32.2\% & 43.9\% & 23.9\% & \$59 & \$80\\
\hline
Fake & 152 & 31.8\% & 41.5\% & 26.6\% & \$61 & \$77\\
\hline
No license & 268 & 33.4\% & 22.8\% & 43.8\% & \$26 & \$31\\
\hline
\end{tabular}}
\end{table}

The implications of this analysis are: 1) displaying a license number is associated with greater success in the STR market in Vancouver, and 2) it is not important whether the license number is valid. Visitors to Vancouver are not in a position to independently verify the validity of license numbers, but are evidently reluctant to book listings for which no license is displayed.

\newpage
