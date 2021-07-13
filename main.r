#Rienje Veenhof and Frank Fluit
#Project for the course Geoscripting at Wageningen University
#28-1-2021
#This project will investigate what the effects of the COVID lockdown have been
#on the air quality in Nepal and Asia as a whole. For this we use sattelite data
#on NO2 levels and Optical Depth (the ratio between reflected and transmitted light
#by aerosols). The results will be displayed in an interactive shiny app.

#install needed package
if(!"zeallot" %in% rownames(installed.packages())){install.packages("zeallot")}
library(zeallot)

#Create needed directories
dir.create('data', showWarnings = FALSE)
dir.create('leaflet/www', showWarnings = FALSE)

#Source needed functions
source('R/download_raster.r')
source('R/get_adm_areas.r')
source('leaflet/app.R')
source('R/difference_raster.r')
source('R/extract_values.r')

#Download picture that is to be used on the website
urlPicture <- "https://www.dropbox.com/s/ce3x9rrfpaayb8v/COVID-19-proves-that-Kathmandu-can-be-cleaned-up-2-min-1.jpg?dl=1"
download.file(urlPicture, 'leaflet/www/Kathmandu1.jpg')

#Download administrative areas of Nepal and Asia
countries <- c('AFG', 'BGD', 'BTN', 'BRN', 'KHM',
               'CHN', 'HKG', 'IND', 'IDN', 'JPN',
               'KGZ', 'LAO', 'MAC', 'MYS', 'MDV',
               'MNG', 'MMR', 'NPL', 'PRK', 'PAK',
               'PNG', 'PHL', 'SGP', 'KOR', 'LKA',
               'TWN', 'TJK', 'THA', 'TLS', 'TKM',
               'VNM')
nepal_regions <- get_adm_areas('NPL', region = TRUE)
asia <- get_many_adm_areas(countries)

#store urls
#Optical density 
#2018
urlOD181 ="https://www.dropbox.com/s/qu5k7dx3hbacpzi/nAerosol_Asia_January_2018.tif?dl=1"
urlOD184 ="https://www.dropbox.com/s/c5j2vjp5lr8shp0/nAerosol_Asia_April_2018%20%281%29.tif?dl=1"
urlOD187 ="https://www.dropbox.com/s/drfjdab6drxqo7s/nAerosol_Asia_July_2018%20%281%29.tif?dl=1"
urlOD1810 ="https://www.dropbox.com/s/o28py1n4lylqb1y/nAerosol_Asia_October_2018.tif?dl=1"

#2019
urlOD191 ="https://www.dropbox.com/s/oeqovmjb1xh3wa0/nAerosol_Asia_January_2019.tif?dl=1"
urlOD194 ="https://www.dropbox.com/s/0rv4hqyhimw27m3/nAerosol_Asia_April_2019.tif?dl=1"
urlOD197 ="https://www.dropbox.com/s/7gg9c6al4t4e6e3/nAerosol_Asia_July_2019.tif?dl=1"
urlOD1910 ="https://www.dropbox.com/s/jp6dpdnyem8kmrk/nAerosol_Asia_October_2019.tif?dl=1"

#2020
urlOD201 ="https://www.dropbox.com/s/pclknmr0lcyjgfr/nAerosol_Asia_January_2020.tif?dl=1"
urlOD204 ="https://www.dropbox.com/s/llxxyfxnvtzz5f9/nAerosol_Asia_April_2020.tif?dl=1"
urlOD207 ="https://www.dropbox.com/s/xt5x8mhug80wt21/nAerosol_Asia_July_2020.tif?dl=1"
urlOD2010 ="https://www.dropbox.com/s/pn1jfhuu6kgcgwx/nAerosol_Asia_October_2020.tif?dl=1"

#No2
#2019
urlN191 ="https://www.dropbox.com/s/hrbfiwfmjn0niw8/mean_NO2_values_Nepal_January_2019.tif?dl=1"
urlN194 ="https://www.dropbox.com/s/ht3wpbljbwso3g3/mean_NO2_values_Nepal_April_2019.tif?dl=1"
urlN197 ="https://www.dropbox.com/s/gy31jixnve7o1mj/mean_NO2_values_Nepal_July_2019.tif?dl=1"
urlN1910 ="https://www.dropbox.com/s/k50ghndd8o70jkp/mean_NO2_values_Nepal_October_2019.tif?dl=1"

#2020
urlN201 ="https://www.dropbox.com/s/ue6u44xcashajt9/mean_NO2_values_Nepal_January_2020.tif?dl=1"
urlN204 ="https://www.dropbox.com/s/e7fsvqlnb11i1j4/mean_NO2_values_Nepal_April_2020.tif?dl=1"
urlN207 ="https://www.dropbox.com/s/1lkjyhsbo06uq2t/mean_NO2_values_Nepal_July_2020.tif?dl=1"
urlN2010 ="https://www.dropbox.com/s/5r59dn2lhuh0ggl/mean_NO2_values_Nepal_October_2020.tif?dl=1"

