# Celiac app (CAVE version)
# Contributor: Lindsay Hracs, Julia Gorospe
# Date: 2024-02-20
# Updated: 2026-10-01

# Update notes: 2026-10-01 changed basemaps from "CartoDB.Positron" to 
# "Esri.WorldGrayCanvas"
# Note: App not redeployed at time of update

# link: https://kaplan-gi.shinyapps.io/CAVE/
# posit link: https://kaplan-global-epi-cave.share.connect.posit.cloud/

source("global.R", local = TRUE)$value
source("incidence.R", local = TRUE)$value
source("testing.R", local = TRUE)$value
source("various_vis.R", local = TRUE)$value
source("time_series.R", local = TRUE)$value

ui <- page_fillable(
  
    title = "Celiac disease Analytical Visualization Environment",

    useShinyjs(),

    theme = bs_theme(bootswatch = "united",
                     primary = "#408697",
                     base_font = "Ubuntu"),
    
    # format Shiny error messages
    tags$head(tags$style(HTML(".shiny-output-error-validation {text-align: center; color: #687B9C; font-weight: bold; font-size: 125%;}"))),

    # format link style
    tags$head(tags$style(HTML("a {color: #408697}"))),

    # format action button
    tags$head(tags$style(HTML(".btn {color:rgb(255,255,255); border-color: #408697; background-color: #408697;}"))),

    # format logo placement
    tags$head(tags$style(HTML(".logo {margin-left: 10px; margin-right: 10px; margin-bottom: 20px; vertical-align: middle;}"))),

    # format slider bar (for eachslider bar, withincreasing increments on js)
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

    # format Leaflet popup font
    tags$head(tags$style(HTML(".leaflet-pane {font-family: Ubuntu;}
                               .leaflet .info {font-family: Ubuntu;}"))),

    # Format sidebar text wrapping for pretty widgets
    tags$style(
        ".pretty {
      white-space: normal;
      margin-bottom: 4px;
    }
    .pretty .state label {
      line-height: 1.25em;
      margin-top: -2px;
    }
    .pretty .state label::after, .pretty .state label::before {
      top: -2px;
    }"
    ),

    # change sidebar collapse arrow to make more visible
    assignInNamespace(
        "collapse_icon",
        function() {
            bsicons::bs_icon(
                "chevron-double-left", class = "collapse-icon", size = NULL
            )
        },
        ns = "bslib"
    ),

    # format sidebar for mobile
    tags$head(tags$style(HTML('
        .bslib-gap-spacing .sidebar {background: rgba(212, 218, 220, 0.7)}
        .bslib-sidebar-layout .collapse-toggle .collapse-icon {fill: #000000 !important;}
        .bslib-sidebar-layout .collapse-toggle .collapse-icon {fill: #000000 !important;}
        .resizable-panel {
            position: relative;
            resize: both;
            overflow: auto;
            min-width: 300px;
            min-height: 300px;
            max-width: 600px;
            max-height: 600px;
        }'
    ))),

    # format header
    tags$header(tags$style(HTML("
        .box {
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            padding: 0 4px;
            border: 2px solid #408697;
            background-color: #363538;
        }

        .wordart {
            font-family: Ubuntu, sans-serif;
            font-size: 2em;
            font-weight: bold;
            display: inline-block;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        .wordart.italic-outline {
            transform: scale(1, 1.3);
            -webkit-transform: scale(1, 1.3);
            -moz-transform: scale(1, 1.3);
            -o-transform: scale(1, 1.3);
            -ms-transform: scale(1, 1.3);
        }

        .wordart.italic-outline .text {
            letter-spacing: -0.01em;
            color: #fff !important;
            -webkit-text-stroke: 0.01em #000;
            text-shadow: 0.03em 0.03em 0 #408697;
        }"
    ))),

    # Custom card styling
    tags$style(
      HTML(
        ".study-card {
          border: 1px solid #ccc;
          border-radius: 10px;
          padding: 20px;
          margin: 20px;
          color: #363538;
          font-face: bold;
          text-align: center;
          cursor: pointer;
          transition: transform 0.2s ease-in-out;
          box-shadow: 2px 2px 6px rgba(0,0,0,0.1);
          background-color: #F6F6F6 ;
        }
        .study-card:hover {
          color: #363538;
          transform: scale(1.03);
          background-color: #F8F8F8;
        }
        .study-card i {
          font-size: 50px;
          margin-bottom: 10px;
          color: #408697;
          transition: color 0.3s ease;
        }
        .study-card:hover i {
          color: #52D6F4;
        }"
      )
    ),
    
    # Format Action button
    tags$head(
      tags$style(
        HTML(
          ".btn {
          color:rgb(255,255,255); 
          border-color: #408697; 
          background-color: #408697;
        }"
        )
      )
    ),
    
    
############### Start of Navigation ####
    navset_hidden(
        id = "main_ui",
      
        nav_panel("landing",
            
            # Header
            div(
              style = "color: #F6F6F6; background-color: #363538; text-align: center; margin: -40px -20px 0px -20px; padding: 40px 20px 30px 20px;",
              HTML(
                "<div class = 'wordart italic-outline'>
                      <span class='box'><span class='text'>C</span></span><span class='text'>eliac disease </span>
                      <span class='box'><span class='text'>A</span></span><span class='text'>nalytical </span>
                      <span class='box'><span class='text'>V</span></span><span class='text'>isualization </span>
                      <span class='box'><span class='text'>E</span></span><span class='text'>nvironment </span>
                </div>")
            ),
            
            # Navigation buttons
            layout_columns(
              col_widths = c(-2,8,-2), # c(-2, 4, 4, -2) for 2 buttons
                actionButton("go_study1",
                  tags$i(class = "fa-solid fa-magnifying-glass-chart"),
                  #label = h4("Incidence and Testing"),
                  label = tagList(
                      h4("Incidence and Testing"),
                      p("Click here to view Alberta data", style = "font-size: 15px; font-weight: normal; margin-top: -4px; margin-bottom: 0; color: #408697")
                  ),
                  class = "study-card",
                  style = "width:90%;"
                ),
                # actionButton("go_study2",
                #   tags$i(class = "fa-solid fa-viruses"),
                #   label = h4("Infections and Antibiotics"),
                #   class = "study-card",
                #   style = "width:90%;"
                # )
            ),
            
            HTML("<p style = 'margin: 20px 40px; font-size: 115%;'><br>
                       <b>Welcome to CAVE!</b><br> This is a collection of research exploring the epidemiology of Celiac Disease made possible through collaboration with the University of Calgary and Alberta Health Services. Please select a study above to interact with the data. Click on the paper links throughout the website to read associated articles.</p>")
        ),
        
        # Incidence/Testing page
        nav_panel(
            "study1",
            
            # Header
            div(
                style = "color: #F6F6F6; background-color: #363538; display: flex; align-items: center; margin: -35px -20px 20px -20px; padding: 20px;",
                actionButton("back1", "Back", icon = icon("house"), width = "120px"),
                HTML("<span style='font-size: 200%; font-face: bold; margin-left: 20px'>Celiac Disease Incidence and Testing Rates</span>")
            ),
            
            # Tabs
            navset_tab(
                nav_panel(tags$header(style = "text-align:center; font-weight: bold; font-size:125% ;", "Incidence"), incidenceUI("incidence")),
                nav_panel(tags$header(style = "text-align:center; font-weight: bold; font-size:125% ;", "Testing Rates"), testingUI("testing")),
                nav_panel(tags$header(style = "text-align:center; font-weight: bold; font-size:125% ;", "Age Groups"), various_visUI("various_vis")),
                nav_panel(tags$header(style = "text-align:center; font-weight: bold; font-size:125% ;", "Time Series"), time_seriesUI("time_series")),
                nav_spacer(),
                
                nav_panel(tags$header(style = "text-align:center; padding-right:10px; padding-left:10px; font-size: 125%; font-weight:bold;",
                                      shiny::icon("circle-info")),
                          HTML("<p style = 'margin: 20px 40px; font-size: 115%;'>
                       <b>Collaboration and Support</b><br>
                      Research and infrastructure associated with this web application was done in partnership with Alberta Health Services, the Alberta SPOR unit, and the University of Calgary.<br></p>"),
                          
                          div(style = "display: flex; align-items: center; justify-content: center; gap: 15px; margin: 20px 40px;",
                              tags$a(
                                href = "https://www.albertahealthservices.ca/research/research.aspx",
                                target = "_blank",
                                img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AHS.png",
                                    style = "height: 50px; width: auto; object-fit: contain;")
                              ),
                              tags$a(
                                href = "https://absporu.ca/",
                                target = "_blank",
                                img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AB_SPOR.jpg",
                                    style = "height: 90px; width: auto; object-fit: contain;")
                              ),
                              tags$a(
                                href = "https://cumming.ucalgary.ca/centres/centre-health-informatics",
                                target = "_blank",
                                img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/UC-Cumming-Centre%20for%20Health%20Informatics.jpg",
                                    style = "height: 70px; width: auto; object-fit: contain;")
                              )
                          ),
                          
                          HTML("<p style = 'margin: 20px 40px; font-size: 115%;'><br>
                       <b>Application Development</b><br>
                       This web application was developed by the Kaplan Global Epidemiology Lab at the University of Calgary. It was constructed using the <i>Shiny</i> framework with dependancies on the R-compatible <i>leaflet</i>, <i>plotly</i>, and <i>ggplot2</i> modules.<br><br>

                      <b>Using and Citing this Work</b><br>
                      Please cite the following if using any of the figures or information found on this site:

                      <ul style= 'font-size: 100%; margin-left: 30px'>
                          <li>King J, Bakal J, Li B, et. al. Variation in Testing for and Incidence of Celiac Autoimmunity in Canada: A Population-Based Study. Gastroenterology, 2023; 164, 567-578.e7</li>
                      </ul><br>

                    </p>")
                )
            )
        ),
        
      #   # Another Study
      #   nav_panel(
      #       "study2",
      # 
      #       # Header
      #       div(
      #         style = "color: #F6F6F6; background-color: #363538; display: flex; align-items: center; margin: -35px -20px 10px -20px; padding: 20px;",
      #         actionButton("back2", "Back", icon = icon("house"), width = "120px"),
      #         HTML("<span style='font-size: 200%; font-face: bold; margin-left: 20px'>Infections and Antibiotic Exposure in Celiac Disease</span>")
      #       ),
      #       
      #       # Tabs
      #       navset_tab(
      #           nav_panel(tags$header(style = "text-align:center; font-weight: bold; font-size:125% ;", "Tab 1"), "Some great plots"),
      #           nav_panel(tags$header(style = "text-align:center; font-weight: bold; font-size:125% ;", "Tab 2"), "Even more great plots!!"),
      #           nav_spacer(),
      #           
      #           nav_panel(tags$header(style = "text-align:center; padding-right:10px; padding-left:10px; font-size: 125%; font-weight:bold;",
      #                                 shiny::icon("circle-info")),
      #                     HTML("<p style = 'margin: 20px 40px; font-size: 115%;'>
      #                  <b>Collaboration and Support</b><br>
      #                 Research and infrastructure associated with this web application was done in partnership with Alberta Health Services, the Alberta SPOR unit, and the University of Calgary.<br></p>"),
      #                     
      #                     div(style = "display: flex; align-items: center; justify-content: center; gap: 15px; margin: 20px 40px;",
      #                         tags$a(
      #                           href = "https://www.albertahealthservices.ca/research/research.aspx",
      #                           target = "_blank",
      #                           img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AHS.png",
      #                               style = "height: 50px; width: auto; object-fit: contain;")
      #                         ),
      #                         tags$a(
      #                           href = "https://absporu.ca/",
      #                           target = "_blank",
      #                           img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/AB_SPOR.jpg",
      #                               style = "height: 90px; width: auto; object-fit: contain;")
      #                         ),
      #                         tags$a(
      #                           href = "https://cumming.ucalgary.ca/centres/centre-health-informatics",
      #                           target = "_blank",
      #                           img(src="https://raw.githubusercontent.com/kaplan-gi/Images/main/UC-Cumming-Centre%20for%20Health%20Informatics.jpg",
      #                               style = "height: 70px; width: auto; object-fit: contain;")
      #                         )
      #                     ),
      #                     
      #                     HTML("<p style = 'margin: 20px 40px; font-size: 115%;'><br>
      #                  <b>Application Development</b><br>
      #                  This web application was developed by the Kaplan Global Epidemiology Lab at the University of Calgary. It was constructed using the <i>Shiny</i> framework with dependancies on the R-compatible <i>leaflet</i>, <i>plotly</i>, and <i>ggplot2</i> modules.<br><br>
      # 
      #                 <b>Using and Citing this Work</b><br>
      #                 manuscript in progress><br>
      # 
      #               </p>")
      #           )
      #       )
      # )
  )
)

server <- function(input, output, session) {
  
      # tab servers
      incidenceServer("incidence")
      testingServer("testing")
      various_visServer("various_vis")
      time_seriesServer("time_series")
      
      # Observer to read query string on app launch to ensure app starts on correct study based on URL
      observe({
          query <- parseQueryString(session$clientData$url_search)
          start_page <- query$study %||% "landing"
          nav_select("main_ui", start_page, session = session)
      })
  
      # go to study 1
      observeEvent(input$go_study1, {
          nav_select("main_ui", selected = "study1", session = session)
          updateQueryString("?study=study1", mode = "replace")
      })
      
      # go to study 2
      observeEvent(input$go_study2, {
          nav_select("main_ui", selected = "study2", session = session)
          updateQueryString("?study=study2", mode = "replace")
      })
      
      # back to landing from study 1
      observeEvent(input$back1, {
          nav_select("main_ui", selected = "landing", session = session)
          updateQueryString("?study=landing", mode = "replace")
      })
      
      # back to landing from study 2
      observeEvent(input$back2, {
          nav_select("main_ui", selected = "landing", session = session)
          updateQueryString("?study=landing", mode = "replace")
      })
}

shinyApp(ui, server)

