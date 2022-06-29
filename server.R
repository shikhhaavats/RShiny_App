
######## Server ##########################

server <- function(input, output, session) {

output$selshipname <- renderUI({

req(input$sel_vessel)

choice <- shipdt$SHIPNAME[shipdt$ship_type == input$sel_vessel]

selectInput("sel_name", label = NULL,
choices =  choice %>% unique(),
selected = choice[1]


)

})



Ship_data <- reactive({

req(input$sel_vessel)
req(input$sel_name)

shipdt <- shipdt %>% 
filter(shipdt$ship_type %in% input$sel_vessel 
& shipdt$SHIPNAME %in% input$sel_name
) %>%
group_by(ship_type) %>%
mutate(lag_LAT = lag(LAT), lag_LON = lag(LON)) %>% 
mutate(distance = diag(distm(cbind(lag_LON, lag_LAT),
                   cbind(LON, LAT),fun = distHaversine)),
timespan = difftime(DATETIME, lag(DATETIME), units = "secs")) %>%
mutate(starttime = min(shipdt$DATETIME),endtime = max(shipdt$DATETIME)) %>%
ungroup() %>%  arrange(ymd_hms(DATETIME))



shipdt

})









output$shipmap <- renderLeaflet({


req(Ship_data())

#### Calculating the distance travelled
dist_sum <- round(sum(as.numeric(Ship_data()$distance), na.rm = TRUE))



#### Message for distance travelled
progress <- Progress$new(session, min=1, max=10)
on.exit(progress$close())
progress$set(message = paste0('Distance Travelled : ',dist_sum,' m'))
for (i in 1:10) {
progress$set(value = i)
Sys.sleep(0.5)
}



#########To plot only two points : Start and End
endpoint <- tail(Ship_data(), 1)%>% mutate(color = "red",Point = "END")
startpoint <- head(Ship_data(), 1) %>% mutate(color ="green",Point = "START")
str_end <- as.data.frame(rbind(startpoint,endpoint)) 

str_end <- str_end %>% group_by(ship_type)





leaflet() %>% 
addTiles() %>% 
leaflet::addCircleMarkers(
#clusterOptions = markerClusterOptions(),
data = str_end , lng= str_end$LON,
lat= str_end$LAT , 
popup = ~paste(str_end$PORT ,sep = '<br/>' ),
color = ~color,
label = ~paste(str_end$Point ,sep = '<br/>'),
labelOptions = labelOptions(noHide = T, direction = "bottom",
                    style = list(
                      "color" = "black",
                      "font-family" = "Arial",
                      "font-style" = "bold",
                      "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                      "font-size" = "10px",
                      "border-color" = "rgba(0,0,0,0.5)")))%>% 
addProviderTiles("Esri.WorldImagery",
       group = "Esri.WorldImagery") #%>% 
# addPolylines(data = str_end,lng = ~LON, lat = ~LAT, weight = 0.2,opacity = 2,color = "yellow" ) 





})

output$location <-  downloadHandler(

filename = function() 
{
paste('location_data', Sys.Date(), 'csv', sep='.')
},
content = function(filename) {


#To plot only two points : Start and End
endpoint <- tail(Ship_data(), 1)
startpoint <- head(Ship_data(), 1)
str_end <- as.data.frame(rbind(startpoint,endpoint))

str_end <- str_end %>% group_by(ship_type) 


write.csv(str_end,filename,row.names = T)

})


}
