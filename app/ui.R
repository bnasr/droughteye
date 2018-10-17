fluidPage(
  br(),
  theme = shinytheme('darkly'),
  title =  titlePanel(title = 'Drought Eye: Monitoring thermal stress in near real time', windowTitle = 'windowTitle'), 
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
                             selected = year(Sys.Date()))
    ),
    
    mainPanel = mainPanel(

      br(),
      radioButtons('month', 
                  label = NULL, 
                  inline = TRUE,
                  choices = month.name,
                  selected = month.name[max(1, month(Sys.Date())-1)]
                  ),
      
      plotOutput('map')
      
    )
  )
)