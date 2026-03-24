# Celiac disease application; testing tab
# Contributor: Lindsay Hracs
# Date: 26-Jan-23
# R version 4.1.2
# Built on macOS Monterey 12.1

# user interface
testingUI <- function(id) {
    ns <- NS(id)
        
    sidebarLayout(
          
        sidebarPanel(width = 3, style = "font-size: 90%; height: 80vh; overflow-y: auto; background-color: #D4DADC;", # height: 85vh; overflow-y: auto; <-- for scroll bar
                             
            fluidRow(
                column(6, actionButton(inputId = ns("defs"), label = "Useful Definitions", icon = icon("book")), align = "center"), # add verify_fa = FALSE argument along with the name of the icon, i.e., icon = icon("icon-name", verify_fa = FALSE) 
                column(6, actionButton(inputId = ns("help"), label = "Help", icon = icon("circle-question")), align = "center")
            ),             
            
            hr(style = "border-top: 2px solid #363538;"), 
            
            conditionalPanel(condition = "input.ind_level == 0", ns = ns, #JS expression
                             
                HTML("<p style = 'font-size: 115%;'><b>Make selections below to view data from unique tests on the map:</b></p>"),             
                             
                selectInput(inputId = ns("geo"),
                            label = HTML("<span style = 'font-size: 115%;'>1. Select geographic area:</span>"),
                            choices = list("Provincial" = "geo_prov", "AHS Zone" = "geo_zone", "AHS Health Status Area" = "geo_HSA"),
                            selected = list("Provincial" = "geo_prov"),
                            width = "75%"
                ),
            
                conditionalPanel(condition = "input.geo == 'geo_prov'", ns = ns, #JS expression    
                                 
                    prettyRadioButtons(inputId = ns("age_prov"),
                                       label = HTML("<span style = 'font-size: 115%;'>2. Select age group:</span>"), 
                                       choices = list("All ages" = "All", "0 to 17" = "0 to 18", "18 to 64" = "18 to 64", "65+" = "65 and over"),
                                       inline = TRUE,
                                       status = "info"
                    ),
                             
                    prettyRadioButtons(inputId = ns("gender_prov"),
                                       label = HTML("<span style = 'font-size: 115%;'>3. Select gender:</span>"),
                                       choices = list("All genders" = "A", "Female" = "F", "Male" = "M"),
                                       inline = TRUE,
                                       status = "info"
                    ),
                             
                    sliderTextInput(inputId = ns("year_prov"),
                                    label = HTML("<span style = 'font-size: 115%;'>4. Select year:</span><br><span style = 'font-size: 100%;'>(Click on the slider bar to view a specific year or click the play button under time slider to view animation.)</span>"),
                                    choices = list("All" = "All", "2013" = "2013", "2014" = "2014", "2015" = "2015", "2016" = "2016", "2017" = "2017", "2018" = "2018", "2019" = "2019", "2020" = "2020"),
                                    grid = TRUE,
                                    animate = animationOptions(interval = 2500, loop = FALSE),
                    ),
                ),
            
                conditionalPanel(condition = "input.geo == 'geo_zone'", ns = ns, #JS expression    
                                 
                    prettyRadioButtons(inputId = ns("met_zone"), 
                                        label = HTML("<span style = 'font-size: 115%;'>2. Select metropolitan status to subset and view:</span>"), 
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
                                       choices = list("All genders" = "A", "Female" = "F", "Male" = "M"),
                                       inline = TRUE,
                                       status = "info",
                    ),
                             
                    sliderTextInput(inputId = ns("year_zone"),
                                    label = HTML("<span style = 'font-size: 115%;'>5. Select year:</span><br><span style = 'font-size: 100%;'>(Click on the slider bar to view a specific year or click the play button under time slider to view animation.)</span>"),
                                    choices = list("All" = "All", "2013" = "2013", "2014" = "2014", "2015" = "2015", "2016" = "2016", "2017" = "2017", "2018" = "2018", "2019" = "2019", "2020" = "2020"),
                                    grid = TRUE, 
                                    animate = animationOptions(interval = 3500, loop = FALSE),
                    ),
                ),
            
                conditionalPanel(condition = "input.geo == 'geo_HSA'", ns = ns, #JS expression   
                                 
                    prettyRadioButtons(inputId = ns("met_HSA"), 
                                    label = HTML("<span style = 'font-size: 115%;'>2. Select metropolitan status to subset and view:</span>"), 
                                    choices = list("All" = "all", "Metropolitan only" = "yes", "Non-metropolitan only" = "no"),
                                    inline = TRUE,
                                    status = "info",
                                    shape = "square",
                                    icon = icon("square-check")
                    ),             
                                 
                    sliderTextInput(inputId = ns("year_HSA"),
                                    label = HTML("<span style = 'font-size: 115%;'>3. Select year:</span><br><span style = 'font-size: 100%;'>(Click on the slider bar to view a specific year or click the play button under time slider to view animation.)</span>"),
                                    choices = list("All" = "All", "2013" = "2013", "2014" = "2014", "2015" = "2015", "2016" = "2016", "2017" = "2017", "2018" = "2018", "2019" = "2019", "2020" = "2020"),
                                    grid = TRUE,
                                    animate = animationOptions(interval = 4500, loop = FALSE),
                    )
                ),
            
            ),
        
            
            conditionalPanel(condition = "input.ind_level == 1", ns = ns, #JS expression    
                             
                HTML("<p style = 'font-size: 115%;'><b>Make selections below to view individual- level data on the map:</b></p>"),             
                            
                selectInput(inputId = ns("geo_ind"),
                            label = HTML("<span style = 'font-size: 115%;'>1. Select geographic area:</span>"),
                            choices = list("Provincial" = "geo_prov", "AHS Zone" = "geo_zone", "AHS Health Status Area" = "geo_HSA"),
                            selected = list("Provincial" = "geo_prov"),
                            width = "75%"
                ),
                            
                conditionalPanel(condition = "input.geo_ind == 'geo_prov'", ns = ns, #JS expression    
                                             
                    prettyRadioButtons(inputId = ns("age_prov_ind"),
                                       label = HTML("<span style = 'font-size: 115%;'>2. Select age group:</span>"), 
                                       choices = list("All ages" = "All", "0 to 17" = "0 to 18", "18 to 64" = "18 to 64", "65+" = "65 and over"),
                                       inline = TRUE,
                                       status = "info"
                    ),
                                             
                    prettyRadioButtons(inputId = ns("gender_prov_ind"),
                                       label = HTML("<span style = 'font-size: 115%;'>3. Select gender:</span>"),
                                       choices = list("All genders" = "A", "Female" = "F", "Male" = "M"),
                                       inline = TRUE,
                                       status = "info"
                    ),
                    
                ),
                            
                conditionalPanel(condition = "input.geo_ind == 'geo_zone'", ns = ns, #JS expression    
                                 
                    prettyRadioButtons(inputId = ns("met_zone_ind"), 
                                       label = HTML("<span style = 'font-size: 115%;'>2. Select metropolitan status to subset and view:</span>"),
                                       choices = list("All" = "all", "Metropolitan only" = "yes", "Non-metropolitan only" = "no"),
                                       inline = TRUE,
                                       status = "info",
                                       shape = "square",
                                       icon = icon("square-check")
                    ),             
                                             
                    prettyRadioButtons(inputId = ns("age_zone_ind"),
                                       label = HTML("<span style = 'font-size: 115%;'>3. Select age group:</span>"), 
                                       choices = list("All ages" = "All", "0 to 17" = "0 to 18", "18 to 64" = "18 to 64", "65+" = "65 and over"),
                                       inline = TRUE,
                                       status = "info",
                    ),
                                             
                    prettyRadioButtons(inputId = ns("gender_zone_ind"),
                                       label = HTML("<span style = 'font-size: 115%;'>4. Select gender:</span>"),
                                       choices = list("All genders" = "A", "Female" = "F", "Male" = "M"),
                                       inline = TRUE,
                                       status = "info",
                    ),
                                             
                ),
                            
                conditionalPanel(condition = "input.geo_ind == 'geo_HSA'", ns = ns, #JS expression    
                    
                    prettyRadioButtons(inputId = ns("met_HSA_ind"),
                                       label = HTML("<span style = 'font-size: 115%;'>2. Select metropolitan status to subset and view:</span>"),
                                       choices = list("All" = "all", "Metropolitan only" = "yes", "Non-metropolitan only" = "no"),
                                       inline = TRUE,
                                       status = "info",
                                       shape = "square",
                                       icon = icon("square-check")
                    ),                
                                                          
                    # prettyRadioButtons(inputId = ns("age_HSA_ind"),
                    #                    label = HTML("<span style = 'font-size: 115%;'>2. Select age group:</span>"), 
                    #                    choices = list("All ages" = "All", "0 to 17" = "0 to 18", "18 to 64" = "18 to 64", "65+" = "65 and over"),
                    #                    inline = TRUE,
                    #                    status = "info",
                    # ),
                    #              
                    # prettyRadioButtons(inputId = ns("gender_HSA_ind"),
                    #                    label = HTML("<span style = 'font-size: 115%;'>3. Select gender:</span>"),
                    #                    choices = list("All genders" = "A", "Female" = "F", "Male" = "M"),
                    #                    inline = TRUE,
                    #                    status = "info",
                    # ),
                
                ),            
                            
           ),           
            
            prettyCheckbox(inputId = ns("ind_level"),
                          label = "View individual-level data only",
                          value = FALSE,
                          status = "info",
                          icon = icon("check")),
           
            
            hr(style = "border-top: 2px solid #363538;"),
            
            div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/UC-Cumming-Centre%20for%20Health%20Informatics.jpg", height = "75%", width = "75%"), href = "https://cumming.ucalgary.ca/centres/centre-health-informatics/", target = "_blank"), align = "center"),
            
            div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AB_SPOR.jpg", height = "60%", width = "60%"), href = "https://absporu.ca/", target = "_blank"), align = "center"),
            
            div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AHS.png", height = "60%", width = "60%"), href = "https://www.albertahealthservices.ca/", target = "_blank"), align = "center"),
            
        ),
            
        mainPanel(
            
            conditionalPanel(condition = "input.ind_level == 0", ns = ns, width = 9,
                # conditionalPanel size is wonky; changed width to 100% to match incidence panel    
                leafletOutput(ns("map"), width = "110%", height = "80vh"), 
                
            ),
            
            conditionalPanel(condition = "input.ind_level == 1", ns = ns,
                             
                leafletOutput(ns("map_ind"), width = "110%", height = "80vh"),     
                                          
            ),
            
            
        ) %>% withSpinner()
          
    ) # sidebarLayout 
    
} # fluidPage

