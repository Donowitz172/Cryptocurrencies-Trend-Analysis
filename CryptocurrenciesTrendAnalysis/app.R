#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#library(shiny)

## Define UI for application that draws a histogram
#ui <- fluidPage(
   
   # Application title
#   titlePanel("Old Faithful Geyser Data"),
   
#    # Sidebar with a slider input for number of bins 
#    sidebarLayout(
#       sidebarPanel(
#          sliderInput("bins",
#                      "Number of bins:",
#                      min = 1,
#                      max = 50,
#                      value = 30)
#       ),
#       
#       # Show a plot of the generated distribution
#       mainPanel(
#          plotOutput("distPlot")
#       )
#    )
# )
# 
# # Define server logic required to draw a histogram
# server <- function(input, output) {
#    
#    output$distPlot <- renderPlot({
#       # generate bins based on input$bins from ui.R
#       x    <- faithful[, 2] 
#       bins <- seq(min(x), max(x), length.out = input$bins + 1)
#       
#       # draw the histogram with the specified number of bins
#       hist(x, breaks = bins, col = 'darkgray', border = 'white')
#    })
# }
# 
# # Run the application 
# shinyApp(ui = ui, server = server)

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

# library(shiny)
# library(dplyr)
# library(dygraphs)
# library(prenoms)
# library(tidyr)
# data(prenoms)
# 
# 
# ui <- fluidPage(
#   titlePanel("Please Create this application : "),
#   sidebarLayout(
#     sidebarPanel(
#       textInput("nom","nom (separated by ;)",value = "Vincent;Diane")
#     ),
#     mainPanel(
#       dygraphOutput("dessin")
#     )
#   )
# )
# 
# #Define server logic required to draw a histogram
# 
# server <- function(input, output) {
#   draw_names_dygraph <- function(names) {
#     prenoms %>%
#       group_by(year,name) %>%
#       summarise(total = sum(n)) %>%
#       filter(name %in% names) %>%
#       spread(key = name,value = total) %>%
#       dygraph()
#   }
#   
#   vecteur_de_nom <- reactive({
#     strsplit(input$nom,";") %>% unlist()
#   })  
#   
#   output$dessin <- renderDygraph({
#     draw_names_dygraph(vecteur_de_nom())
#   })
#   
# }
# 
# #Run the app
# shinyApp(ui = ui, server = server)


















# # This is the user-interface definition of a Shiny web application.
# # You can find out more about building applications with Shiny here:
# #
# # http://shiny.rstudio.com
# #
# 
# library(shiny)
# library(dygraphs)
# library(prenoms)
# library(tidyr)
# library(dplyr)
# data(prenoms)
# 
# 
# ui <- fluidPage(
#   titlePanel("Please Create this application : "),
#   sidebarLayout(
#     sidebarPanel(
#       selectInput(inputId = "nom", label = "Choose: ",
#                   selected = c("Diane","Vincent","Romain","Colin"),
#                   multiple = TRUE,
#                   choices = unique(prenoms$name)
#       )
#     ),
#     mainPanel(
#       dygraphOutput("dessin")
#     )
#   )
# )
# 
# #Define server logic required to draw a histogram
# 
# server <- function(input, output) {
#   draw_names_dygraph <- function(names) {
#     prenoms %>%
#       group_by(year,name) %>%
#       summarise(total = sum(n)) %>%
#       filter(name %in% names) %>%
#       spread(key = name,value = total) %>%
#       dygraph("dessin")
#   }
# 
#   vecteur_de_nom <- reactive({
#     strsplit(input$nom,";") %>% unlist()
#   })
# 
#   output$dessin <- renderDygraph({
#     draw_names_dygraph(vecteur_de_nom())
#   })
# 
# }
# 
# #Run the app
# shinyApp(ui = ui, server = server)
# # 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
library(shiny)

library(jsonlite)
library(glue)
library(httr)

library(lubridate)
library(xts)

library(dplyr)
library(tidyr)
library(dygraphs)
library(stringr)

list_of_pairs <- c("USDT_BTC",
                   "USDT_BCH",
                   "USDT_ETH",
                   "USDT_ETC",
                   "USDT_LTC",
                   "USDT_ZEC",
                   "USDT_XRP",
                   "USDT_XMR",
                   "USDT_STR",
                   "USDT_DASH",
                   "USDT_NXT",
                   "USDT_REP")


ui <- fluidPage(
  titlePanel("Cryptocurrencies historical prices : "),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "CryptoPair", label = "Choose: ",
            selected = "USDT_BTC",
            multiple = FALSE,
            choices = list_of_pairs
      )
    ),
    
#       textInput("CryptoPair","(US Dollars - Cryptocurrencies Markets)",value = "USDT_BTC")
#     ),

    mainPanel(
      dygraphOutput("dessin")
    )
  )
)

#Define server logic required to draw a histogram

server <- function(input, output) {

  market <- function(currencyPair) {
    url <- glue("https://poloniex.com/public?command=returnChartData&currencyPair={currencyPair}&start=1435699200&end=9999999999&period=14400")
    res <- GET(url)
    dataset <- fromJSON(url)
    dataset$date <- as_datetime(dataset$date)
    prices <- xts(dataset$open,dataset$date)

    #volumes <- xts(dataset$volume,dataset$date)

    prices %>% dygraph()

  }
  
#   # draw_names_dygraph <- function(names) {
#   #   prenoms %>%
#   #     group_by(year,name) %>%
#   #     summarise(total = sum(n)) %>%
#   #     filter(name %in% names) %>%
#   #     spread(key = name,value = total) %>%
#   #     dygraph()
#   # }
#   
  # vecteur_de_nom <- reactive({
  #   strsplit(list_of_pairs,";") %>% unlist()
  # })

  output$dessin <- renderDygraph({
    market(currencyPair = "CryptoPair")
  })

}

#Run the app
shinyApp(ui = ui, server = server)