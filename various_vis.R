# Celiac disease application; 3D plots tab
# Contributor: Lindsay Hracs
# Date: 26-Jan-23
# R version 4.1.2
# Built on macOS Monterey 12.1

# user interface
various_visUI <- function(id) {
    ns <- NS(id)
    
    sidebarLayout(
        
        sidebarPanel(width = 3, style = "font-size: 90%; height: 80vh; overflow-y: auto; background-color: #D4DADC;", # height: 85vh; overflow-y: auto; <-- for scroll bar
                     
                     fluidRow(
                         column(6, actionButton(inputId = ns("defs"), label = "Useful Definitions", icon = icon("book", verify_fa = FALSE)), align = "center"), # add verify_fa = FALSE argument along with the name of the icon, i.e., icon = icon("icon-name", verify_fa = FALSE) 
                         column(6, actionButton(inputId = ns("help"), label = "Help", icon = icon("circle-question")), align = "center") 
                     ),
                     
                     hr(style = "border-top: 2px solid #363538;"), 
                     
                     prettyRadioButtons(inputId = ns("age_breakdown"),
                                        label = HTML("<span style = 'font-size: 115%;'>Select age band for the plot x-axis:</span>"),
                                        choices = list("1 year" = "1yr", "5 years" = "5yr"),
                                        inline = TRUE,
                                        status = "info"
                     ),
                     
                     hr(style = "border-top: 2px solid #363538;"),
                     
                     div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/UC-Cumming-Centre%20for%20Health%20Informatics.jpg", height = "75%", width = "75%"), href = "https://cumming.ucalgary.ca/centres/centre-health-informatics/", target = "_blank"), align = "center"),
                     
                     div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AB_SPOR.jpg", height = "60%", width = "60%"), href = "https://absporu.ca/", target = "_blank"), align = "center"),
                     
                     div(class = "logo", tags$a(img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AHS.png", height = "60%", width = "60%"), href = "https://www.albertahealthservices.ca/", target = "_blank"), align = "center"),
                     
        ),
        
        mainPanel(
            
            plotlyOutput(ns("threeDplot"), width = "100%", height = "80vh") %>% withSpinner()
            
        )
        
    ) # sidebarLayout 
    
} # fluidPage

####################################################################################################################################################
####################################################################################################################################################
############################################################################################################################################################################################################################################################################################################################################################################################################################################################

# server
various_visServer <- function(id) {
    
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
                    title = "How to Use the Interactive 3D Plots",
                    HTML("<p style = 'font-size: 150%;'><p>Use your mouse or trackpad to zoom in on particular data points or clusters, rotate the plot, or click on a point to view the x, y, and z axis values. The control panel at the top of the plot can be used to zoom, pan, rotate, reset view, or even download the plot as a PNG file. Click on items in the legend to subset what you see in the plot. Double-click an item in the legend to isolate that item on the plot.</p>"),
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
                    </p>"),
                    size = "l",
                    footer = modalButton("Close"),
                    easyClose = TRUE
                ))
            }else{}
            
        })
        
        # set plot font format
        
        t_font <- list(color = "black", size = 25)
        
        output$threeDplot <- renderPlotly({
            
            switch(input$age_breakdown,
                   
                   "1yr" =  plot_ly() %>%
                       
                       add_trace(
                           data = dataF_years,
                           x = ~AGE,
                           y = ~TEST_RT,
                           z = ~INCIDENCE_RT,
                           name = "Female",
                           opacity = 1,
                           type = "scatter3d",
                           mode = "markers",
                           marker = list(size = 9, color = "#408697"),
                           hovertemplate = paste0("Age: ", dataF_years$AGE, "<br>Sex: ", dataF_years$SEX, "<br>Testing rate: ", dataF_years$TEST_RT, " (", dataF_years$TEST_L95, ", ", dataF_years$TEST_U95, ")","<br>Incidence rate: ", dataF_years$INCIDENCE_RT, " (", dataF_years$INCIDENCE_L95, ", ", dataF_years$INCIDENCE_U95, ")", "<extra></extra>")
                       )  %>%
                       
                       add_trace(
                           data = dataM_years,
                           x = ~AGE,
                           y = ~TEST_RT,
                           z = ~INCIDENCE_RT,
                           name = "Male",
                           opacity = 1,
                           type = "scatter3d",
                           mode = "markers",
                           marker = list(size = 9, color = "#DE8033"),
                           hovertemplate = paste0("Age: ", dataM_years$AGE, "<br>Sex: ", dataM_years$SEX, "<br>Testing rate: ", dataM_years$TEST_RT, " (", dataM_years$TEST_L95, ", ", dataM_years$TEST_U95, ")", "<br>Incidence rate: ", dataM_years$INCIDENCE_RT, " (", dataM_years$INCIDENCE_L95, ", ", dataM_years$INCIDENCE_U95, ")", "<extra></extra>")
                       )  %>%
                       
                       add_trace(
                           data = years_3D,
                           x = ~AGE,
                           y = ~TEST_RT,
                           z = ~INCIDENCE_RT,
                           name = "<span style = 'margin-left: -20px'>\nClick HERE to Add/Remove\n<b>Testing Rate</b> Confidence Intervals</span>",
                           opacity = 1,
                           type = "scatter3d",
                           mode = "markers",
                           error_y = list(array = ~upperCI_test, arrayminus = ~lowerCI_test, color = "black", symmetric = FALSE, thickness = 1, width = 7, type = "data"),
                           marker = list(size = 9, color = "transparent"),
                           hovertemplate = paste0("Age: ", years_3D$AGE, "<br>Sex: ", years_3D$SEX, "<br>Testing rate: ", years_3D$TEST_RT, " (", years_3D$TEST_L95, ", ", years_3D$TEST_U95, ")", "<br>Incidence rate: ", years_3D$INCIDENCE_RT, " (", years_3D$INCIDENCE_L95, ", ", years_3D$INCIDENCE_U95, ")", "<extra></extra>")
                       )  %>%
                       
                       add_trace(
                           data = years_3D,
                           x = ~AGE,
                           y = ~TEST_RT,
                           z = ~INCIDENCE_RT,
                           name = "<span style = 'margin-left: -20px'>\nClick HERE to Add/Remove\n<b>Incidence Rate</b> Confidence Intervals</span>",
                           opacity = 1,
                           type = "scatter3d",
                           mode = "markers",
                           error_z = list(array = ~upperCI_inc, arrayminus = ~lowerCI_inc, color = "black", symmetric = FALSE, thickness = 1, width = 7, type = "data"),
                           marker = list(size = 9, color = "transparent"),
                           hovertemplate = paste0("Age: ", years_3D$AGE, "<br>Sex: ", years_3D$SEX, "<br>Testing rate: ", years_3D$TEST_RT, " (", years_3D$TEST_L95, ", ", years_3D$TEST_U95, ")","<br>Incidence rate: ", years_3D$INCIDENCE_RT, " (", years_3D$INCIDENCE_L95, ", ", years_3D$INCIDENCE_U95, ")", "<extra></extra>")
                       )  %>%
                       
                       # add_annotations(text = "<span style = 'font-size: 115%'>\n\n\nData Stratification:</span>", #xref="paper", yref="paper",
                       #                  x = 0.75, xanchor="left",
                       #                  y = 0.5, yanchor="bottom",    # Same y as legend below
                       #                  legendtitle = TRUE, showarrow = FALSE ) %>%
                       
                       config(
                           displayModeBar = TRUE,
                           displaylogo = FALSE
                       ) %>%
                       
                       layout(
                           title = list(
                               text = "\n\nIncidence Rates by Testing Rates\nand Age (year) for Celiac Disease",
                               font = t_font,
                               xanchor = "center",
                               yanchor = "top"
                           ),
                           scene = list( # LH: figure out how to centre axis titles
                               xaxis = list(
                                   title = " <br>Age (years)",
                                   autorange = "reversed",
                                   gridcolor = "black",
                                   nticks = 18,
                                   showspikes = FALSE
                               ),
                               yaxis = list(
                                   title = list(text = " <br>        Testing Rates<br>(per 1,000 person years)", align = "center"),
                                   autorange="reversed",
                                   gridcolor = "black",
                                   showspikes = FALSE
                               ),
                               zaxis = list(
                                   title = "        Incidence Rates<br>(per 100,000 person-years)",
                                   gridcolor = "black",
                                   range = c(0, 110),
                                   showspikes = FALSE
                               ),
                               camera = list(
                                   eye = list( # plot tilt
                                       x = 1.5,
                                       y = 1.5,
                                       z = 0.3
                                   ),
                                   up = list( # direction of axis
                                       x = 1,
                                       y = 0,
                                       z = -1
                                   ),
                                   center = list( # pivot point; can get funky
                                       x = 0,
                                       y = 0,
                                       z = 0
                                   )
                               ),
                               aspectratio = list(
                                   x = 1,
                                   y = 1,
                                   z = 1
                               )
                           ),
                           #showlegend = TRUE,
                           legend=list(
                               title = list(text = "Data Stratification:"),
                               x = 0.85,
                               y = 0.50
                           )
                       ),
                   
                   "5yr" =  plot_ly() %>%
            
                        add_trace(
                            data = dataF_bands,
                            x = ~AGE_BAND,
                            y = ~TEST_RT,
                            z = ~INCIDENCE_RT,
                            name = "Female",
                            opacity = 1,
                            type = "scatter3d",
                            mode = "markers",
                            marker = list(size = 9, color = "#408697"),
                            hovertemplate = paste0("Age: ", dataF_bands$AGE_BAND, "<br>Sex: ", dataF_bands$SEX, "<br>Testing rate: ", dataF_bands$TEST_RT, " (", dataF_bands$TEST_L95, ", ", dataF_bands$TEST_U95, ")","<br>Incidence rate: ", dataF_bands$INCIDENCE_RT, " (", dataF_bands$INCIDENCE_L95, ", ", dataF_bands$INCIDENCE_U95, ")", "<extra></extra>")
                        )  %>%

                    add_trace(
                        data = dataM_bands,
                        x = ~AGE_BAND,
                        y = ~TEST_RT,
                        z = ~INCIDENCE_RT,
                        name = "Male",
                        opacity = 1,
                        type = "scatter3d",
                        mode = "markers",
                        marker = list(size = 9, color = "#DE8033"),
                        hovertemplate = paste0("Age: ", dataM_bands$AGE_BAND, "<br>Sex: ", dataM_bands$SEX, "<br>Testing rate: ", dataM_bands$TEST_RT, " (", dataM_bands$TEST_L95, ", ", dataM_bands$TEST_U95, ")", "<br>Incidence rate: ", dataM_bands$INCIDENCE_RT, " (", dataM_bands$INCIDENCE_L95, ", ", dataM_bands$INCIDENCE_U95, ")", "<extra></extra>")
                    )  %>%

                    add_trace(
                        data = bands_3D,
                        x = ~AGE_BAND,
                        y = ~TEST_RT,
                        z = ~INCIDENCE_RT,
                        name = "<span style = 'margin-left: -20px'>\nClick HERE to Add/Remove\n<b>Testing Rate</b> Confidence Intervals</span>",
                        opacity = 1,
                        type = "scatter3d",
                        mode = "markers",
                        error_y = list(array = ~upperCI_test, arrayminus = ~lowerCI_test, color = "black", symmetric = FALSE, thickness = 1, width = 7, type = "data"),
                        marker = list(size = 9, color = "transparent"),
                        hovertemplate = paste0("Age: ", bands_3D$AGE_BAND, "<br>Sex: ", bands_3D$SEX, "<br>Testing rate: ", bands_3D$TEST_RT, " (", bands_3D$TEST_L95, ", ", bands_3D$TEST_U95, ")", "<br>Incidence rate: ", bands_3D$INCIDENCE_RT, " (", bands_3D$INCIDENCE_L95, ", ", bands_3D$INCIDENCE_U95, ")", "<extra></extra>")
                    )  %>%

                    add_trace(
                        data = bands_3D,
                        x = ~AGE_BAND,
                        y = ~TEST_RT,
                        z = ~INCIDENCE_RT,
                        name = "<span style = 'margin-left: -20px'>\nClick HERE to Add/Remove\n<b>Incidence Rate</b> Confidence Intervals</span>",
                        opacity = 1,
                        type = "scatter3d",
                        mode = "markers",
                        error_z = list(array = ~upperCI_inc, arrayminus = ~lowerCI_inc, color = "black", symmetric = FALSE, thickness = 1, width = 7, type = "data"),
                        marker = list(size = 9, color = "transparent"),
                        hovertemplate = paste0("Age: ", bands_3D$AGE_BAND, "<br>Sex: ", bands_3D$SEX, "<br>Testing rate: ", bands_3D$TEST_RT, " (", bands_3D$TEST_L95, ", ", bands_3D$TEST_U95, ")","<br>Incidence rate: ", bands_3D$INCIDENCE_RT, " (", bands_3D$INCIDENCE_L95, ", ", bands_3D$INCIDENCE_U95, ")", "<extra></extra>")
                    )  %>%

            # add_annotations(text = "<span style = 'font-size: 115%'>\n\n\nData Stratification:</span>", #xref="paper", yref="paper",
            #                  x = 0.75, xanchor="left",
            #                  y = 0.5, yanchor="bottom",    # Same y as legend below
            #                  legendtitle = TRUE, showarrow = FALSE ) %>%

                    config(
                        displayModeBar = TRUE,
                        displaylogo = FALSE
                    ) %>%

                    layout(
                        title = list(
                            text = "\n\nIncidence Rates by Testing Rates\nand Age (5 year age band) for Celiac Disease",
                            font = t_font,
                            xanchor = "center",
                            yanchor = "top"
                        ),
                        scene = list( # LH: figure out how to centre axis titles
                            xaxis = list(
                            title = " <br>Age (5 year age band)",
                            autorange = "reversed",
                            gridcolor = "black",
                            nticks = 18,
                            showspikes = FALSE
                        ),
                        yaxis = list(
                            title = list(text = " <br>        Testing Rates<br>(per 1,000 person years)", align = "center"),
                            autorange="reversed",
                            gridcolor = "black",
                            showspikes = FALSE
                        ),
                        zaxis = list(
                        title = "        Incidence Rates<br>(per 100,000 person-years)",
                        gridcolor = "black",
                        range = c(0, 110),
                        showspikes = FALSE
                        ),
                        camera = list(
                            eye = list( # plot tilt
                                x = 1.5,
                                y = 1.5,
                                z = 0.3
                            ),
                            up = list( # direction of axis
                                x = 1,
                                y = 0,
                                z = -1
                            ),
                            center = list( # pivot point; can get funky
                                x = 0,
                                y = 0,
                                z = 0
                            )
                        ),
                        aspectratio = list(
                            x = 1,
                            y = 1,
                            z = 1
                        )
                    ),
                    #showlegend = TRUE,
                    legend=list(
                        title = list(text = "Data Stratification:"),
                        x = 0.85,
                        y = 0.50
                    )
                )
        
            ) # switch
            
        }) # renderPlotly
        
    }) # server
    
}

