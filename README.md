# Effect of Covid-19 lockdown on air polution in Nepal
Geoscripting 2020 
- Title: The effects of the covid-19 lockdown on aerosols and cloud formation in the atmoshpere in Nepal
- Team: IBBizzle (Rienje Veenhof & Frank Fluit)
- Date: 22/1/2021

**Task 1**
 - In 2020, for the first time in years, inhabitants of Kathmandu, were able to see the Mount Everest again from the city. Normally, the mountain is invisible, because of aerosols caused by air polluting industry and air traffic. However, because of a reduce in industrial activities and travel due to the corona virus, the air cleared up and the Nepali people could see 'their' mountain again. In our project, we made a spatio-temporal comparison in aerosol levels, between 2018 and 2020 (pre- and mid-covid).
In addition the project visualises Nitrogen densities in the air for different regions in Nepal.
Lastly, we visualized and communicated the results in a website. In this rshiny interface users can select regions and time periods themselves and investigate what aerosol levels (expressed in optical depth) and what nitrogen values are present in that region. 

**Task 2**
 - The first part of our analysis is based on copernicus data, containing total aerosol optical depth:

https://developers.google.com/earth-engine/datasets/catalog/ECMWF_CAMS_NRT

Date: 2018-2020
Extent: BBox around Asia
Resolution: 0.4 arc degrees (~40 km at latitude of Nepal). 
Size: several 100s of kb/raster (12 in total)

-The second part is based on Sentinel-5P OFFL NO2: Offline Nitrogen Dioxide data

https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S5P_OFFL_L3_NO2

Date: 2019-2020
Extent: BBox around Nepal
Resolution:1km
Size: about 3 MB per raster (8 in total) 

Dataset containing Asian vector outlines (wrld_simpl from the maptools package)
Extent: Asia
Size: several MBs

Dataset containg Nepal vector outlines (GADM country polygons)
Extent: Nepal
Size: several MBS

**Task 3**

The processing of the aerosol depth data we downloaded (the average aersol depth for asia per 3 months), for the period 2018-2020, was done in the following way:

The data was dowloaded and aggregated to average values for months in GEE.
This data was then uploaded to dropbox to obtain a download link.
Afterwards this data was extracted in R using Asian countries, to obtain average values for the aersol depth per country and per time period.

The same was done for the nitrogen data for the Nepal regions.

The webmap was made in RShiny, visualising several plots, background information and graphs. 
Packages that have been used are: zealot,sf, raster, shiny, terra, htmltools, leaflet and maptools.

link GEE script:
https://code.earthengine.google.com/c1c4991b6df6f009bb57d7f028238d4b
 
**How to run**
When running the main all data is downloaded and processes and after a couple of minutes the RShiny app should appear automatically.




