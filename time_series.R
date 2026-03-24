# Celiac disease application; 3D plots tab
# Contributor: Lindsay Hracs, Julia Gorospe
# Date: 26-Jan-23
# Date updated: 2026-03-24
# R version 4.1.2
# Built on macOS Monterey 12.1

# user interface
time_seriesUI <- function(id) {
    ns <- NS(id)
    
    sidebarLayout(
        
        sidebarPanel(width = 3, style = "font-size: 90%; height: 80vh; overflow-y: auto; background-color: #D4DADC;", # height: 85vh; overflow-y: auto; <-- for scroll bar
                     
                     fluidRow(
                         column(6, actionButton(inputId = ns("defs"), label = "Useful Definitions", icon = icon("book", verify_fa = FALSE)), align = "center"), # add verify_fa = FALSE argument along with the name of the icon, i.e., icon = icon("icon-name", verify_fa = FALSE) 
                         column(6, actionButton(inputId = ns("help"), label = "Help", icon = icon("circle-question")), align = "center") 
                     ),
                     
                     hr(style = "border-top: 2px solid #363538;"), 

                     
                     HTML("<p style = 'font-size: 115%;'><b>Make selections below to view a subset of the data:</b></p>"),
                     
                     prettyRadioButtons(inputId = ns("age"),
                                        label = HTML("<span style = 'font-size: 115%;'>Age category:</span>"),
                                        choices = list("All Ages" = "Overall", "Adults (18+)" = "Adults", "Children (0-17)" = "Children"),
                                        selected = "Overall",
                                        inline = FALSE,
                                        status = "info"
                     ),
                     
                     prettyRadioButtons(inputId = ns("ttg_level"),
                                        label = HTML("<span style = 'font-size: 115%;'>TTG Level:</span>"),
                                        choices = list("All Positive Tests" = "Positive", "High TTG (>=10x the upper limit of normal)" = "10x ULN"),
                                        selected = "Positive",
                                        inline = FALSE,
                                        status = "info"
                     ),
                     
                     
                     hr(style = "border-top: 2px solid #363538;"),
                     
                     div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/UC-Cumming-Centre%20for%20Health%20Informatics.jpg", height = "75%", width = "75%"), href = "https://cumming.ucalgary.ca/centres/centre-health-informatics/", target = "_blank"), align = "center"),
                     
                     div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AB_SPOR.jpg", height = "60%", width = "60%"), href = "https://absporu.ca/", target = "_blank"), align = "center"),
                     
                     div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AHS.png", height = "60%", width = "60%"), href = "https://www.albertahealthservices.ca/", target = "_blank"), align = "center"),
                     
        ),
        
        mainPanel(
            style = "padding: 15px;", #margin-top: 10px; margin-left: 10px; 
            plotlyOutput(ns("plot"), width = "100%", height = "75vh") %>% withSpinner()
            
        )
        
    ) # sidebarLayout 
    
} # fluidPage

####################################################################################################################################################
####################################################################################################################################################
############################################################################################################################################################################################################################################################################################################################################################################################################################################################

