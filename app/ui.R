dashboardPage(header = dashboardHeader(title = 'Drought Eye: Monitoring thermal stress in near real time', titleWidth = '400px'), 
              
              sidebar = dashboardSidebar(width = '400px',
                                         # shinyjs::useShinyjs(),
                                         
                                         radioButtons(inputId = "mapType",
                                                     label = 'Map Type', 
                                                     choices = list(
                                                       'Normal', 
                                                       'Temporal', 
                                                       'Anomaly'
                                                     ), 
                                                     selected = 'Anomaly'
                                         ),
                                         
                                         selectInput('year', 
                                                     label = 'Year', 
                                                     choices = 2001:year(Sys.Date()), 
                                                     selected = year(Sys.Date())),
                                         
                                         selectInput('month', 
                                                     label = 'Month', 
                                                     choices = 1:12, 
                                                     selected = max(1, month(Sys.Date())-1))
              ), 
              
              body = dashboardBody(
                plotOutput('map')
              )
)