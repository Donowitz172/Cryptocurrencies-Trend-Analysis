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
library(rvest)

library(lubridate)
library(xts)

library(dplyr)
library(tidyr)
library(dygraphs)
library(stringr)


list_of_pairs1 <- c("BITCOIN",
                    "BITCOIN CASH",
                    "ETHEREUM",
                    "ETHEREUM CLASSIC",
                    "LITECOIN",
                    "ZCASH",
                    "RIPPLE",
                    "MONERO",
                    "STELLAR",
                    "DASH",
                    "NXT",
                    "AUGUR")

list_of_pairs2 <- c("USDT_BTC",## BITCOIN
                    "USDT_BCH",## BITCOIN CASH
                    "USDT_ETH",## ETHEREUM
                    "USDT_ETC",## ETHEREUM CLASSIC
                    "USDT_LTC",## LITECOIN
                    "USDT_ZEC",## ZCASH
                    "USDT_XRP",## RIPPLE
                    "USDT_XMR",## MONERO
                    "USDT_STR",## STELLAR
                    "USDT_DASH",## DASH
                    "USDT_NXT",## NXT
                    "USDT_REP")## AUGUR

list_of_pairs3 <- c("bitcoin/",## BITCOIN
                    "bitcoin-cash/",## BITCOIN CASH
                    "ethereum/",## ETHEREUM
                    "ethereum-classic/",## ETHEREUM CLASSIC
                    "litecoin",## LITECOIN
                    "zcash",## ZCASH
                    "ripple",## RIPPLE
                    "monero/",## MONERO
                    "stellar/",## STELLAR
                    "dash/",## DASH
                    "nxt/",## NXT
                    "augur/")## AUGUR

list_of_pairs <- cbind(list_of_pairs1,list_of_pairs2,list_of_pairs3)

ui <- fluidPage(
  titlePanel("Cryptocurrencies historical prices : "),
  sidebarLayout(
    sidebarPanel(
#      selectInput(inputId = "CryptoPair", label = "Choose the market: ",
      selectInput(inputId = "CryptoPair", label = "Choose the market: ",
            selected = "USDT_BCH",
            multiple = FALSE,
            choices = list_of_pairs[,2]
      ),
#       textInput("CryptoPair","(US Dollars - Cryptocurrencies Markets)",value = "USDT_BTC")
#     ),

      selectInput(inputId = "CryptoName", label = "And the corresponding description: ",
                        selected = "bitcoin-cash/",
                        multiple = FALSE,
                        choices = list_of_pairs[,3]
      )
    ),
    mainPanel(
      dygraphOutput("dessin"),
      textOutput("description")
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
    prices <- xts(dataset$open, dataset$date)
    prices %>% dygraph()
    #volumes <- xts(dataset$volume,dataset$date)
  }
  
  description_function <- function(CryptoName) {
    url2 <- glue("https://coinpedia.org/currency/{CryptoName}") %>%
      read_html()
    text <- html_nodes(url2,'.elementor-text-editor p') %>% html_text()
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
    market(currencyPair = input$CryptoPair)
  })
  output$description <- renderText({
    # "HELLO"
   description_function(CryptoName = input$CryptoName)
  })
}

#Run the app
shinyApp(ui = ui, server = server)