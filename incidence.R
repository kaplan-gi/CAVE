# Celiac disease application; incidence tab
# Contributor: Lindsay Hracs
# Date: 26-Jan-23
# R version 4.1.2
# Built on macOS Monterey 12.1

# user interface
incidenceUI <- function(id) {
    ns <- NS(id)
        
    sidebarLayout(
          
        sidebarPanel(width = 3, style = "font-size: 90%; height: 80vh; overflow-y: auto; background-color: #D4DADC;", # height: 85vh; overflow-y: auto; <-- for scroll bar
                             
            fluidRow(
                column(6, actionButton(inputId = ns("defs"), label = "Useful Definitions", icon = icon("book")), align = "center"), # add verify_fa = FALSE argument along with the name of the icon, i.e., icon = icon("icon-name", verify_fa = FALSE) 
                column(6, actionButton(inputId = ns("help"), label = "Help", icon = icon("circle-question")), align = "center")
            ),             
            
            hr(style = "border-top: 2px solid #363538;"), 
            
            HTML("<p style = 'font-size: 115%;'><b>Make selections below to view data on the map:</b></p>"), 
            
            selectInput(inputId = ns("geo"), 
                        label = HTML("<span style = 'font-size: 115%;'>1. Select geographic area:</span>"),
                        choices = list("Provincial" = "geo_prov", "AHS Zone" = "geo_zone", "AHS Health Status Area" = "geo_HSA"),
                        selected = list("Provincial" = "geo_prov"),
                        width = "75%",
            ),
            
            conditionalPanel(condition = "input.geo == 'geo_prov'", ns = ns, #JS expression    
                             prettyRadioButtons(inputId = ns("age_prov"), 
                                                label = HTML("<span style = 'font-size: 115%;'>2. Select age group:</span>"), 
                                                choices = list("All ages" = "All", "0 to 17" = "0 to 18", "18 to 64" = "18 to 64", "65+" = "65 and over"),
                                                inline = TRUE,
                                                status = "info",
                             ),
                             
                             prettyRadioButtons(inputId = ns("gender_prov"), 
                                                label = HTML("<span style = 'font-size: 115%;'>3. Select gender:</span>"),
                                                choices = list("All genders" = "All", "Female" = "F", "Male" = "M"),
                                                inline = TRUE,
                                                status = "info",
                             ),
                             
                             sliderTextInput(inputId = ns("year_prov"),
                                             label = HTML("<span style = 'font-size: 115%;'>4. Select year:</span><br><span style = 'font-size: 100%;'>(Click on the slider bar to view a specific year or click the play button under time slider to view animation.)</span>"),
                                             choices = list("All" = "All", "2016" = "2016", "2017" = "2017", "2018" = "2018", "2019" = "2019", "2020" = "2020"),
                                             grid = TRUE,
                                             animate = animationOptions(interval = 2500, loop = FALSE),
                             ),
            ),
            
            conditionalPanel(condition = "input.geo == 'geo_zone'", ns = ns, #JS expression   
                             
                             prettyRadioButtons(inputId = ns("met_zone"), 
                                                label = HTML("<span style = 'font-size: 115%;'>2. Select metropolitan status to subset:</span>"), 
                                                choices = list("All" = "all", "Metropolitan only" = "yes", "Non-metropolitan only" = "no"),
                                                inline = TRUE,
                                                status = "info",
                                                shape = "square",
                                                icon = icon("square-check")
                             ),
                             
                             prettyRadioButtons(inputId = ns("age_zone"), 
                                                label = HTML("<span style = 'font-size: 115%;'>3. Select age group:</span>"), 
                                                choices = list("All ages" = "All", "0 to 17" = "0 to 18", "18 to 64" = "18 to 64", "65+" = "65 and over"),
                                                inline = TRUE,
                                                status = "info",
                             ),
                             
                             prettyRadioButtons(inputId = ns("gender_zone"), 
                                                label = HTML("<span style = 'font-size: 115%;'>4. Select gender:</span>"),
                                                choices = list("All genders" = "All", "Female" = "F", "Male" = "M"),
                                                inline = TRUE,
                                                status = "info",
                             ),
                             
                             sliderTextInput(inputId = ns("year_zone"),
                                         label = HTML("<span style = 'font-size: 115%;'>5. Select year:</span><br><span style = 'font-size: 100%;'>(Click on the slider bar to view a specific year or click the play button under time slider to view animation.)</span>"),
                                         choices = list("All" = "All", "2016" = "2016", "2017" = "2017", "2018" = "2018", "2019" = "2019", "2020" = "2020"),
                                         grid = TRUE,
                                         animate = animationOptions(interval = 3500, loop = FALSE),
                             ),
            ),
            
            conditionalPanel(condition = "input.geo == 'geo_HSA'", ns = ns, #JS expression 
                             
                             prettyRadioButtons(inputId = ns("met_HSA"), 
                                                label = HTML("<span style = 'font-size: 115%;'>2. Select metropolitan status to subset:</span>"), 
                                                choices = list("All" = "all", "Metropolitan only" = "yes", "Non-metropolitan only" = "no"),
                                                inline = TRUE,
                                                status = "info",
                                                shape = "square",
                                                icon = icon("square-check")
                             ),
                             
                             sliderTextInput(inputId = ns("year_HSA"),
                                             label = HTML("<span style = 'font-size: 115%;'>3. Select year:</span><br><span style = 'font-size: 100%;'>(Click on the slider bar to view a specific year or click the play button under time slider to view animation.)</span>"),
                                             choices = list("All" = "All", "2016" = "2016", "2017" = "2017", "2018" = "2018", "2019" = "2019", "2020" = "2020"),
                                             grid = TRUE,
                                             animate = animationOptions(interval = 4500, loop = FALSE),
                             )
            ),
            
            hr(style = "border-top: 2px solid #363538;"),
            
            div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/UC-Cumming-Centre%20for%20Health%20Informatics.jpg", height = "75%", width = "75%"), href = "https://cumming.ucalgary.ca/centres/centre-health-informatics/", target = "_blank"), align = "center"),
            
            div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AB_SPOR.jpg", height = "60%", width = "60%"), href = "https://absporu.ca/", target = "_blank"), align = "center"),
            
            div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AHS.png", height = "60%", width = "60%"), href = "https://www.albertahealthservices.ca/", target = "_blank"), align = "center"),
            
        ),
            
        mainPanel(width = 9, leafletOutput(ns("map"), width = "97.5%", height = "80vh") %>% withSpinner()
        )
          
    ) # sidebarLayout 
    
} # fluidPage

