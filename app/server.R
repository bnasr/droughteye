source('/home/bijan/Projects/droughteye/funcs.R')
library(raster)

shinyServer(function(input, output, session) {
  
  rv <- reactiveValues()
  
  
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
  
  
  output$map_plot <- renderPlot(
    height = function(){floor(session$clientData$output_map_plot_width/1.75)}, {
      
      path <- map_path()
      if(is.null(path)) {
        par(mar=c(0,0,0,0))
        plot(NA, xlim=c(0,1), ylim=c(0,1), xaxs='i',yaxs='i', xaxt='n', yaxt='n', bty='o', xlab='',ylab='')
        text(mean(par()$usr[1:2]), mean(par()$usr[3:4]), 'MODIS data for the selected month have not become available yet!', font=2, adj=.5, cex=2)
        return()
      }
      
      map_raster <- raster(path)
      
      colList <- switch(input$colorpal,
                        'Default' = colList.Contad,
                        'Purple-Orange' = colList.purpleOrange,
                        'Green-Brown' = colList.greenBrown,
                        'Green-Red' = colList.greenRed)
      
      col <- colorRampPalette(colList)(100)
      
      if(input$mapType=='Anomaly')
        r <- setRange(map_raster, rng = c(-3,3))
      else
        r <- setRange(map_raster)
      
      par(mar=c(6,6,4,1), bty='n', xpd = TRUE)
      par(bg = 'blue')
      
      plot(r, col = col, legend = F, xaxt='n', yaxt = 'n')
      
      switch(input$layout, 
             'USA Border' = map('usa', add = T, lwd = 2), 
             'State Borders' = map('state', add = T, lwd = 2),
             'Physiographic Regions' = plot(physio(), add = T, lwd = 2))
      
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
    raster::shapefile(paste0(data_repo, 'physio/physio.shp'))
  )
  
  
  output$physio_plot <- renderPlot(
    height = function(){floor(session$clientData$output_physio_plot_width/1.7)}, {
      provs <- physio()
      
      n <- length(provs$PROVINCE)
      labs <- tools::toTitleCase(tolower(provs$PROVINCE))
      colList <- c('NA',rainbow(n-1))
      
      
      par(mar=c(4,2,0,0))
      plot(provs, col=colList)
      
      legend(-110, 26.0,legend = labs[2:7] , xpd=T,xjust = 1,
             fill = colList[2:7], bty='n', cex=1.5)
      legend(-97, 26.0,legend = labs[8:13] , xpd=T,xjust = 1,
             fill = colList[8:13], bty='n', cex=1.5)
      legend(-80, 26.0,legend = labs[14:19] , xpd=T,xjust = 1,
             fill = colList[14:19], bty='n', cex=1.5)
      legend(-65, 26.0,legend = labs[20:25] , xpd=T,xjust = 1,
             fill = colList[20:25], bty='n', cex=1.5)
      
      mtext('Physiographic Regions of the United States', cex=2, font=2, line = -2)
      scalebar(d = 1000, xy = c(-122, 27),type = 'bar', below = 'kilometers', divs = 4)
      northArrow(xb = -72, yb = 31, len=1.5, lab="N", tcol = 'black', font.lab = 2, col='black')  
      
      
      
    }
  ) 
  
  output$tree_percent_plot <- renderPlot(
    height = function(){floor(session$clientData$output_tree_percent_plot_width/1.7)}, {
      tpc <- raster(paste0(data_repo, 'tree_percent_cover.tif'))
      
      # col <- colorRampPalette(colList.brownGreen[-(1:2)])(100)
      col <- rev(terrain.colors(100))
      par(mar=c(6,6,4,1), bty='n', xpd = TRUE)
      plot(tpc, col = col, legend = F, xaxt='n', yaxt = 'n')
      
      switch(input$layout, 
             'USA Border' = map('usa', add = T, lwd = 2), 
             'State Borders' = map('state', add = T, lwd = 2),
             'Physiographic Regions' = plot(physio(), add = T, lwd = 2))
      
      axis(1, line = 1, cex.axis = 2)
      axis(2, line = 1, cex.axis = 2)
      
      mtext('Percent Tree Cover from NLCD', font=2, line = 1, cex = 3)
      mtext('Longitude (°)', font = 2, line = 4, cex = 2, side =1)
      mtext('Latitude (°)', font = 2, line = 4, cex = 2, side =2)
      
      scalebar(d = 1000, xy = c(-122, 26),type = 'bar', below = 'kilometers', divs = 4)
      northArrow(xb = -75, yb = 25, len=1.5, lab="N", tcol = 'black', font.lab = 2, col='black')  
      insertLegend(c(0, 100), col, legtext = '%')
      
    }
  ) 
  
  
  output$hovervalues <- renderUI({
    hover1 <- input$map_hover
    hover2 <- input$physio_hover
    hover3 <- input$tree_percent_hover
    
    if(is.null(hover1)&is.null(hover2)&is.null(hover3)) return(HTML('<p>Longitude: NULL<br/>Latitude: NULL<br/>Region: NULL</p>'))
    
    if(!is.null(hover1)) hover <- hover1
    if(!is.null(hover2)) hover <- hover2
    if(!is.null(hover3)) hover <- hover3
    
    phys <- physio()
    
    poly_no <- whichPolygon(matrix(c(hover$x, hover$y), nrow =1), shape = phys)
    province <- phys$PROVINCE[poly_no]
    province <- tools::toTitleCase(tolower(province))
    HTML(sprintf('<p> Longitude: %.3f<br/>Latitude: %.3f<br/>Region: %s</p>', hover$x, hover$y, province))
  })
  
  summ_all_path <- reactive({
    summ_all_path <- sprintf(fmt = '%sSUMM.ALL.rds', summ_repo)
    if(!file.exists(summ_all_path))return(NULL)
    summ_all_path
  })
  
  output$temporal_plot <- renderPlotly({

    tmp <- summ_all_path()
    if(is.null(tmp))return()
    
    summ_all <- readRDS(tmp)
    # summ_all[,date:=as.Date(sprintf(fmt = '%04d-%02d-01', year, month))]
    
    fontList <- list(
      family = "Courier New, monospace",
      size = 16,
      color = "#7f7f7f"
    )
    xAxis <- list(
      title = "Time",
      titlefont = fontList
    )
    yAxis <- list(
      title = input$mapType,
      titlefont = fontList
    )
    
    data <- summ_all[Ecoregion!='NA'&variable==input$temp_var&type==tolower(input$mapType)]
    
    if(input$mapType=='Normal') {
      data <- data[year==2001]
      data[,date:=month]
    }
    
    ttl <- switch (input$mapType,
                    'Temporal' = 'Variablity of Thermal Stress for Different Ecoregions',
                    'Normal' = 'Variablity of Normal Thermal Stress for Different Ecoregions',
                    'Anomaly' = 'Variablity of Thermal Stress Anomaly for Different Ecoregions'
    )
    
    
    p <- plot_ly(data = data,
                 x=~date, 
                 y= ~value,
                 visible = "legendonly",
                 color = ~Ecoregion, 
                 type = 'scatter',
                 mode = 'lines+markers') %>%
      layout(xaxis = xAxis, yaxis = yAxis, title = ttl)
    
    return(p)
  })
  
  zonal_table <- reactive({
    
    summ_path <- sprintf(fmt = '%sSUMM.%s.%04d.%02d.01.rds', 
                         summ_repo, 
                         toupper(input$mapType),
                         as.integer(input$year), 
                         monthid())
    
    if(!file.exists(summ_path)) return(NULL)
    
    tmp <- readRDS(summ_path)
    tmp
  })
  
  output$zonal_plot <- renderPlot(
    height = function(){floor(session$clientData$output_zonal_plot_width/2)}, {

      zonal_stats <- zonal_table()
      if(is.null(zonal_stats)){
          par(mar=c(0,0,0,0))
          plot(NA, xlim=c(0,1), ylim=c(0,1), xaxs='i',yaxs='i', xaxt='n', yaxt='n', bty='o', xlab='',ylab='')
          text(mean(par()$usr[1:2]), mean(par()$usr[3:4]), 'MODIS data for the selected month have not become available yet!', font=2, adj=.5, cex=2)
          return()
        }
      
      
      zonal_stats['NA'] <- NULL
      
      labs <- names(zonal_stats)
      quants <- sapply(zonal_stats, quantile, na.rm = TRUE, probs = c(0.025, 0.25, 0.5, 0.75, 0.975))
      ord <- order(quants[3,])
      n <- length(zonal_stats)
      colList <- rainbow(n)
      
      bp <- boxplot(zonal_stats[ord], bty = 'n', outline = FALSE, col= colList[ord], axes = F)
      axis(2, cex.axis = 1.5, line = -1)
      mtext(rv$zonal_ttl, font=2, line = 1, cex = 3)
      mtext('°C', font=2, line = 2, cex = 2, side = 2)
      text((1:n)-0.15, bp$stats[4,], labs[ord], srt = 90, adj = -0.05, cex = 1.2, font = 2)
      abline(h = 0, lty = 2, lwd = 4, col ='#80808080')
      mtext(plot_title(), font=2, line = 1, cex = 3)
      })
  
  
  # observe({
  #   req(input$year)
  #   req(input$month)
  #   req(input$mapType)
  #   rv$update_zonal_now <- FALSE
  #   rv$zonal_up_to_date <- FALSE
  # })
  # 
  # observeEvent(input$update_zonal,{
  #     rv$update_zonal_now <- TRUE
  # })
  # 
  # observe(
  #   {
  #     if(!rv$zonal_up_to_date) 
  #       updateActionButton(session, 'update_zonal', 
  #                          label = HTML('<strong style="color:#ff0000;">Zonal stats are not up-to-date. Click here to update</strong>'))
  #     else
  #       updateActionButton(session, 'update_zonal', 
  #                          label = HTML('<strong style="color:#00ff00;">Zonal stats are up-to-date!</strong>'))
  #     
  #   }
  # )
  # observeEvent(input$map_click)
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
  
  output$downloadtemporal <- downloadHandler(
    filename = function() {
      return(sprintf(fmt = 'summary_thermal_stress_anomaly_by_%s.csv', Sys.Date()))
    },
    content = function(file) {
      path <- summ_all_path()
      if(is.null(path)) return()
      zonal <- readRDS(path)
      write.table(zonal, file = file, row.names = FALSE)
    }
  )
})
