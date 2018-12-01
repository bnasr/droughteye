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
                             selected = year(Sys.Date())),
                 
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
                 uiOutput("hovervalues"),
                 
                 hr(),
                 downloadButton("downloadmap", "Download Raster")
    ),
    
    mainPanel = mainPanel(width = 10,
                          {

                            tabsetPanel(
                              radioButtons('month', 
                                           label = NULL, 
                                           inline = TRUE,
                                           choices = month.name,
                                           selected = month.name[max(1, month(Sys.Date())-1)]
                              ),                              
                              tabPanel('Thermal Stress Map',
                                       
                                       br(),
                                       
                                       plotOutput('map_plot', 
                                                  width = '100%', 
                                                  click = 'map_click', 
                                                  dblclick = 'map_dblclick', 
                                                  hover = 'map_hover')
                              ),
                              
                              tabPanel('Zonal Statistics', 
                                       br(),
                                       # actionButton('update_zonal', 
                                       #              label = HTML('<strong style="color:#ff0000;">Zonal stats are not up-to-date. Click here to update</strong>'),
                                       #              icon = icon('redo'), width = '100%'),
                                       hr(),
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
                              
                              tabPanel('Percent Tree Cover', 
                                       br(),
                                       br(),
                                       br(),
                                       plotOutput('tree_percent_plot', 
                                                  width = '100%',
                                                  hover = 'tree_percent_hover')
                              ),
                              
                              tabPanel('About',{
                                includeHTML('about.html')
                              })
                            )
                          }
                          
    )
  )
)
