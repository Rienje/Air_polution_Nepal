#Rienje Veenhof and Frank Fluit
#Project for the course Geoscripting at Wageningen University
#28-1-2021
#This script creates a shiny app with leaflet maps that display the resultts
#of this project and provide a short description of the topic

#------------------------Libraries-------------------------#

if(!"shiny" %in% rownames(installed.packages())){install.packages("shiny")}
library(shiny)
if(!"leaflet" %in% rownames(installed.packages())){install.packages("leaflet")}
library(leaflet)
if(!"sf" %in% rownames(installed.packages())){install.packages("sf")}
library(sf)
if(!"raster" %in% rownames(installed.packages())){install.packages("raster")}
library(raster)
if(!"htmltools" %in% rownames(installed.packages())){install.packages("htmltools")}
library(htmltools)


#------------------------UI-------------------------#

ui<-fluidPage(
  titlePanel("The Covid-19 lockdown and air quality in Asia"),
  #create seperate panels for the different maps
  tabsetPanel(type= 'tabs', 
    tabPanel("Introduction",
      mainPanel(verbatimTextOutput('text'), img(src = 'Kathmandu1.jpg', width = 550, height = 300)), #plaatje veranderen
      sidebarPanel( helpText("Frank Fluit and Rienje Veenhof",
                                   "Geoscripting 28-1-2021",
                                   sep='\n'))),
    #NO2 map tab
    tabPanel("NO2 Map",
             mainPanel(leafletOutput('map_no2')),
             sidebarPanel( helpText("NO2 enters the atmosphere through natural and
                                    anthropogenic activities, such as fossil fuel
                                    combustion in industries and cars. Sentinel 
                                    5P measures NO2 concentrations in the atmosphere
                                    during day time. Source: Sentinel 5P, ESA."),
                           selectInput("dateN",
                                       label = "Choose date to display",
                                       choices = c('Jan 2019',
                                                   'Apr 2019',
                                                   'Jul 2019',
                                                   'Oct 2019',
                                                   'Jan 2020',
                                                   'Apr 2020',
                                                   'Jul 2020',
                                                   'Oct 2020'),
                                       selected = 'Apr 2020'))),
    #Optical depth map tab
    tabPanel("Optical Depth Map",
             mainPanel(leafletOutput('map_od')),
             sidebarPanel( helpText("Optical depth is the natural logarithm
                                    of the ratio of incident to transmitted radiant
                                    power. In this case, the measurements are at 
                                    550 nm, the peak of the visible spectrum. Optical
                                    depth is dimensionless. Higher
                                    values indicate more reflection by aerosols, 
                                    and more polluted air. Source: TROPOMI, Copernicus 
                                    Atmosphere Monitoring System."),
                           selectInput("dateOD",
                                       label = "Choose date to display",
                                       choices = c("Jan 2018",
                                                   "Apr 2018",
                                                   "Jul 2018",
                                                   "Oct 2018",
                                                   "Jan 2019",
                                                   "Apr 2019",
                                                   "Jul 2019",
                                                   "Oct 2019",
                                                   "Jan 2020",
                                                   "Apr 2020",
                                                   "Jul 2020",
                                                   "Oct 2020"),
                                       selected = 'Apr 2020'))),
    #Optical depth graph panel
    tabPanel("Graph Optical Depth Asia",
             mainPanel(
               textOutput("selected_var"),
               plotOutput("plot1")
             ),
             sidebarPanel( helpText("This graphing tool makes the difference over time in optical depth
                                insightful, for a country and period of choice"),
                           selectInput("var",
                                       label = "Choose country to display",
                                       choices = c("Bangladesh","Burma","Brunei_Darussalam","Cambodia","Sri_Lanka","China","Afghanistan","Bhutan","India","Japan","Kyrgyzstan",
                                                   "Korea_Democratic_People_Republic_of","Korea_Republic_of","Lao_People_Democratic_Republic","Mongolia",
                                                   "Maldives","Malaysia","Hong_Kong","Macau","Nepal","Pakistan","Papua_New_Guinea","Philippines","Singapore","Thailand",
                                                   "Tajikistan","Turkmenistan","Vietnam","Indonesia","Timor_Leste","Taiwan"),
                                       selected = "Nepal"),
                           selectInput("Start",
                                       label = "Select the starting date (15th day indicates the mean of the month)",
                                       choices = c("2018-01-15","2018-04-15","2018-07-15","2018-10-15","2019-01-15","2019-04-15","2019-07-15",
                                                   "2019-10-15","2020-01-15","2020-04-15","2020-07-15","2020-10-15"),
                                       selected = "2018-01-15"),
                           selectInput("End",
                                       label = "Select the end date (15th day indicates the mean of the month)",
                                       choices = c("2018-01-15","2018-04-15","2018-07-15","2018-10-15","2019-01-15","2019-04-15","2019-07-15",
                                                   "2019-10-15","2020-01-15","2020-04-15","2020-07-15","2020-10-15"),
                                       selected= "2020-10-15")
                           
             )),
    #Difference NO2 map tab
    tabPanel("Difference Map Nitrogen",
             mainPanel(leafletOutput('map_diffN')),
             sidebarPanel( helpText("This raster shows the difference in NO2 values
                                    for Nepal, in comparison to the NO2 levels during
                                    the lockdown in March 2020 (selected time raster
                                    - lockdown raster). Green means that 
                                    NO2 concentrations were lower in the selected
                                    time frame than during the lockdown. Red means
                                    there was more NO2 at the selected time, than 
                                    during the lockdown."),
                           selectInput("diffN",
                                       label = "Choose raster to display",
                                       choices = c("Jan 2019",
                                                   "Apr 2019", 
                                                   "Jul 2019",
                                                   "Oct 2019",
                                                   "Jan 2020",
                                                   "Jul 2020",
                                                   "Oct 2020"),
                                       selected = 'Apr 2019'))),
    #Difference optical depth tab
    tabPanel("Difference Map Optical Depth",
             mainPanel(leafletOutput('map_diffOD')),
             sidebarPanel( helpText("This raster shows the difference in Optical
                                    depth for Asia, in comparison to the optical depth 
                                    during the lockdown in March 2020 (selected time raster
                                    - lockdown raster). Green means that 
                                    OD was higher in the selected time frame than
                                     during the lockdown. Red means there was less 
                                     OD at the selected time, than during the lockdown."),
                           selectInput("diffOD",
                                       label = "Choose raster to display",
                                       choices = c("Jan 2018",
                                                   "Apr 2018",
                                                   "Jul 2018",
                                                   "Oct 2018",
                                                   'Jan 2019',
                                                   'Apr 2019',
                                                   'Jul 2019',
                                                   'Oct 2019',
                                                   'Jan 2020',
                                                   'Jul 2020',
                                                   'Oct 2020'),
                                       selected = 'Apr 2019')))
             )
    )
    

#------------------------SERVER-------------------------#                           

server <- function(input, output) {
  #NO2 Map   
  output$map_no2 <- renderLeaflet({
    dataN <- switch(input$dateN,
                   'Jan 2019' = N_nepal$N191,
                   'Apr 2019' = N_nepal$N194,
                   'Jul 2019' = N_nepal$N197,
                   'Oct 2019' = N_nepal$N1910,
                   'Jan 2020' = N_nepal$N201,
                   'Apr 2020' = N_nepal$N204,
                   'Jul 2020' = N_nepal$N207,
                   'Oct 2020' = N_nepal$N210)
    #labels and palette
    labels_N <- sprintf(
      "<strong>%s</strong><br/>%g NO2 mol per m<sup>2</sup>",
      N_nepal$NAME_2, dataN
    ) %>% lapply(htmltools::HTML)

    pal_N <- colorBin("YlOrRd", domain = dataN)
    #leaflet map
    leaflet(N_nepal) %>%
      setView(lng = 85.300140, lat = 27.700769, zoom = 6) %>%
      addMapPane(name='labels', zIndex = 650) %>%
      addProviderTiles("Stamen.TerrainBackground", options = providerTileOptions(noWrap = TRUE)) %>%
      addProviderTiles("Stamen.TerrainLabels",
                       options = leafletOptions(pane='labels')) %>%
      addPolygons(fillColor = ~pal_N(dataN),
                  fillOpacity = 0.9,
                  weight = 1.5,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  highlight = highlightOptions(weight = 5,
                                                color = "#666",
                                                dashArray = "",
                                                fillOpacity = 0.6,
                                                bringToFront = TRUE),
                  label = labels_N,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")
                  ) %>%
      addLegend(pal=pal_N, values=~dataN, opacity=0.9, title="NO2 concentration", position="bottomright",
                labFormat = labelFormat(digits=7))
      
  })
  
  #Optical density map
  output$map_od <- renderLeaflet({
    dataOD <- switch(input$dateOD,
                     "Jan 2018" = OD_asia$OD181,
                     "Apr 2018" = OD_asia$OD184,
                     "Jul 2018" = OD_asia$OD187,
                     "Oct 2018" = OD_asia$OD1810,
                     "Jan 2019" = OD_asia$OD191,
                     "Apr 2019" = OD_asia$OD194,
                     "Jul 2019" = OD_asia$OD197,
                     "Oct 2019" = OD_asia$OD1910,
                     "Jan 2020" = OD_asia$OD201,
                     "Apr 2020" = OD_asia$OD204,
                     "Jul 2020" = OD_asia$OD207,
                     "Oct 2020" = OD_asia$OD2010)
    
    #labels and palette
    labels_OD <- sprintf(
      "<strong>%s</strong><br/>%g Optical depth",
      OD_asia$NAME, dataOD) %>% 
      lapply(htmltools::HTML)
    pal_OD <- colorBin("YlGn", domain = dataOD)
    #leaflet map
    leaflet(OD_asia) %>%
      setView(lng = 90.300140, lat = 27.700769, zoom = 3) %>%
      addMapPane(name='labels', zIndex = 650) %>%
      addProviderTiles("Stamen.TerrainBackground", options = providerTileOptions(noWrap = TRUE)) %>%
      addProviderTiles("CartoDB.VoyagerOnlyLabels", 
                       options=leafletOptions(pane='labels')) %>%
      addPolygons(fillColor=~pal_OD(dataOD),
                  fillOpacity = 0.9,
                  weight = 1.5,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  label = labels_OD,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto"),
                  highlight = highlightOptions(
                     weight = 5,
                     color = "#666",
                     dashArray = "",
                     fillOpacity = 0.7,
                     bringToFront = TRUE)
                  ) %>%
      addLegend(pal=pal_OD, values=~dataOD, title="Optical depth", position="bottomright",labFormat = labelFormat(digits=7))
  })
  #Optical density plot
  output$plot1 <- renderPlot({
    plot(OD[OD$Date>=input$Start& OD$Date<=input$End,]$Date,
         OD[OD$Date>=input$Start& OD$Date<=input$End,input$var],
         xlab="Time [Years}",
         ylab = "Optical Depth [Fraction]",
         main = 'Optical depth over time', 
         type = "l")
  })
  
  output$selected_var <- renderText({ 
    paste("You have selected", input$var, "from", input$Start, "until", input$End)
  })
  #Difference map N
  output$map_diffN <- renderLeaflet({
    diff_N <- switch(input$diffN,
                      "Jan 2019" = dif_jan19N$layer,
                      "Apr 2019"= dif_apr19N$layer,
                      "Jul 2019" = dif_jul19N$layer,
                      "Oct 2019"= dif_oct19N$layer,
                      "Jan 2020"= dif_jan20N$layer,
                      "Jul 2020"= dif_jul20N$layer,
                      "Oct 2020" = dif_oct20N$layer)
    #labels and palette
    labels_diffN <- sprintf(
      "<strong>%s</strong>",
      nepal_regions$NAME_2) %>% 
      lapply(htmltools::HTML)
    pal_diffN <- colorNumeric(c("green", "red"), values(diff_N),
                              na.color = "transparent")
    #make leaflet map
    leaflet(nepal_regions) %>%
      setView(lng = 85.300140, lat = 27.700769, zoom = 6) %>%
      addMapPane(name='labels', zIndex = 650) %>%
      addProviderTiles("Stamen.TerrainBackground", options = providerTileOptions(noWrap = TRUE)) %>%
      addProviderTiles("Stamen.TerrainLabels",
                       options=leafletOptions(pane='labels')) %>%
      addPolygons(fillOpacity = 0,
                   weight = 1.5,
                   opacity = 1,
                   color = "white",
                   dashArray = "3",
                   label = labels_diffN,
                   labelOptions = labelOptions(
                     style = list("font-weight" = "normal", padding = "3px 8px"),
                     textsize = "15px",
                     direction = "auto"),
                   highlight = highlightOptions(
                     weight = 5,
                     color = "#666",
                     dashArray = "",
                     fillOpacity = 0,
                     bringToFront = TRUE)) %>%
      addRasterImage(diff_N, colors = pal_diffN, opacity = 0.8) %>%
      addLegend(pal = pal_diffN, values = values(diff_N),
                title = "Difference in NO2",
                position = 'bottomright',
                labFormat = labelFormat(digits=5))
      
  })
  
  #Difference map OD
  output$map_diffOD <- renderLeaflet({
    diff_OD <- switch(input$diffOD,
                      "Jan 2018" = dif_jan18OD$layer,
                      "Apr 2018" = dif_apr18OD$layer,
                      "Jul 2018" = dif_jul18OD$layer,
                      "Oct 2018" = dif_oct18OD$layer,
                      'Jan 2019' = dif_jan19OD$layer,
                      'Apr 2019' = dif_apr19OD$layer,
                      'Jul 2019' = dif_jul19OD$layer,
                      'Oct 2019' = dif_oct19OD$layer,
                      'Jan 2020' = dif_jan20OD$layer,
                      'Jul 2020' = dif_jul20OD$layer,
                      'Oct 2020' = dif_oct20OD$layer)
    #labels and palette
    labels_diffOD <- sprintf(
      "<strong>%s</strong>",
      OD_asia$NAME) %>% 
      lapply(htmltools::HTML)
    pal_diffOD <- colorNumeric(c("red", "green"), values(diff_OD),
                              na.color = "transparent")
    
    #leaflet map
    leaflet(OD_asia) %>%
      setView(lng = 90.300140, lat = 27.700769, zoom = 3) %>%
      addMapPane(name='labels', zIndex = 650) %>%
      addProviderTiles("Stamen.TerrainBackground", options = providerTileOptions(noWrap = TRUE)) %>%
      addProviderTiles("Stamen.TerrainLabels",
                       options=leafletOptions(pane='labels')) %>%
      addPolygons(fillOpacity = 0,
                  weight = 1.5,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  label = labels_diffOD,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto"),
                  highlight = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0,
                    bringToFront = TRUE)) %>%
      addRasterImage(diff_OD, colors = pal_diffOD, opacity = 0.8) %>%
      addLegend(pal = pal_diffOD, values = values(diff_OD),
                title = "Difference in Optical depth",
                position = 'bottomright',
                labFormat = labelFormat(digits=5))
  })
  
  
  #Introduction text
  output$text <- renderText({
    paste("On the 10th of May, the Nepali Times published a picture of Kathmandu",
          "made by photographer Abhushan Gautam (Awale, May 14th, 2020). At first",
          "glance, not much remarkable is to be spotted in the picture, aside from",
          "a beautiful sunset in Nepal. However, for the citizens of Kathmandu,",
          "this photograph captures an historic moment. For the first time in ",
          "the living memory of most Nepali, they were able to see their side",
          "of the Mount Everest again. The Covid-19 lockdown in Nepal and the",
          "decrease in worldwide air traffic rapidly cleaned up the usually",
          "polluted air over Kathmandu. In April 2020, there was an 80% decrease",
          "in flights worldwide in comparison to the previous year (Santos,",
          "May 4th, 2020). This especially had an impact on busy routes connecting",
          "Asia, Europe and North America. In addition, the decrease in car-use",
          "in the Nepali capital also contributed to drop in air pollution.",
          "Both the decrease in vehicular traffic as the closing of factories",
          "provided the local atmosphere with the necessary breathing space to",
          "regenerate itself, showing the environment’s capacity to heal itself.",
          "In addition, this change was accompanied by a sharp drop in ",
          "registrations for patients with respiratory illnesses in Kathmandu’s",
          "hospitals, showcasing the benefits for human well-being as well as",
          "environmental health.",
          "This application aims to visualize the change in atmospheric ",
          "pollutants and optical depth over Nepal at the height of the Covid-19",
          "lockdown (April, 2020), in comparison to previous years. It ",
          "demonstrates the impact a short-term reduction in pollutants can have",
          "on the environment.",
          sep='\n')
  })
}

shinyApp(ui = ui, server = server)
#End