fluidPage(
  br(),
  h1('Drought Eye: Monitoring Thermal Stress in Near Real-time'),
  hr(),
  theme = shinytheme('darkly'),
  title =  titlePanel(title = 'Drought Eye: Monitoring Thermal Stress in Near Real-time', windowTitle = 'windowTitle'), 
  sidebarLayout(
    
    sidebarPanel(width = 2,
                 radioButtons(inputId = "mapType",
                              label = 'Map Type', 
                              choices = list(
                                'Normal', 
                                'Temporal', 
                                'Anomaly'
                              ), 
                              selected = 'Anomaly'
                 ),
                 
                 hr(),
                 
                 selectInput('year', 
                             label = 'Year', 
                             choices = 2001:year(Sys.Date()), 
                             selected = 2019
                             # selected = year(Sys.Date())
                             ),
                 selectInput('month', 
                              label = NULL, 
                              # inline = TRUE,
                              choices = month.name,
                              selected = "January"
                              #selected = month.name[max(1, month(Sys.Date())-1)]
                 ),
                 hr(),
                 
                 radioButtons('colorpal', 
                              label = 'Color Palette',
                              choices = c('Default', 
                                          'Purple-Orange',
                                          'Green-Brown', 
                                          'Green-Red')),
                 
                 hr(),
                 
                 radioButtons('layout', 
                              label = 'Borders layout',
                              choices = c('USA Border', 
                                          'State Borders',
                                          'Physiographic Regions'), 
                              selected = 'Physiographic Regions'),
                 
                 hr(),
                 strong('Mouse-over Location:'),
                 br(),
                 br(),
                 uiOutput("hovervalues")
                 
                 # hr(),
                 # downloadButton("downloadmap", "Download Raster")
                 
                 
    ),
    
    mainPanel = mainPanel(width = 10,
                          tabsetPanel(
                            
                            tabPanel('Thermal Stress Map',
                                     br(),

                                     
                                     h4('Higher thermal stress anomalies may likely correspond to more water-stressed conditions.'),

                                     br(),
                                     br(),
                                     plotOutput('map_plot', 
                                                width = '100%', 
                                                click = 'map_click', 
                                                dblclick = 'map_dblclick', 
                                                hover = 'map_hover')
                            ),
                            
                            tabPanel('Temporal Variation', 
                                     
                                     br(),
                                     br(),
                                     # downloadButton("downloadtemporal", "Download Data"),
                                     # hr(),
                                     
                                     checkboxGroupInput('temp_month', 
                                                        label = NULL,
                                                        choices = month.name,
                                                        selected = month.name, 
                                                        inline = TRUE),
                                     # radioButtons('temp_var', 
                                     #              label = NULL, 
                                     #              inline = TRUE,
                                     #              choices = c('mean', 'sd', '2.5%', '25%', '50%', '75%', '97.5%'), 
                                     #              selected = 'mean'
                                     # ),
                                     hr(),
                                     strong('Select ecoregions by clicking and double-clicking on the legend.'),
                                     br(),
                                     br(),
                                     
                                     plotlyOutput('temporal_plot', 
                                                  height = '500px',
                                                  width = '100%')
                            ),
                            
                            tabPanel('Zonal Statistics', 
                                     br(),
                                     br(),
                                     br(),
                                     # downloadButton("downloadzonal", "Download Data"),
                                     # hr(),
                                     plotOutput('zonal_plot', 
                                                width = '100%')
                            ),
                            
                            tabPanel('Physiographic Map', 
                                     br(),
                                     br(),
                                     br(),
                                     plotOutput('physio_plot', 
                                                width = '100%',
                                                hover = 'physio_hover')
                            ),
                            
                            tabPanel('Percent Tree Cover Map', 
                                     br(),
                                     br(),
                                     br(),
                                     plotOutput('tree_percent_plot', 
                                                width = '100%',
                                                hover = 'tree_percent_hover')
                            ),
                            
                            tabPanel('About and Citation',{
                              includeHTML('about.html')
                            })
                          )
                          
    )
  )
)
