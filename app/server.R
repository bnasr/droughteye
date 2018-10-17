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
  output$map <- renderPlot(height = 800, {
    
    path <- map_path()
    if(is.null(path)) return()
    # physio <- shapefile('/home/bijan/Projects/droughteye/data/physioProvinceLatLon/physioProvinceLatLon.shp')
    
    map <- raster(path)
    
    col <- colorRampPalette(colList.Contad)(100)
    
    r <- setRange(map)

    par(mar=c(1,1,1,1), oma=c(2,2,2,1), bty='n')
    par(bg = 'blue')
    
    plot(r, col = col, legend = F, xaxt='n', yaxt='n')
    # map('usa', add = T)
    # plot(physio, add=T)
    
    scalebar(d = 1000, xy = c(-122, 25),type = 'bar', below = 'kilometers', divs = 4)
    northArrow(xb = -75, yb = 25, len=1.5, lab="N", tcol = 'black', font.lab = 2, col='black')  
    insertLegend(quantile(r, probs=c(.01,.99)), col)
    
    # Arrows(-65.5, 38, -65.5, 44.5, xpd=T, lwd=2)
    # Arrows(-65.5, 33, -65.5, 26.5, xpd=T, lwd=2)
    # mtext('Low', side = 2, line = -26.5, at = 41.5, font=2)
    # mtext('High', side = 2, line = -26.5, at = 30, font=2)
    
    mtext('Longitude (°C)', side = 1, line = 2)
    mtext('Latitude (°C)', side = 2, line = 2)
    
    
  })
  
})