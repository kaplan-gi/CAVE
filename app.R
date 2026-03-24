# Celiac app (CAVE version)
# Contributor: Lindsay Hracs
# Date: 2024-Feb-20
# R version 4.2.2
# Running on macOS Monterey 12.1

# link: https://kaplan-gi.shinyapps.io/CAVE/

source("global.R", local = TRUE)$value
source("testing.R", local = TRUE)$value
source("incidence.R", local = TRUE)$value
source("various_vis.R", local = TRUE)$value
source("time_series.R", local = TRUE)$value

# version notes
# 1. add ARIMA visualizations

ui <- fluidPage(theme = shinytheme("united"),
    
    useShinyjs(),
    
    title = "Celiac disease Analytical Visualization Environment",
    
    # format Shiny error messages
    tags$head(tags$style(HTML(".shiny-output-error-validation {text-align: center; color: #687B9C; font-weight: bold; font-size: 125%;}"))),
    # format link style
    tags$head(tags$style(HTML("a {color: #408697}"))),
    # format action button
    tags$head(tags$style(HTML(".btn {color:rgb(255,255,255); border-color: #408697; background-color: #408697;}"))),
    # format logo placement
    tags$head(tags$style(HTML(".logo {margin-left: 10px; margin-right: 10px; margin-bottom: 20px; vertical-align: middle;}"))),
    # format slider bar (for eachslider bar, withincreasing increments on js)
    #chooseSliderSkin("Shiny", color = "transparent"),
    tags$head(tags$style(HTML(".js-irs-0 .irs-bar {background-color: transparent; border-color: transparent}"))),
    tags$head(tags$style(HTML(".js-irs-0 .irs-single {color: black; background: #BEC4C6}"))),
    tags$head(tags$style(HTML(".js-irs-1 .irs-bar {background-color: transparent; border-color: transparent}"))),
    tags$head(tags$style(HTML(".js-irs-1 .irs-single {color: black; background: #BEC4C6}"))),
    tags$head(tags$style(HTML(".js-irs-2 .irs-bar {background-color: transparent; border-color: transparent}"))),
    tags$head(tags$style(HTML(".js-irs-2 .irs-single {color: black; background: #BEC4C6}"))),
    tags$head(tags$style(HTML(".js-irs-3 .irs-bar {background-color: transparent; border-color: transparent}"))),
    tags$head(tags$style(HTML(".js-irs-3 .irs-single {color: black; background: #BEC4C6}"))),
    tags$head(tags$style(HTML(".js-irs-4 .irs-bar {background-color: transparent; border-color: transparent}"))),
    tags$head(tags$style(HTML(".js-irs-4 .irs-single {color: black; background: #BEC4C6}"))),
    tags$head(tags$style(HTML(".js-irs-5 .irs-bar {background-color: transparent; border-color: transparent}"))),
    tags$head(tags$style(HTML(".js-irs-5 .irs-single {color: black; background: #BEC4C6}"))),
    
    # format slider input play button
    tags$head(tags$style(HTML(".slider-animate-button {font-size: 20px; color: #52D6F4;}"))),
    

    ########## CAVE header formatting ##########
    
    tags$header(tags$style(HTML(".box {white-space: nowrap; 
                              width: 150px;
                              overflow: hidden;
                              border: 2px solid #408697;
                              background-color: #363538;}"))),
    #tags$header(tags$style(HTML(".box:hover {overflow: visible;}"))),
    tags$header(tags$style(HTML(".wordart { font-family: Arial, sans-serif; 
                              font-size: 1em; 
                              font-weight: bold;
                              position: relative;
                              z-index: 1;
                              display: inline-block;
                              -webkit-font-smoothing: antialiased;
                              -moz-osx-font-smoothing: grayscale; }"))),
    tags$header(tags$style(HTML(".wordart.italic-outline { transform: scale(1, 1.3);
                              -webkit-transform: scale(1, 1.3);
                              -moz-transform: scale(1, 1.3);
                              -o-transform: scale(1, 1.3);
                              -ms-transform: scale(1, 1.3); }"))),
   tags$header(tags$style(HTML(".wordart.italic-outline .text { letter-spacing: -0.01em;
                              font-family: Arial, sans-serif;
                              font-weight: bold;
                              color: #fff;
                              -webkit-text-stroke: 0.01em #000;
                              filter: progid:DXImageTransform.Microsoft.Glow(Color=#000000, Strength=1);
                              text-shadow: 0.03em 0.03em 0 #408697; 
                              background-color: #363538;}"))),
    
    

# 
# <div class="wordart italic-outline"><div class="box" style="text-overflow:ellipsis; display: inline; text-align: center;"><span class="text">&nbspC&nbsp</span></div></div><div class="wordart italic-outline"><span class="text">eliac disease&nbsp</span></div>
# 
# <div class="wordart italic-outline"><div class="box" style="text-overflow:ellipsis; display: inline; text-align: center;"><span class="text">&nbspA&nbsp</span></div></div><div class="wordart italic-outline"><span class="text">nalytical&nbsp</span></div> 
# 
# <div class="wordart italic-outline"><div class="box" style="text-overflow:ellipsis; display: inline; text-align: center;"><span class="text">&nbspV&nbsp</span></div></div><div class="wordart italic-outline"><span class="text">isualization&nbsp</span></div> 
# 
# <div class="wordart italic-outline"><div class="box" style="text-overflow:ellipsis; display: inline; text-align: center;"><span class="text">&nbspE&nbsp</span></div></div><div class="wordart italic-outline"><span class="text">nvironment&nbsp</span></div> 

    
    div(titlePanel(HTML("<p style = 'font-size: 75%;'>&nbsp</p>
                        <div class = 'wordart italic-outline'>&nbsp<div class = 'box' style = 'text-overflow:ellipsis; display: inline; text-align: center;'><span class = 'text'>&nbspC&nbsp</span></div></div><div class = 'wordart italic-outline'><span class = 'text'>eliac disease&nbsp&nbsp</span></div><div class='wordart italic-outline'><div class = 'box' style = 'text-overflow:ellipsis; display: inline; text-align: center;'><span class = 'text'>&nbspA&nbsp</span></div></div><div class = 'wordart italic-outline'><span class = 'text'>nalytical&nbsp&nbsp</span></div><div class='wordart italic-outline'><div class = 'box' style = 'text-overflow:ellipsis; display: inline; text-align: center;'><span class = 'text'>&nbspV&nbsp</span></div></div><div class = 'wordart italic-outline'><span class = 'text'>isualization&nbsp&nbsp</span></div><div class='wordart italic-outline'><div class = 'box' style = 'text-overflow:ellipsis; display: inline; text-align: center;'><span class = 'text'>&nbspE&nbsp</span></div></div><div class = 'wordart italic-outline'><span class = 'text'>nvironment</span></div><p><br></p>")
                    # "<p style = 'color: #FFFFFF; font-size: 75%;'><br>&nbsp;&nbsp;Variation in the Testing for and Incidence of Celiac Disease Autoimmunity throughout Alberta, Canada<br><br></p>")
    ), style = 'background-color: #363538;'), # wrapped in div to create static background for all elements
    
    #htmltools::tags$header(style = "margin-top:20px; color: #363538;", h4("Click on tabs to view data.")),
    
    tabsetPanel(id = "tabs",
        
        tabPanel(value = "incidence", htmltools::tags$header(style = "text-align:center; font-weight: bold; font-size:125% ;", "Incidence"),
            incidenceUI("incidence")
        ),

        tabPanel(value = "testing", htmltools::tags$header(style = "text-align:center; font-weight: bold; font-size:125% ;", "Testing Rates"),
            testingUI("testing")
        ),

        tabPanel(value = "various_vis", htmltools::tags$header(style = "text-align:center; font-weight: bold; font-size:125% ;", "3D Plots"),
            various_visUI("various_vis")
        ),
        
        tabPanel(value = "time_series", htmltools::tags$header(style = "text-align:center; font-weight: bold; font-size:125% ;", "Time Series"),
            time_seriesUI("time_series")
        )
        
        

    )
)

server <- function(input, output, session) {
    
    incidenceServer("incidence")
    testingServer("testing")
    various_visServer("various_vis")
    time_seriesServer("time_series")
    
}

shinyApp(ui, server)