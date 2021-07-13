#Rienje Veenhof and Frank Fluit
#Project for the course Geoscripting at Wageningen University
#28-1-2021
#This script has two functions. The first function will download the GADM file of
#a specified country code and region (default = only the outline). We first wanted 
#to use this for all countries in Asia, but the files were too big, so we created the
#second function which downloads country outline from the wrld_simpl database. This
#function takes a vector of country codes and selects those out the whole wrld_simple dataset.
#We now only use the first function for Nepal. 
  
#install needed libraries
if(!"raster" %in% rownames(installed.packages())){install.packages("raster")}
library(raster)
if(!"sf" %in% rownames(installed.packages())){install.packages("sf")}
library(sf)
if(!"maptools" %in% rownames(installed.packages())){install.packages("maptools")}
library(maptools)

#first function
get_adm_areas <- function(country_code, region=FALSE){
  if (region) {
    adm_area <- getData(name="GADM", country=country_code, level=2, path = 'data')
  } else {
    adm_area <- getData(name='GADM', country=country_code, level = 0, path='data')
  }
  adm_area <- sf::st_as_sf(adm_area)
  return(adm_area)
}

#second function
get_many_adm_areas <- function(countries) {
  data(wrld_simpl)
  world <- st_as_sf(wrld_simpl)
  adm_areas <- world[world$ISO3 %in% countries,]
  return(adm_areas)
}

#End