####################################################################################################################################################
####################################################################################################################################################
############################################################################################################################################################################################################################################################################################################################################################################################################################################################

# server
testingServer <- function(id) {
    
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
                     Make selections in the sidebar to view maps and data for different variable combinations.
                     <br><br>For testing rate hover mouse over the province, zone, or HSA shape.</p>"),
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
                HTML("<p style = 'font-size: 100%;'>Testing rates are based on lab tests for <b>anti-tissue transglutaminase antibodies (tTG-IgA)</b>. The unit of analysis for testing rates is unique tests – if an individual was tested multiple times during the study period, each test is reflected in the estimated rate. Rates are estimated per 1,000 person-years. To view rates where the unit of analysis is unique to an individual (i.e., based on their first test in the time period), click the “View individual-level data only” checkbox. Due to potential issues with comparability, individual-level data are not filterable by year.<br><br>
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
        test_prov_data %>%
            filter(AGE_CAT %in% input$age_prov, GENDER %in% input$gender_prov, FY %in% input$year_prov)
    })
    
    zone_react <- reactive({
        if(input$met_zone ==  "all"){
            zone_react <- test_zone_data %>%
                filter(AGE_CAT %in% input$age_zone, GENDER %in% input$gender_zone, FY %in% input$year_zone)
        } else if (input$met_zone ==  "yes"){
            zone_react <- test_zone_data_met %>%
                filter(AGE_CAT %in% input$age_zone, GENDER %in% input$gender_zone, FY %in% input$year_zone)
        } else if (input$met_zone ==  "no") {
            zone_react <- test_zone_data_nonmet %>%
                filter(AGE_CAT %in% input$age_zone, GENDER %in% input$gender_zone, FY %in% input$year_zone)
        }
    })

    HSA_react <- reactive({
        if(input$met_HSA ==  "all"){
            HSA_react <- test_HSA_data %>%
                filter(FY %in% input$year_HSA)
        } else if (input$met_HSA ==  "yes"){
            HSA_react <- test_HSA_data_met %>%
                filter(FY %in% input$year_HSA)
        } else if (input$met_HSA ==  "no") {
            HSA_react <- test_HSA_data_nonmet %>%
                filter(FY %in% input$year_HSA)
        }
    })
    
    # set palette
    
    # data to create palette with bins that auto-adjust to full rate range
    # prov, zone, and HSA combined to have same legend for each map
    test_rates <- data.frame(rate = c(test_prov[,"TEST_RT"], test_zone[,"TEST_RT"], test_HSA[,"TEST_RT"]))
    
    quantiles <- quantile(test_rates$rate, na.rm = TRUE)
    pal <- colorBin(palette = c("#FFFED4", "#FEC46C", "#E57217", "#8F2201"), bins = quantiles, pretty = FALSE)
    leg1 <- paste0(sprintf("%.2f", round(quantiles[1], 2)), "–", sprintf("%.2f", round((quantiles[2] - 0.01), 2)))
    leg2 <- paste0(sprintf("%.2f", round(quantiles[2], 2)), "–", sprintf("%.2f", round((quantiles[3] - 0.01), 2)))
    leg3 <- paste0(sprintf("%.2f", round(quantiles[3], 2)), "–", sprintf("%.2f", round((quantiles[4] - 0.01), 2)))
    leg4 <- paste0(sprintf("%.2f", round(quantiles[4], 2)), "+")
    
    # set map for click on Testing Rates tab
    observe({
        
        age_prov_str <- ifelse(input$age_prov == "All", "all ages", 
                               ifelse(input$age_prov == "0 to 18", "0 to 17",
                                      ifelse(input$age_prov == "18 to 64", "18 to 64", "65+")))
        
        gender_prov_str <- ifelse(input$gender_prov == "A", "all genders", 
                                  ifelse(input$gender_prov == "F", "female", "male"))
        
        year_prov_str <- ifelse(input$year_prov == "All", "all years", input$year_prov)
        
        label_prov = paste0("<span style = 'font-size: 125%;'><b>Province</b>: ", prov_react()$name, "<br><b>Age group</b>: ", age_prov_str, "<br><b>Gender</b>: ", gender_prov_str, "<br><b>Year</b>: ", year_prov_str, "<br><b>Testing rate</b>: ", paste0(sprintf("%.1f ", round(prov_react()$TEST_RT, 1)), "(95% CI: ", prov_react()$lower95, ", ", prov_react()$upper95, ")")) %>% lapply(htmltools::HTML) 
    
    
        output$map <- renderLeaflet({
            leaflet(options = leafletOptions(worldCopyJump = TRUE, minZoom = 2)) %>%
                addTiles() %>%
                setView(lng = -115, lat = 54, zoom = 5) %>%
                addPolygons(data = prov_react(),
                            fillColor = ~pal(prov_react()$TEST_RT),
                            color = "#363538",
                            weight = 2,
                            stroke = TRUE,
                            layerId = "landing layer",
                            label = ~label_prov,
                            fillOpacity = 0.55,
                            highlightOptions = highlightOptions(color = "#363538", weight = 3, bringToFront = FALSE, opacity = 1)) %>%
                addLegend(position = "bottomleft",
                          title = "Testing rate<br>(per 1,000 person-years)", 
                          colors = c("#FFFED4", "#FEC46C", "#E57217", "#8F2201"), 
                          labels = c(leg1, leg2, leg3, leg4), 
                          opacity = 0.8)
        })
    
    })
    
    observeEvent(input$geo, {
        if (input$geo == "geo_prov"){
            
            observe({
                
                age_prov_str <- ifelse(input$age_prov == "All", "all ages", 
                                       ifelse(input$age_prov == "0 to 18", "0 to 17",
                                              ifelse(input$age_prov == "18 to 64", "18 to 64", "65+")))
                
                gender_prov_str <- ifelse(input$gender_prov == "A", "all genders", 
                                          ifelse(input$gender_prov == "F", "female", "male"))
                
                year_prov_str <- ifelse(input$year_prov == "All", "all years", input$year_prov)
                
                label_prov = paste0("<span style = 'font-size: 125%;'><b>Province</b>: ", prov_react()$name, "<br><b>Age group</b>: ", age_prov_str, "<br><b>Gender</b>: ", gender_prov_str, "<br><b>Year</b>: ", year_prov_str, "<br><b>Testing rate</b>: ", paste0(sprintf("%.1f ", round(prov_react()$TEST_RT, 1)), "(95% CI: ", prov_react()$lower95, ", ", prov_react()$upper95, ")")) %>% lapply(htmltools::HTML) 
                
                leafletProxy("map", data = prov_react()) %>%
                    clearShapes() %>%
                    addPolygons(fillColor = ~pal(prov_react()$TEST_RT),
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
                
                gender_zone_str <- ifelse(input$gender_zone == "A", "all genders", 
                                       ifelse(input$gender_zone == "F", "female", "male"))
                
                year_zone_str <- ifelse(input$year_zone == "All", "all years", input$year_zone)
                
                label_zone = paste0("<span style = 'font-size: 125%;'><b>Zone</b>: ", str_to_sentence(zone_react()$ZONE_NAME), met_zone_str, "<br><b>Age group</b>: ", age_zone_str, "<br><b>Gender</b>: ", gender_zone_str, "<br><b>Year</b>: ", year_zone_str, "<br><b>Testing rate</b>: ", paste0(sprintf("%.1f ", round(zone_react()$TEST_RT, 1)), "(95% CI: ", zone_react()$lower95, ", ", zone_react()$upper95, ")")) %>% lapply(htmltools::HTML) 
                
                leafletProxy("map", data = zone_react()) %>%
                    clearShapes() %>%
                    addPolygons(fillColor = ~pal(zone_react()$TEST_RT),
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
                
                label_HSA = paste0("<span style = 'font-size: 125%;'><b>HSA</b>: ", HSA_react()$HSA_NAME_FORMATTED, met_HSA_str, "<br><b>Year</b>: ", year_HSA_str, "<br><b>Testing rate</b>: ", paste0(sprintf("%.1f ", round(HSA_react()$TEST_RT, 1)), "(95% CI: ", HSA_react()$lower95, ", ", HSA_react()$upper95, ")")) %>% lapply(htmltools::HTML)
                
                leafletProxy("map", data = HSA_react()) %>%
                    clearShapes() %>%
                    addPolygons(fillColor = ~pal(HSA_react()$TEST_RT),
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
    
    
    ################# individual-level map #################
    
    error_message <- HTML("<span style = 'font-size: 250%; color: #408697; text-align: center;'>Please check back soon for testing rate maps with individual level data!</span>")
    
    prov_react_ind <- reactive({
        indiv_prov_data %>%
            filter(AGE_CAT %in% input$age_prov_ind, GENDER %in% input$gender_prov_ind)
    })
    
    zone_react_ind <- reactive({
        if(input$met_zone_ind ==  "all"){
            zone_react_ind <- indiv_zone_data %>%
                filter(AGE_CAT %in% input$age_zone_ind, GENDER %in% input$gender_zone_ind)
        } else if (input$met_zone_ind ==  "yes"){
            zone_react_ind <- indiv_zone_data_met %>%
                filter(AGE_CAT %in% input$age_zone_ind, GENDER %in% input$gender_zone_ind)
        } else if (input$met_zone_ind ==  "no") {
            zone_react_ind <- indiv_zone_data_nonmet %>%
                filter(AGE_CAT %in% input$age_zone_ind, GENDER %in% input$gender_zone_ind)
        }
    })
    
    HSA_react_ind <- reactive({
        if(input$met_HSA_ind ==  "all"){
            HSA_react_ind <- indiv_HSA_data
        } else if (input$met_HSA_ind ==  "yes"){
            HSA_react_ind <- indiv_HSA_data_met
        } else if (input$met_HSA_ind ==  "no") {
            HSA_react_ind <- indiv_HSA_data_nonmet
        }
    })
    
    output$map_ind <- renderLeaflet({
        leaflet(options = leafletOptions(worldCopyJump = TRUE, minZoom = 2)) %>%
            addTiles() %>%
            setView(lng = -115, lat = 54, zoom = 5) %>%
            addControl(error_message, position = "topleft")
        #%>%
        # addLegend(position = "bottomleft",
        #           title = "Testing rate<br>(per 100,000 person-years)", 
        #           colors = c("#FFFED4", "#FEC46C", "#E57217", "#8F2201"), 
        #           labels = c(leg1, leg2, leg3, leg4), 
        #           opacity = 0.8)
    })
    
    # set map for check on individual testing rates checkbox
    observe({
        
        age_prov_str_ind <- ifelse(input$age_prov_ind == "All", "all ages", 
                               ifelse(input$age_prov_ind == "0 to 18", "0 to 17",
                                      ifelse(input$age_prov_ind == "18 to 64", "18 to 64", "65+")))
        
        gender_prov_str_ind <- ifelse(input$gender_prov_ind == "A", "all genders", 
                                  ifelse(input$gender_prov_ind == "F", "female", "male"))
        
        label_prov_ind = paste0("<span style = 'font-size: 125%;'><b>Province</b>: ", prov_react_ind()$name, "<br><b>Age group</b>: ", age_prov_str_ind, "<br><b>Gender</b>: ", gender_prov_str_ind, "<br><b>Testing rate</b>: ", paste0(sprintf("%.1f ", round(prov_react_ind()$TEST_RT, 1)), "(95% CI: ", prov_react_ind()$lower95, ", ", prov_react_ind()$upper95, ")")) %>% lapply(htmltools::HTML) 
        
        
        output$map_ind <- renderLeaflet({
            leaflet(options = leafletOptions(worldCopyJump = TRUE, minZoom = 2)) %>%
                addTiles() %>%
                setView(lng = -115, lat = 54, zoom = 5) %>%
                addPolygons(data = prov_react_ind(),
                            fillColor = ~pal(prov_react_ind()$TEST_RT),
                            color = "#363538",
                            weight = 2,
                            stroke = TRUE,
                            layerId = "landing layer",
                            label = ~label_prov_ind,
                            fillOpacity = 0.55,
                            highlightOptions = highlightOptions(color = "#363538", weight = 3, bringToFront = FALSE, opacity = 1)) %>%
                addLegend(position = "bottomleft",
                          title = "Testing rate<br>(per 1,000 person-years)", 
                          colors = c("#FFFED4", "#FEC46C", "#E57217", "#8F2201"), 
                          labels = c(leg1, leg2, leg3, leg4), 
                          opacity = 0.8)
        })
        
    })
    
    observeEvent(input$geo_ind, {
        if (input$geo_ind == "geo_prov"){
            
            observe({
                
                age_prov_str_ind <- ifelse(input$age_prov_ind == "All", "all ages", 
                                       ifelse(input$age_prov_ind == "0 to 18", "0 to 17",
                                              ifelse(input$age_prov_ind == "18 to 64", "18 to 64", "65+")))
                
                gender_prov_str_ind <- ifelse(input$gender_prov_ind == "A", "all genders", 
                                          ifelse(input$gender_prov_ind == "F", "female", "male"))
                
                label_prov_ind = paste0("<span style = 'font-size: 125%;'><b>Province</b>: ", prov_react_ind()$name, "<br><b>Age group</b>: ", age_prov_str_ind, "<br><b>Gender</b>: ", gender_prov_str_ind, "<br><b>Testing rate</b>: ", paste0(sprintf("%.1f ", round(prov_react_ind()$TEST_RT, 1)), "(95% CI: ", prov_react_ind()$lower95, ", ", prov_react_ind()$upper95, ")")) %>% lapply(htmltools::HTML) 
                
                leafletProxy("map_ind", data = prov_react_ind()) %>%
                    clearShapes() %>%
                    addPolygons(fillColor = ~pal(prov_react_ind()$TEST_RT),
                                color = "#363538",
                                weight = 2,
                                stroke = TRUE,
                                layerId = prov_react_ind()$INDEX,
                                label = ~label_prov_ind,
                                fillOpacity = 0.55,
                                highlightOptions = highlightOptions(color = "#363538", weight = 3, bringToFront = FALSE, opacity = 1)) 
                
            })
            
        } else if (input$geo_ind == "geo_zone") {
            
            
            # create map for incidence rates with selected options to populated polygons, markers, and legend
            # map must be inside and observer
            observe({
                
                met_zone_str_ind <- ifelse(input$met_zone_ind == "yes", "<br><b>Status</b>: metropolitan", 
                                       ifelse(input$met_zone_ind == "no", "<br><b>Status</b>: non-metropolitan", ""))
                
                age_zone_str_ind <- ifelse(input$age_zone_ind == "All", "all ages", 
                                       ifelse(input$age_zone_ind == "0 to 18", "0 to 17",
                                              ifelse(input$age_zone_ind == "18 to 64", "18 to 64", "65+")))
                
                gender_zone_str_ind <- ifelse(input$gender_zone_ind == "A", "all genders", 
                                          ifelse(input$gender_zone_ind == "F", "female", "male"))
                
                label_zone_ind = paste0("<span style = 'font-size: 125%;'><b>Zone</b>: ", str_to_sentence(zone_react_ind()$ZONE_NAME), met_zone_str_ind, "<br><b>Age group</b>: ", age_zone_str_ind, "<br><b>Gender</b>: ", gender_zone_str_ind, "<br><b>Testing rate</b>: ", paste0(sprintf("%.1f ", round(zone_react_ind()$TEST_RT, 1)), "(95% CI: ", zone_react_ind()$lower95, ", ", zone_react_ind()$upper95, ")")) %>% lapply(htmltools::HTML) 
                
                leafletProxy("map_ind", data = zone_react_ind()) %>%
                    clearShapes() %>%
                    addPolygons(fillColor = ~pal(zone_react_ind()$TEST_RT),
                                color = "#363538",
                                weight = 2,
                                stroke = TRUE,
                                layerId = zone_react_ind()$ZONE_NAME,
                                label = ~label_zone_ind,
                                fillOpacity = 0.55,
                                highlightOptions = highlightOptions(color = "#363538", weight = 3, bringToFront = FALSE, opacity = 1))       
            })      
            
        } else if (input$geo_ind == "geo_HSA") {
            
            observe({
                
                met_HSA_str_ind <- ifelse(input$met_HSA_ind == "yes", "<br><b>Status</b>: metropolitan", 
                                      ifelse(input$met_HSA_ind == "no", "<br><b>Status</b>: non-metropolitan", ""))
                
                label_HSA_ind = paste0("<span style = 'font-size: 125%;'><b>HSA</b>: ", HSA_react_ind()$HSA_NAME_FORMATTED, met_HSA_str_ind, "<br><b>Testing rate</b>: ", paste0(sprintf("%.1f ", round(HSA_react_ind()$TEST_RT, 1)), "(95% CI: ", HSA_react_ind()$lower95, ", ", HSA_react_ind()$upper95, ")")) %>% lapply(htmltools::HTML)
                
                leafletProxy("map_ind", data = HSA_react_ind()) %>%
                    clearShapes() %>%
                    addPolygons(fillColor = ~pal(HSA_react_ind()$TEST_RT),
                                color = "#363538",
                                weight = 2,
                                stroke = TRUE,
                                layerId = HSA_react_ind()$HSA_NAME,
                                label = ~label_HSA_ind,
                                fillOpacity = 0.55,
                                highlightOptions = highlightOptions(color = "#363538", weight = 3, bringToFront = FALSE, opacity = 1))       
            })
            
        }
    })

    }) # server

}