# server
time_seriesServer <- function(id) {
    
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
                    title = "How to Use the Interactive Plots",
                    HTML("<p style = 'font-size: 150%;'><p>Use your mouse or trackpad to zoom in on particular data or hover above lines to view a pop-up with data values. The control panel at the top of the plot can be used to zoom, pan, scale, reset view, or even download the plot as a PNG file. Click on items in the legend to subset what you see in the plot. Double-click an item in the legend to isolate that item on the plot.</p>"),
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
                    Testing rates are based on lab tests for <b>anti-tissue transglutaminase antibodies (tTG-IgA)</b>. The unit of analysis for testing rates is unique tests – if an individual was tested multiple times during the study period, each test is reflected in the estimated rate. Rates are estimated per 1,000 person-years.<br><br>
                    Auto-Regressive Integrated Moving Average (ARIMA) models were use to forecast inicidence rates (ARIMA(0,1,1)) and testing rates (ARIMA(1,0,0)(1,0,0)[12] with non-zero mean).<br><br>
                    </p>"),
                    size = "l",
                    footer = modalButton("Close"),
                    easyClose = TRUE
                ))
            }else{}
            
        })
        
        # create reactive dataframe
        time_react <- reactive({
            time_obs %>% 
                filter(Age == input$age,
                       TTG == input$ttg_level)
        })
        
        trend_react <- reactive({
            time_trends %>% 
                filter(Age == input$age,
                       TTG == input$ttg_level)
        })
        
        # set plot font format
        #t_font <- list(color = "black", size = 25)
        
        # vertical lines position for period partitions
        covid_start <- as.Date("2020-01-01")
        covid_end <- as.Date("2020-12-31")
        
        # indicator of pandemic period
        vline <- function(x, color) { # colour matches plotly default for fonts
            list(
                type = "line",
                y0 = 0,
                y1 = 1,
                yref = "paper",
                x0 = x,
                x1 = x,
                line = list(color = color, dash = "dash")
            )
        }
        
        pandemic_rect <- list(
            type = "rect",
            fillcolor = "grey",
            line = list(width = 0),
            opacity = 0.2,
            x0 = covid_start,  
            x1 = covid_end, 
            xref = "x",        
            y0 = 0,            
            y1 = 1,         
            yref = "paper",      
            layer = "below",
            name = "Pandemic Period<br>(excluded from trends)",
            showlegend = TRUE
        )
        
        
        # mainPanel plot 
        output$plot <- renderPlotly({
            
            # get annotations
            trends <- trend_react()
            
            # labels for period segments with AQPCs
            covid_annote = list(
                list(
                    x = as.Date("2017-06-01"),  # mid-point of segment
                    y = 0.97,
                    yref = "paper",
                    text = "Pre-pandemic",
                    xanchor = "center",
                    yanchor = "center",
                    showarrow = FALSE,
                    font = list(size = 18, color = "#363538")
                ),
                list(
                    x = as.Date("2017-06-01"),  # mid-point of segment
                    y = 0.92,
                    yref = "paper",
                    text = paste0("AQPC: ", trends$AQPC_pre),
                    xanchor = "center",
                    yanchor = "center",
                    showarrow = FALSE,
                    font = list(size = 14, color = "#363538")
                ),
                list(
                    x = as.Date("2023-01-01"),  # mid-point of segment
                    y = 0.97,
                    yref = "paper",
                    text = "Post-pandemic",
                    xanchor = "center",
                    yanchor = "center",
                    showarrow = FALSE,
                    font = list(size = 18, color = "#363538")
                ),
                list(
                    x = as.Date("2023-01-01"),  # mid-point of segment
                    y = 0.92,
                    yref = "paper",
                    text = paste0("AQPC: ", trends$AQPC_post),
                    xanchor = "center",
                    yanchor = "center",
                    showarrow = FALSE,
                    font = list(size = 14, color = "#363538")
                ),
                list(
                    x = 0,
                    xref = "paper",
                    y = -0.17,
                    yref = "paper",
                    text = paste0("Test for difference in trends between pre-pandemic and post-pandemic periods: ", trends$Trend),
                    xanchor = "left",
                    yanchor = "center",
                    showarrow = FALSE,
                    font = list(size = 14, color = "#363538")
                ),
                list(
                    x = 0,
                    xref = "paper",
                    y = -0.21,
                    yref = "paper",
                    text = "AQPC = average quarterly percent change, * = statistically significant",
                    xanchor = "left",
                    yanchor = "center",
                    showarrow = FALSE,
                    font = list(size = 14, color = "#363538")
                )
            )
            
            # build plot
            plot_ly(time_react()) %>% 
                add_trace(
                    x = ~x,
                    y = ~Est,
                    type = "scatter", mode = "lines",
                    line = list(size = 9, color = "#DE8033", shape = 'spline', smoothing = 1),
                    hoverinfo = 'skip',
                    name = "LOESS Trend"
                ) %>% 
                add_ribbons(
                    x = ~x,
                    ymin = ~Lower,  
                    ymax = ~Upper,   
                    fillcolor = toRGB("#DE8033", alpha = 0.3), 
                    line = list(width = 0, shape = 'spline', smoothing = 1),
                    hoverinfo = 'skip',
                    name = 'LOESS 95%CI'
                ) %>%
                add_trace(
                    x = ~x,
                    y = ~Rate,
                    type = "scatter", mode = "markers",
                    marker = list(size = 7, color = "#408697"),
                    text = ~paste0("Date: ", date_yq, 
                                   "<br>Incidence: ", sprintf("%.1f", Rate),
                                   "<br>Age group: ", Age,
                                   "<br>TTG level: ", TTG),
                    hoverinfo = "text",
                    name = "Observed"
                ) %>% 
                layout(
                    title = list(text = "<b>Observed Trends in Incidence Rates over Time</b>", font = list(size = 20)),
                    legend = list(title = list(text = "Measure", font = list(size = 16)),
                                  font = list(size = 14)),
                    xaxis = list(title = list(text = "Year",
                                               standoff = 8),
                                 titlefont = list(size = 18),
                                 tickfont = list(size = 16),
                                 linewidth = 0.5),
                    yaxis = list(title = "Incidence (per 100,000 person-years)",
                                 range = c(0, 1.2*max(time_react()$Rate)),
                                 titlefont = list(size = 18),
                                 tickfont = list(size = 16),
                                 linewidth = 0.5),
                    annotations = covid_annote,
                    shapes = list(pandemic_rect, vline(covid_start, "#363538"), vline(covid_end, "#363538")),
                    margin = list(t = 60, r = 0, b=120)
                ) 
            
        }) # renderPlotly
        
    }) # server
    
}