#Download  rasters
urls <- c(urlOD181, urlOD184, urlOD187, urlOD1810,
          urlOD191, urlOD194, urlOD197, urlOD1910,
          urlOD201, urlOD204, urlOD207, urlOD2010,
          urlN191, urlN194, urlN197, urlN1910,
          urlN201, urlN204, urlN207, urlN2010)
filenames <- c('data/OD181.tif','data/OD184.tif','data/OD187.tif','data/OD1810.tif',
               'data/OD191.tif','data/OD194.tif','data/OD197.tif','data/OD1910.tif',
               'data/OD204.tif','data/OD204.tif','data/OD207.tif','data/OD2010.tif',
               'data/N191.tif','data/N194.tif','data/N197.tif','data/N1910.tif',
               'data/N201.tif','data/N204.tif','data/N207.tif','data/N210.tif')
raster_list <- download_many_raster(urls, filenames)

c(OD181, OD184, OD187, OD1810,
  OD191, OD194, OD197, OD1910,
  OD201, OD204, OD207, OD2010,
  N191, N194, N197, N1910,
  N201, N204, N207, N2010) %<-% raster_list

#Extract mean Nitrogen values for all time periods and bind to spatial polygon
N_nepal <- extract_spatial(N191, nepal_regions)
N_nepal <- extract_df(N194, nepal_regions, N_nepal)
N_nepal <- extract_df(N197, nepal_regions, N_nepal)
N_nepal <- extract_df(N1910, nepal_regions, N_nepal)
N_nepal <- extract_df(N201, nepal_regions, N_nepal)
N_nepal <- extract_df(N204, nepal_regions, N_nepal)
N_nepal <- extract_df(N207, nepal_regions, N_nepal)
N_nepal <- extract_df(N2010, nepal_regions, N_nepal)

#Extract mean Optical depth values for all time periods and bind to spatial polygon
OD_asia <- extract_spatial(OD181, asia)
OD_asia <- extract_df(OD184, asia, OD_asia)
OD_asia <- extract_df(OD187, asia, OD_asia)
OD_asia <- extract_df(OD1810, asia, OD_asia)
OD_asia <- extract_df(OD191, asia, OD_asia)
OD_asia <- extract_df(OD194, asia, OD_asia)
OD_asia <- extract_df(OD197, asia, OD_asia)
OD_asia <- extract_df(OD1910, asia, OD_asia)
OD_asia <- extract_df(OD201, asia, OD_asia)
OD_asia <- extract_df(OD204, asia, OD_asia)
OD_asia <- extract_df(OD207, asia, OD_asia)
OD_asia <- extract_df(OD2010, asia, OD_asia)

#Create difference rasters
#We put this in a function that is kind of arbitrary but we did it because it 
#looks neat
#First for optical distance
dif_jan18OD <- dif_func(OD204,OD181)
dif_apr18OD <- dif_func(OD204,OD184)
dif_jul18OD <- dif_func(OD204,OD187)
dif_oct18OD <- dif_func(OD204,OD1810)

dif_jan19OD <- dif_func(OD204,OD191)
dif_apr19OD <- dif_func(OD204,OD194)
dif_jul19OD <- dif_func(OD204,OD197)
dif_oct19OD <- dif_func(OD204,OD1910)

dif_jan20OD <- dif_func(OD204,OD201)
dif_jul20OD <- dif_func(OD204,OD207)
dif_oct20OD <- dif_func(OD204,OD2010)

#Then for Nitrogen values
dif_jan19N <- dif_func(N204,N191)
dif_apr19N <- dif_func(N204,N194)
dif_jul19N <- dif_func(N204,N197)
dif_oct19N <- dif_func(N204,N1910)

dif_jan20N <- dif_func(N204,N201)
dif_jul20N <- dif_func(N204,N207)
dif_oct20N <- dif_func(N204,N2010)

#Prepare the OD_asia sp to a Dataframe containing dates and countries
#as column names to be able to plot them in the app
OD_asias <-as(OD_asia,Class="Spatial")
country_column <-OD_asias@data$NAME
OD_data <-data.frame(OD_asias@data[12:23])
OD <- cbind(country_column,OD_data)
OD <- data.frame(t(OD))
OD <-tail(OD,-1)
names(OD) <- c("Bangladesh",
               "Burma","Brunei_Darussalam","Cambodia","Sri_Lanka","China","Afghanistan","Bhutan","India","Japan","Kyrgyzstan",
               "Korea_Democratic_People_Republic_of","Korea_Republic_of","Lao_People_Democratic_Republic","Mongolia",
               "Maldives","Malaysia","Hong_Kong","Macau","Nepal","Pakistan","Papua_New_Guinea","Philippines","Singapore","Thailand",
               "Tajikistan","Turkmenistan","Vietnam","Indonesia","Timor_Leste","Taiwan")
Date <- c("2018-01-15","2018-04-15","2018-07-15","2018-10-15","2019-01-15","2019-04-15","2019-07-15",
          "2019-10-15","2020-01-15","2020-04-15","2020-07-15","2020-10-15")
Date <- as.Date(Date,"%Y-%m-%d")
OD <- data.frame(OD, Date)

#Run RShiny script
shinyApp(ui = ui, server = server)

#End