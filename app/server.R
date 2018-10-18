library(raster)
source('/home/bijan/Projects/droughteye/funcs.R')


shinyServer(function(input, output, session) {
  
  monthid <- reactive({
    which(input$month ==month.name)
  })
  
  delta_anomaly_path <- reactive({
    
    y <- as.numeric(input$year)
    m <- monthid()
    
    path <- sprintf(fmt = '%sANOMALY/DELTAT.ANOMALY.%04d.%02d.01.tif', deltat_repo, y, m)
    
    if(file.exists(path)) return(path)
    
    return(NULL)
    
  })
  
  delta_path <- reactive({
    
    y <- as.numeric(input$year)
    
    m <- monthid()
    
    path <- sprintf(fmt = '%sDELTA/DELTAT.%04d.%02d.01.tif', deltat_repo, y, m)
    
    if(file.exists(path)) return(path)
    
    return(NULL)
  })
  
  delta_normal_path <- reactive({
    
    y <- as.numeric(input$year)
    
    m <- monthid()
    
    path <- sprintf(fmt = '%sNORMAL/DELTAT.NORMAL.%02d.01.tif', deltat_repo, m)
    
    if(file.exists(path)) return(path)
    
    return(NULL)
  })
  
  lst_path <- reactive({
    
    y <- as.numeric(input$year)
    
    m <- monthid()
    
    path <- sprintf(fmt = '%sGEOTIFF/LST.Day.%04d.%02d.01.tif', 
                    modis_repo, y, m)
    
    if(file.exists(path)) return(path)
    
    return(NULL)
  })
  
  
  prism_path <- reactive({
    
    y <- as.numeric(input$year)
    
    m <- monthid()
    
    prism_stable_path <- sprintf(fmt = '%sPRISM_tmean_stable_4kmM2_%04d%02d_bil/PRISM_tmean_stable_4kmM2_%04d%02d_bil.bil', 
                                 prism_repo, y, m, y, m)
    
    prism_provisional_path <- sprintf(fmt = '%sPRISM_tmean_provisional_4kmM2_%04d%02d_bil/PRISM_tmean_provisional_4kmM2_%04d%02d_bil.bil', 
                                      prism_repo, y, m, y, m)
    
    if(file.exists(prism_stable_path)) return(prism_stable_path)
    
    if(file.exists(prism_provisional_path)) return(prism_provisional_path)
    
    return(NULL)
  })
  
  map_path <- reactive({
    path <- switch(input$mapType,
                   'Normal' = delta_normal_path(),
                   'Temporal' = delta_path(),
                   'Anomaly' = delta_anomaly_path()
    )
  })
  
  
  output$map <- renderPlot(
    height = function(){floor(session$clientData$output_map_width/1.75)}, {
      
      path <- map_path()
      if(is.null(path)) return()
      
      map <- raster(path)
      
      colList <- switch(input$colorpal,
                        'Default' = colList.Contad,
                        'Purple-Orange' = colList.purpleOrange,
                        'Green-Brown' = colList.greenBrown,
                        'Green-Red' = colList.greenRed)
      
      col <- colorRampPalette(colList)(100)
      
      r <- setRange(map)
      
      par(mar=c(6,6,4,1), bty='n', xpd = TRUE)
      par(bg = 'blue')
      
      plot(r, col = col, legend = F, xaxt='n', yaxt = 'n')
      # map('usa', add = T)
      plot(physio(), add=T, lwd = 2)
      axis(1, line = 1, cex.axis = 2)
      axis(2, line = 1, cex.axis = 2)
      
      mtext(plot_title(), font=2, line = 1, cex = 3)
      mtext('Longitude (°)', font = 2, line = 4, cex = 2, side =1)
      mtext('Latitude (°)', font = 2, line = 4, cex = 2, side =2)
      
      scalebar(d = 1000, xy = c(-122, 26),type = 'bar', below = 'kilometers', divs = 4)
      northArrow(xb = -75, yb = 25, len=1.5, lab="N", tcol = 'black', font.lab = 2, col='black')  
      insertLegend(quantile(r, probs=c(.01,.99)), col)
      
      # Arrows(-65.5, 38, -65.5, 44.5, xpd=T, lwd=2)
      # Arrows(-65.5, 33, -65.5, 26.5, xpd=T, lwd=2)
      # mtext('Low', side = 2, line = -26.5, at = 41.5, font=2)
      # mtext('High', side = 2, line = -26.5, at = 30, font=2)
      
    })
  
  plot_title <- reactive({
    switch(input$mapType,
           'Normal' = paste('Normal thermal stress in', input$month, 'across the USA'),
           'Temporal' =  paste('Thermal stress in', input$month, input$year, 'across the USA'),
           'Anomaly' =  paste('Thermal stress anomaly in', input$month, input$year, 'across the USA'))
  })
  
  physio <- reactive(
    raster::shapefile('/home/bijan/Projects/droughteye/data/physio/physio.shp')
    )
  
  
  output$physio_plot <- renderPlot(
    height = function(){floor(session$clientData$output_map_width/1.75)}, {
      provs <- physio()
      
      n <- length(provs$PROVINCE)
      labs <- tools::toTitleCase(tolower(provs$PROVINCE))
      colList <- c('NA',rainbow(n-1))
      
      
      par(mar=c(4,0,2,0), oma=c(0,0,0,0))
      plot(provs, col=colList)
      
      legend(-110, 26.0,legend = labs[2:7] , xpd=T,xjust = 1,
             fill = colList[2:7], bty='n', cex=1.5)
      legend(-97, 26.0,legend = labs[8:13] , xpd=T,xjust = 1,
             fill = colList[8:13], bty='n', cex=1.5)
      legend(-80, 26.0,legend = labs[14:19] , xpd=T,xjust = 1,
             fill = colList[14:19], bty='n', cex=1.5)
      legend(-65, 26.0,legend = labs[20:25] , xpd=T,xjust = 1,
             fill = colList[20:25], bty='n', cex=1.5)
      
      mtext('United States Physiographic Regions', cex=2, font=2, line = 0)
      scalebar(d = 1000, xy = c(-122, 27),type = 'bar', below = 'kilometers', divs = 4)
      northArrow(xb = -72, yb = 31, len=1.5, lab="N", tcol = 'black', font.lab = 2, col='black')  
      
      
      
    }
  )
  output$downloadmap <- downloadHandler(
    filename = function() {
      basename(map_path())
    },
    content = function(file) {
      path <- map_path()
      if(is.null(path)) return()
      file.copy(path, to = file)
    }
  )
})
