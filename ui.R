dashboardPage(
  
  # --------------------------- HEADER
  dashboardHeader(
    title = "WORLD POPULATION",
    titleWidth = 250
  ),
  
  
  # --------------------------- SIDEBAR 
  dashboardSidebar(
    width = 250,
    sidebarMenu(
    menuItem("Overview", 
             icon = icon("fa-solid fa-house"), 
             tabName = "Overview"),
    menuItem("Density Rate Map", 
             icon = icon("fa-solid fa-people-group"), 
             tabName = "DensityMap"),
    menuItem("Highlights", 
             icon = icon("fa-solid fa-book"), 
             tabName = "summary")
    )
 ),
  
  # --------------------------- BODY
  dashboardBody(
    shinyDashboardThemes(theme = "purple_gradient"),
    #--------------------- Create Tab Items for Page
   tabItems(
      
      # ------- P1
      tabItem(tabName = "Overview",
              # --- (Body) PAGE 1: Row - 1
              fluidRow(column(width = 4,
                valueBox(width = NULL,
                        color = "blue",
                        subtitle = "Increased population From 1970 to 2022",
                        icon = icon("fa-solid fa-users-rays"),
                        value = comma(sum(population$`2022`) - sum(population$`1970`))
                        ),
                valueBox(width = NULL,
                        color = "orange",
                        subtitle = "Increased Population since 1970",
                        icon = icon("fa-solid fa-arrow-trend-up"),
                        value = print(paste(selisih, "%"))
                        ),
                valueBox(width = NULL,
                        color = "green",
                        subtitle = "2022 Total Population ",
                        icon = icon("fa-solid fa-earth-asia"),
                        value = comma(sum(population$`2022`))
                        )
                    ),
                box(width = 8,
                    solidHeader = T,
                    collapsible = T,
                    title = "Population Composition since 1970",
                    status = "info",
                    plotlyOutput(outputId = "plot2P1",
                                 height = 350)),
              # --- (Body) PAGE 1:Row - 2
              fluidRow(
                box(width = 4,
                    height = 380,
                    title = "WORLD POPULATION FROM 1970",
                    solidHeader = T,
                    collapsible = T,
                    status = "info",
                    plotlyOutput(outputId = "plot1P1",
                                 height = 300)),
                # -------------------Tab Box Session
                tabBox(
                  width = 8,
                  height = 400,
                  title = "Informations",
                  id = "tabP1",
                  
                  # ----------------Tab 1
                  tabPanel("2022 World Growth Rate",
                           plotlyOutput(outputId = "Tab1",
                                        height = 350)),
                  # ----------------Tab 2
                  tabPanel("Continent 2022 Growth Rate",
                           fluidRow(
                             column(width = 4,
                              box(
                                title = "World Growth Rate",
                                background = "black",
                                width = 10,
                                solidHeader = T,
                                "Average: 1.01 % in 2022", 
                                br(),
                               selectInput(
                                 inputId = "continentList",
                                 label = "Choose Continent",
                                 choices = sort(unique(population$Continent)),
                                 selected = "Asia"))
                             ),
                             column(width = 7,
                                    fluidRow(plotlyOutput(outputId = "Tab2",
                                                          height = 350))))),
                  #----------------Tab 3
                           
                  tabPanel("Continent Population",
                           fluidRow(
                             box(width = 12,
                               plotlyOutput(outputId = "Tab3",
                                              height = 300)))),
                  #----------------Tab 3
                  tabPanel("Most Dense Country",
                           fluidRow(
                             column(width = 4,
                                    box(
                                      selectInput(
                                        inputId = "yearlist",
                                        label = "Choose Year",
                                        choices = sort(yearList),
                                        selected = "2022"))
                             ),
                             column(width = 7,
                                    fluidRow(plotlyOutput(outputId = "Tab4",
                                                          height = 350)))))
                  
                        )
                     )
                  )
              
      ),
      # ------------ Page 2
      tabItem(tabName = "DensityMap",
              fluidRow(
                box(width = 12,
                    height = 500,
                    title = "DENSITY RATE OVER THE YEARS",
                    solidHeader = T,
                    status = "info",
                    plotlyOutput(outputId = "mapP3")),
                box(width = 12,
                    sliderInput(
                      width = 2022,
                      inputId = "sliderMap",
                      label = "Year",
                      min = 1970, 
                      max = 2022,
                      step = 10,
                      animate = T,
                      value = 1970)))
              ),
      # ------------ Page 3
      tabItem(tabName = "summary",
              # ----------------------------------------Row 1
              fluidRow(
                box(
                  width = 12,
                  status = "success",
                  title = "Highlight Points",
                  solidHeader = T,
                  collapsible = T,
                  collapsed = T,
                  infoBox(
                    width = 3,
                    title = "Most Populated",
                    value = "ASIA",
                    subtitle ="from 1970 - 2022",
                    color = "red",
                    icon = icon("fa-solid fa-earth-asia")),
                  infoBox(
                    width = 3,
                    title = "Highest Average Growth Rate",
                    value = "AFRICA",
                    subtitle ="in 2022",
                    color = "red",
                    icon = icon("fa-solid fa-arrow-trend-up")),
                  infoBox(
                    width = 3,
                    title = "Highest Growth Rate",
                    value = "20.26 %",
                    subtitle ="from year 1970 to 1980",
                    color = "red",
                    icon = icon("fa-solid fa-arrow-trend-up")),
                  infoBox(
                    width = 3,
                    title = "2022 Most Dense Country",
                    value = "MACAU (ASIA)",
                    subtitle ="with 23.172 pople per sq. km",
                    color = "red",
                    icon = icon("fa-solid fa-users-viewfinder"))
                )
              ),
              # ----------------------------------------Row 2
              fluidRow(
                box(
                  width = 12,
                  status = "warning",
                  title = "Additional Points",
                  solidHeader = T,
                  collapsible = T,
                  collapsed = T,
                  infoBox(
                    width = 3,
                    title = "Decreased Growth Rate",
                    value = "1990",
                    subtitle ="starting from 1990 GR is decreasing ",
                    color = "black",
                    icon = icon("fa-solid fa-arrow-trend-down")),
                  infoBox(
                    width = 3,
                    title = "Lowest Growth Rate",
                    value = "UKRAINE",
                    subtitle ="0.91% in 2022",
                    color = "black",
                    icon = icon("fa-solid fa-arrows-down-to-people")),
                  infoBox(
                    width = 3,
                    title = "Least Populated Continent",
                    value = "OCEANIA",
                    subtitle ="from 1970 - 2022",
                    color = "black",
                    icon = icon("fa-solid fa-arrow-trend-up")),
                  infoBox(
                    width = 3,
                    title = "Least Density Country",
                    value = "GREENLAND",
                    subtitle ="with 0.03 people per sq. km",
                    color = "black",
                    icon = icon("fa-solid fa-people-arrows"))
                )
            )
         )
      )
   )
)
