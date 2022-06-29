
############ UI ##########################################
ui <- semanticPage(
  
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  
tags$head( h1("Marine Analytics",
style="color: #363433;")),


box(style = "border: 1px solid white;
    background: white;
    color: #e66b00;
    font-weight:bold;",
split_layout(
style = "border: 1px solid white;",

div(
a(class="ui blue ribbon label"),
p("Select the Vessel type:"),

selectInput("sel_vessel",
            label = NULL,
            choices = shipdt$ship_type %>% unique(),
            selected = shipdt$ship_type[1]
)


),

tags$hr(),


div(
a(class="ui blue ribbon label"),
p("Select Vessel Name"),
uiOutput("selshipname")


),

tags$hr(),

div(
a(class="ui blue ribbon label"),
value_box(subtitle = "MOVING VESSELS",
          add_comma(nrow(shipdt %>% filter(status == "Moving")))
,color = "orange",icon("ship",style= "color: #58c94b;"),width =4,size = "small")



),
tags$hr(),

div(
a(class="ui blue ribbon label"),
value_box(subtitle = "PARKED VESSELS", 
          add_comma( nrow(shipdt %>% filter(status == "Parked")))
,color = "orange",icon("anchor",style= "color: #f53636;"),width = 4, size = "small")


)

)),
downloadButton("location",
label ="Download map data"),

tags$div(
leafletOutput('shipmap',width = 1480,
height = 470)

),


tags$footer("Created by Shikha Vats",align = "center", style = "position:fixed;
bottom:0;
right:0;
left:0;
background:#eb6302;
color: white;
padding:10px;
box-sizing:border-box;
font-weight : bold;
z-index: 1000;
text-align: center"


)

)


