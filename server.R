shinyServer(function(input, output) {
  
  #-----Plotting: Plot1P1 
  output$plot1P1 <- renderPlotly({
    # ----------- SUBSET
    totalPopulation <- population[4:11] %>% 
      summarise_all(.funs = sum)
    
    totalPopulation <- melt(totalPopulation, 
                            variable.name = "Year", 
                            value.name = "Total")
    
    totalPopulation <- totalPopulation %>% 
      arrange(-desc(Total)) 
    
    worldGrowth <- totalPopulation %>% summarise(Growth = round((diff(Total)/Total[-8])*100, 2))
    worldGrowth[2:8, 1] <-worldGrowth
    worldGrowth[1,1] <- 0
    
    totalPopulation <- cbind(totalPopulation, worldGrowth)
    
    totalPopulation <- totalPopulation %>% 
      mutate(
        fromYear = c("1970", "1970", "1980", "1990", "2000", "2010", "2015", "2020"),
        toYear = c("1970", "1980", "1990", "2000", "2010", "2015", "2020", "2022"),
        label = glue(
          "Total: {comma(Total)}
    Growth: {Growth}
    From: {fromYear} to {toYear}"))
    
    # -----------PLOTTING GGPLOT & GGPLOTLY
    wpopulationPlot <- ggplot(totalPopulation, aes(x = reorder(Year, Total), y= Total)) +
      geom_col(aes(fill = Total), show.legend = F) +
      geom_line(group = 1, col = "#FFE74C", size = 1) +
      geom_point(aes(text = label),size = 3, alpha = 1) +
      scale_fill_continuous(low = "#95b8d1", high = "#FF495C" ) +
      labs(
           x = NULL,
           y = NULL) +
      scale_y_continuous(labels = unit_format(unit = "B", scale = 1e-9)) +
      theme_gdocs() +
      theme(plot.background = element_rect(fill = NA),
            axis.text = element_text(size = 11, face = "bold", color = "white"))
    
    
    ggplotly(wpopulationPlot, tooltip = "text")
  })
  
  # --------- Plotting: Plot2P1
  output$plot2P1 <- renderPlotly({
    totalContinentPop <- population[3:11] %>% 
      group_by(Continent) %>% 
      summarise_all(.funs = sum)
    
    totalContinentPop <- pivot_longer(data = totalContinentPop,
                                      cols = -(Continent),
                                      names_to = 'Year',
                                      values_to = "Total")
    totalContinentPop <- totalContinentPop %>% 
      mutate(label = glue(
        "Total: {comma(Total)}"),
        Year = as.factor(Year))
    
    compPerYear <- aggregate(Total ~ Year + Continent,
                             data = totalContinentPop,
                             FUN = "sum")
    compPerYear <- compPerYear %>%
      group_by(Year) %>% 
      mutate(prop = round((Total/sum(Total))*100,2),
             label = glue(
               "Continent: {Continent}
           Total Population: {comma(Total)}
           {prop}% of World Population"))
    
    propPopPlot <- ggplot(compPerYear, aes(x = Total, y= Year)) +
      geom_col(aes(fill= Continent, text = label), position = "fill", show.legend = F) +
      labs(
        y = NULL,
        x = "Proportions") +
      scale_fill_brewer(palette = "Dark2") +
      theme(plot.title = element_text(face = "bold", size =20, hjust = 0),
            plot.background = element_rect(fill = NA),
            panel.background = element_rect(fill = NA),
            panel.grid.major.x = element_blank(),
            axis.text.x = element_blank(),
            axis.title.x = element_text(size = 16, face = "italic",family = "serif", color = "black"),
            axis.text.y = element_text(size = 14, face = "bold",family = "serif", color = "white"),
            legend.background = element_rect(fill = NA),
            legend.text = element_text(color = "white")
            ) 
    ggplotly(propPopPlot, tooltip = "text")
    
  })
  
  # ----------------TAB BOX PAGE 1: TAB 1
  output$Tab1 <- renderPlotly({
    ggplot(population, aes(x = Continent, y = growthRate)) +
      geom_boxplot(fill = "black", outlier.colour = "red") +
      facet_wrap(~Continent, scales = "free") +
      labs(
        y = NULL,
        x = NULL) +
      geom_hline(aes(yintercept = mean(growthRate)), color = "red") +
      theme_linedraw() +
      theme(
        panel.grid = element_line(color = "grey"),
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = NA),
        axis.title.x = element_text(face = "bold", family = "serif"),
        axis.text.x = element_blank())
  })
  # ---------------------TAB BOX PAGE 1: TAB 2
  output$Tab2 <- renderPlotly({
    
    wGrowthRate <- population %>% 
      filter(Continent == input$continentList) %>% 
      mutate(label1 = glue(
        "Country: {Country}
     GR: {round(growthRate,2)}")) %>% 
      select(Country, growthRate, Continent, label1)
    
    cntGRplot <- ggplot(wGrowthRate, aes(x = Continent, y = growthRate)) +
      geom_boxplot(outlier.shape = NA, fill = "black") +
      geom_jitter(aes(col = growthRate, size =growthRate,  alpha = 0.3, text = label1), show.legend = F) +
      facet_wrap(~Continent, scales = "free") +
      geom_hline(yintercept = mean(population$growthRate), color = "red") +
      labs(
        y = NULL,
        x = "Growth Rate"
      ) +
      theme_linedraw() +
      theme(
        panel.grid = element_line(color = "grey"),
        plot.background = element_rect(fill = NA),
        strip.text = element_text(size = 14, face= "bold"),
        axis.title.x = element_text(face = "bold", family = "serif"),
        axis.text.x = element_blank(),
        axis.ticks.y = element_blank()
      )
    
    ggplotly(cntGRplot, tooltip = "text")

  })
  # ---------------------TAB BOX PAGE 1: TAB 3
  output$Tab3 <- renderPlotly({
    
    totalContinentPop <- population[3:11] %>% 
      group_by(Continent) %>% 
      summarise_all(.funs = sum)
    
    totalContinentPop <- pivot_longer(data = totalContinentPop,
                                      cols = -(Continent),
                                      names_to = 'Year',
                                      values_to = "Total")
    totalContinentPop <- totalContinentPop %>% 
      mutate(label = glue(
        "Total: {comma(Total)}"),
        Year = as.factor(Year))
    
    compPerYear <- aggregate(Total ~ Year + Continent,
                             data = totalContinentPop,
                             FUN = "sum")
    compPerYear <- compPerYear %>%
      group_by(Year) %>% 
      mutate(prop = round((Total/sum(Total))*100,2),
             label = glue(
               "Continent: {Continent}
           Total Population: {comma(Total)}
           {prop}% of World Population"))
    
    totalPlot <- ggplot(totalContinentPop, aes(x = Year, y = Total)) +
      geom_line(aes(group = Continent, col = Continent)) +
      geom_point(aes(col = Continent, 
                     alpha = 0.5,
                     text = label), show.legend = F) +
      labs(
        title = "Total Population",
        subtitle = "Between Period: 1970 - 2022",
        x = NULL,
        y = NULL) +
      scale_y_continuous(labels = comma) +
      scale_colour_brewer(palette = "Dark2") +
      theme_gdocs()+
      theme(plot.title = element_text(face = "bold", size =25, hjust = 0, color = "black"),
            plot.subtitle = element_text(hjust = 0),
            panel.grid = element_line(colour = "grey"),
            axis.line.y.left = element_line(colour = "black"),
            legend.title = element_text(size = 14,face = "bold", colour = "black"))
    
    ggplotly(totalPlot, tooltip = "text")
    
  })
  # ---------------------TAB BOX PAGE 1: TAB 4
  output$Tab4 <- renderPlotly({
    
    topDense <- worldDensity %>% 
      filter(Year == input$yearlist) %>% 
      arrange(desc(Density)) %>% 
      mutate(label = glue({
        "Continent: {Continent}
     Density: {comma(round(Density))}"
      })) %>% 
      head(7)
    
    topDense
    
    # Plotting High Desnity Rate Country
    topDensePlot <- ggplot(topDense, aes(x = Density, y = reorder(Country, Density))) +
      geom_segment(aes(y = reorder(Country, Density), yend = reorder(Country, Density),
                       x = 0, xend = Density, 
                       col = Density), size = 1.5, show.legend = F) +
      geom_point(size = 3, shape = "square", aes(text = label)) +
      scale_x_continuous(labels = comma) +
      scale_color_gradient(low ="#ffcd41", high= "#19a84c")+
      labs(
        x = NULL,
        y = NULL,
      ) +
      theme_gdocs() +
      theme(
        axis.text = element_text(face = "bold", size = 14, color = "white"),
        panel.grid.major.x = element_blank(),
        panel.background = element_rect(fill= NA),
        plot.background = element_rect(fill = NA))
    
    ggplotly(topDensePlot, tooltip = "text")
    
  })
  
  
  #-------------- PAGE2
  output$mapP3 <- renderPlotly({
    worldDensity <- densityFunc(population)
    worldDensity <-  pivot_longer(data = worldDensity,
                                  cols = -c(Country, CCA3, Continent),
                                  names_to = "Year",
                                  values_to = "Density")
    
    densityperYear <- worldDensity %>% 
      filter(Year == input$sliderMap)
    
    plot_ly(densityperYear, type = "choropleth",
                            locations = densityperYear$CCA3, 
                            z= ~densityperYear$Density, 
                            zmin = 0,
                            zmax = 700,
                            color = ~densityperYear$Density,
                            colorscale = "zmax",
                            width = 1400,
                            height = 450,
                            text = densityperYear$Country) %>% 
      layout(paper_bgcolor = "transparent", 
             plot_bgcolor = "transparent") %>% 
      colorbar(title = "Density Meter")

    
  })
  
  
  
  
  
})