####################################################################################################################################################
####################################################################################################################################################
############################################################################################################################################################################################################################################################################################################################################################################################################################################################

# server
incidenceServer <- function(id) {
    
    moduleServer(id, function(input, output, session) {
    
    icons <- awesomeIcons(
        icon = "chart-bar",
        iconColor = "black",
        library = "fa",
        markerColor = "orange"
    )
    
    error_message <- HTML("<span style = 'font-size: 250%; color: #408697; text-align: center;'>No data to present. Please make another selection.</span>")
    
    observeEvent(input$help, {
        if (input$help > 0)  {
            showModal(modalDialog(
                title = "How to Use the Interactive Maps",
                HTML("<p style = 'font-size: 150%;'><p><b>Directions</b><br>          
                    Make selections in the sidebar to view maps and data for different variable combinations.<br><br>
                    For incidence rate hover mouse over the province, zone, or HSA shape.</p>"),
                size = "l",
                footer = modalButton("Close"),
                easyClose = TRUE
            ))
        }else{}
        
    }) 
    
    observeEvent(input$defs, {
        if (input$defs > 0)  {
            showModal(modalDialog(
                title = "Useful Definitions",
                HTML("<p style = 'font-size: 100%;'>Incidence rates of <b>celiac disease autoimmunity</b> are based on individuals <i>newly</i> positive for <b>anti-tissue transglutaminase antibodies (tTG-IgA)</b>. Individuals who had a prior diagnosis of celiac disease based on ICD-9 or ICD-10 coding in inpatient our outpatient settings were excluded as prevalent cases. Rates are estimated per 100,000 person-years.<br><br>
                    <b>Health status areas (HSAs)</b> provide an informative level of geographic granularity for analyzing health-related outcomes, surveillance, and utilization in Alberta. Click <a href='https://open.alberta.ca/dataset/a14b50c9-94b2-4024-8ee5-c13fb70abb4a/resource/70fd0f2c-5a7c-45a3-bdaa-e1b4f4c5d9a4/download/official-standard-geographic-area-document.pdf'>here</a> for more information on the geographic breakdown of Alberta and the healthcare system. <br><br>
                    <b>Fiscal year end</b> is defined as March 31 of each year.<br><br>
                    </p>"),
                size = "l",
                footer = modalButton("Close"),
                easyClose = TRUE
            ))
        }else{}
        
    })
    
    
    prov_react <- reactive({
        inc_prov_data %>%
            filter(AGE_CAT %in% input$age_prov, GENDER %in% input$gender_prov, FY %in% input$year_prov)
    })
    
    # zone_react <- reactive({
    #    inc_zone_data %>%
    #        filter(AGE_CAT %in% input$age_zone, GENDER %in% input$gender_zone, FY %in% input$year_zone)
    # })
    
    # HSA_react <- reactive({
    #     inc_HSA_data_nonmet %>%
    #         filter(FY %in% input$year_HSA)
    # })
    # 
    zone_react <- reactive({
            if(input$met_zone ==  "all"){
                zone_react <- inc_zone_data %>%
                    filter(AGE_CAT %in% input$age_zone, GENDER %in% input$gender_zone, FY %in% input$year_zone)
            } else if (input$met_zone ==  "yes"){
                zone_react <- inc_zone_data_met %>%
                    filter(AGE_CAT %in% input$age_zone, GENDER %in% input$gender_zone, FY %in% input$year_zone)
            } else if (input$met_zone ==  "no") {
                zone_react <- inc_zone_data_nonmet %>%
                    filter(AGE_CAT %in% input$age_zone, GENDER %in% input$gender_zone, FY %in% input$year_zone)
            }
    })
    
    HSA_react <- reactive({
        if(input$met_HSA ==  "all"){
            HSA_react <- inc_HSA_data %>%
                filter(FY %in% input$year_HSA)
        } else if (input$met_HSA ==  "yes"){
            HSA_react <- inc_HSA_data_met %>%
                filter(FY %in% input$year_HSA)
        } else if (input$met_HSA ==  "no") {
            HSA_react <- inc_HSA_data_nonmet %>%
                filter(FY %in% input$year_HSA)
        }
    })

    # set palette
    
    # data to create palette with bins that auto-adjust to full rate range
    # prov, zone, and HSA combined to have same legend for each map
    inc_rates <- data.frame(rate = c(inc_prov[,"INC_RT"], inc_zone[,"INC_RT"], inc_HSA[,"INC_RT"]))
    
    quantiles <- quantile(inc_rates$rate, na.rm = TRUE)
    pal <- colorBin(palette = c("#FFFED4", "#FEC46C", "#E57217", "#8F2201"), bins = quantiles, pretty = FALSE)
    leg1 <- paste0(sprintf("%.2f", round(quantiles[1], 2)), "–", sprintf("%.2f", round((quantiles[2] - 0.01), 2)))
    leg2 <- paste0(sprintf("%.2f", round(quantiles[2], 2)), "–", sprintf("%.2f", round((quantiles[3] - 0.01), 2)))
    leg3 <- paste0(sprintf("%.2f", round(quantiles[3], 2)), "–", sprintf("%.2f", round((quantiles[4] - 0.01), 2)))
    leg4 <- paste0(sprintf("%.2f", round(quantiles[4], 2)), "+")
    
    
    output$map <- renderLeaflet({
        leaflet(options = leafletOptions(worldCopyJump = TRUE, minZoom = 2)) %>%
            addTiles() %>%
            setView(lng = -115, lat = 54, zoom = 5) %>%
            addLegend(position = "bottomleft",
                      title = "Incidence rate<br>(per 100,000 person-years)", 
                      colors = c("#FFFED4", "#FEC46C", "#E57217", "#8F2201"), 
                      labels = c(leg1, leg2, leg3, leg4), 
                      opacity = 0.8)
    })
    
    observeEvent(input$geo, {
        if (input$geo == "geo_prov"){
            
            observe({
                
                age_prov_str <- ifelse(input$age_prov == "All", "all ages", 
                                       ifelse(input$age_prov == "0 to 18", "0 to 17",
                                              ifelse(input$age_prov == "18 to 64", "18 to 64", "65+")))
                
                gender_prov_str <- ifelse(input$gender_prov == "All", "all genders", 
                                          ifelse(input$gender_prov == "F", "female", "male"))
                
                year_prov_str <- ifelse(input$year_prov == "All", "all years", input$year_prov)
                
                label_prov = paste0("<span style = 'font-size: 125%;'><b>Province</b>: ", prov_react()$name, "<br><b>Age group</b>: ", age_prov_str, "<br><b>Gender</b>: ", gender_prov_str, "<br><b>Year</b>: ", year_prov_str, "<br><b>Incidence rate</b>: ", paste0(sprintf("%.1f ", round(prov_react()$INC_RT, 1)), "(95% CI: ", prov_react()$lower95, ", ", prov_react()$upper95, ")")) %>% lapply(htmltools::HTML) 
                
                leafletProxy("map", data = prov_react()) %>%
                    clearShapes() %>%
                    addPolygons(fillColor = ~pal(prov_react()$INC_RT),
                                color = "#363538",
                                weight = 2,
                                stroke = TRUE,
                                layerId = prov_react()$INDEX,
                                label = ~label_prov,
                                fillOpacity = 0.55,
                                highlightOptions = highlightOptions(color = "#363538", weight = 3, bringToFront = FALSE, opacity = 1)) 
                
            })
            
        } else if (input$geo == "geo_zone") {
            

            # create map for incidence rates with selected options to populated polygons, markers, and legend
            # map must be inside and observer
            observe({
                
                met_zone_str <- ifelse(input$met_zone == "yes", "<br><b>Status</b>: metropolitan", 
                                          ifelse(input$met_zone == "no", "<br><b>Status</b>: non-metropolitan", ""))
                
                age_zone_str <- ifelse(input$age_zone == "All", "all ages", 
                                ifelse(input$age_zone == "0 to 18", "0 to 17",
                                    ifelse(input$age_zone == "18 to 64", "18 to 64", "65+")))
                
                gender_zone_str <- ifelse(input$gender_zone == "All", "all genders", 
                                       ifelse(input$gender_zone == "F", "female", "male"))
                
                year_zone_str <- ifelse(input$year_zone == "All", "all years", input$year_zone)
                
                label_zone = paste0("<span style = 'font-size: 125%;'><b>Zone</b>: ", str_to_sentence(zone_react()$ZONE_NAME), met_zone_str, "<br><b>Age group</b>: ", age_zone_str, "<br><b>Gender</b>: ", gender_zone_str, "<br><b>Year</b>: ", year_zone_str, "<br><b>Incidence rate</b>: ", paste0(sprintf("%.1f ", round(zone_react()$INC_RT, 1)), "(95% CI: ", zone_react()$lower95, ", ", zone_react()$upper95, ")")) %>% lapply(htmltools::HTML) 
                
                leafletProxy("map", data = zone_react()) %>%
                    clearShapes() %>%
                    addPolygons(fillColor = ~pal(zone_react()$INC_RT),
                                color = "#363538",
                                weight = 2,
                                stroke = TRUE,
                                layerId = zone_react()$ZONE_NAME,
                                label = ~label_zone,
                                fillOpacity = 0.55,
                                highlightOptions = highlightOptions(color = "#363538", weight = 3, bringToFront = FALSE, opacity = 1))       
            })      

        } else if (input$geo == "geo_HSA") {
        
            observe({
                
                met_HSA_str <- ifelse(input$met_HSA == "yes", "<br><b>Status</b>: metropolitan", 
                                       ifelse(input$met_HSA == "no", "<br><b>Status</b>: non-metropolitan", ""))
                
                year_HSA_str <- ifelse(input$year_HSA == "All", "all years", input$year_HSA)
                
                label_HSA = paste0("<span style = 'font-size: 125%;'><b>HSA</b>: ", HSA_react()$HSA_NAME_FORMATTED, met_HSA_str, "<br><b>Year</b>: ", year_HSA_str, "<br><b>Incidence rate</b>: ", paste0(sprintf("%.1f ", round(HSA_react()$INC_RT, 1)), "(95% CI: ", HSA_react()$lower95, ", ", HSA_react()$upper95, ")")) %>% lapply(htmltools::HTML)
                
                leafletProxy("map", data = HSA_react()) %>%
                    clearShapes() %>%
                    addPolygons(fillColor = ~pal(HSA_react()$INC_RT),
                                color = "#363538",
                                weight = 2,
                                stroke = TRUE,
                                layerId = HSA_react()$HSA_NAME,
                                label = ~label_HSA,
                                fillOpacity = 0.55,
                                highlightOptions = highlightOptions(color = "#363538", weight = 3, bringToFront = FALSE, opacity = 1))       
            })
                
      }
    })

    }) # server

}

