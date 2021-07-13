#Rienje Veenhof and Frank Fluit
#Project for the course Geoscripting at Wageningen University
#28-1-2021
#This script contains two functions, the first of which extracts raster data from a
#given polygon extent and converts it to sf.
#The second functions also extracts data, but returns a df instead of an sp. It then merges
#this df to the 'template' of the sp file from the first function, thereby adding new columns with
#data from different rasters, each time the function is run.

#Install needed libraries
if(!"terra" %in% rownames(installed.packages())){install.packages("terra")}
library(terra)
if(!"sf" %in% rownames(installed.packages())){install.packages("sf")}
library(sf)

#First function
extract_spatial <- function(rasterfile, polygonfile){
  spatial_extract <- terra::extract(rasterfile, polygonfile, fun = mean, df = TRUE, na.rm = TRUE,sp=TRUE)
  spatial_extract <- st_as_sf(spatial_extract)
  return(spatial_extract)
}
#Second function
#we used indexing here to determine the place of the new column as we had some
#weird problems that it wouldnt assign the real name to the new column
extract_df <- function(rasterfile, polygonfile, spatialfile){
  df_extract <- terra::extract(rasterfile, polygonfile, fun = mean, df = TRUE, na.rm = TRUE)
  n <- ncol(spatialfile)
  spatialfile[n+1] <- df_extract[2]
  return(spatialfile)
}