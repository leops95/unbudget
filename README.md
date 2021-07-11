# Member States contributions to the United Nations regular budget

This repository contains an interactive application for data visualization made with Shiny for R. The dashboard is accessible using this link: <https://leops95.shinyapps.io/unbudget/>

## Data collection:
Data comes from the [United Nations Committee on Contributions](https://www.un.org/en/ga/contributions/) and can be downloaded in Excel and Stata format on this repository.

Surprisingly, such data is not publicly and readily available to the general public. Only data for the last 3 years are displayed on [this page](https://www.un.org/en/ga/contributions/honourroll.shtml). To retrieve past years' data, I used the Web Archive [Wayback Machine](http://archive.org/web/) in order to access old versions of the same web page. This permitted me to go back to 2000 but with some missing months (october to december in some years).



## Issues encountered:
* If the web page has not been updated by the end of the year, it is replaced by a new table on the beginning of the next year. Hence, countries having paid after the last web page update will be missing and considered as not having fully-paid their yearly contribution. Therefore, I am missing the following months: october-december 2006, october-december 2009, december 2010, november-december 2011, november-december 2018.

* For 2007, the web page was not accessible at all. This is due to an overhaul of the website structure. Instead, I downloaded monthly pdfs of member states contributions status, available from the [United Nations Official Documents System](https://documents.un.org/prod/ods.nsf/home.xsp) website. As the payment day is not mentioned in these documents, the date of payment is inexact and set as the last day of first month in which the country appears to have fully paid its assessment. This is not important for the purpose of my dashboard. However, it seems that those types of pdfs were discontinued afterwards, as I can't find them for the missing months mentioned above.

* The choice of country borders (represented by the shapefile I am using) is not optimal as borders evolve over time. For now, I use the base world map of highcharter, which I believe uses the most recent country borders. I could also choose to plot the map according to recent changes in boundaries (i.e Sudan before the 2011 scission of South Sudan). This would be possible using the R package [CShapes](https://www.rdocumentation.org/packages/cshapes/versions/0.6), originally from from Weidmann, Kuse & Gleditsch (2010), but I can't make it work with highcharter.

* Due to their small size, a recurrent problem for tiny countries and islands is that they are harder to visualize on a world map. I have seen multiple times on the internet a map with large bubbles around those countries, which makes them easier to spot. Unfortunately, until now I have never been able to find the shapefile of this map by myself. That is why I tried to set the world map I'm using as large as possible.
