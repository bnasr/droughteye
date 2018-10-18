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
                 
                 selectInput('colorpal', 
                             label = 'Color Palette',
                             choices = c('Default', 'Purple-Orange', 'Green-Brown', 'Green-Red')),
                 
                 hr(),
                 
                 radioButtons('layout', 
                             label = 'Borders layout',
                             choices = c('USA Border', 
                                         'State Borders',
                                         'Physiographic Regions'), 
                             selected = 'Physiographic Regions'),
                 
                 hr(),
                 
                 downloadButton("downloadmap", "Download raster")
    ),
    
    mainPanel = mainPanel(width = 10,
                          tabsetPanel(
                            
                            tabPanel('Thermal Stress Map',
                                     
                                     br(),
                                     radioButtons('month', 
                                                  label = NULL, 
                                                  inline = TRUE,
                                                  choices = month.name,
                                                  selected = month.name[max(1, month(Sys.Date())-1)]
                                     ),
                                     
                                     plotOutput('map', width = '100%')
                            ),
                            
                            tabPanel('Physiographic Map', 
                                     br(),
                                     br(),
                                     br(),
                                     plotOutput('physio_plot', width = '100%')
                            ),
                            tabPanel('About',{
                              includeHTML('about.html')
                            })
                          )
                          
    )
  )
)
