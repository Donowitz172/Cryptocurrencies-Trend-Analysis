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


list_of_pairs1 <- c("Bitcoin" = "BITCOIN",
                    "Bitcoin Cash" = "BITCOIN CASH",
                    "Ethereum" = "ETHEREUM",
                    "Ethereum Classique" = "ETHEREUM CLASSIC",
                    "LiteCoin" = "LITECOIN",
                    "ZCash" = "ZCASH",
                    "Ripple" = "RIPPLE",
                    "Monero" = "MONERO",
                    "Stellar" = "STELLAR",
                    "Dash" = "DASH",
                    "Nxt" = "NXT",
                    "Augur" = "AUGUR")

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
      selectInput(inputId = "CryptoPair", label = "Choose the market: ",
            selected = "USDT_BCH",
            multiple = FALSE,
            choices = list_of_pairs[,2]
      ),
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
    prices <- xts(dataset$weightedAverage, dataset$date)
    prices %>% dygraph(main = "Price in US Dollars") %>% 
      dyRangeSelector()

  }
  
  description_function <- function(CryptoName) {
    url2 <- glue("https://coinpedia.org/currency/{CryptoName}") %>%
      read_html()
    text <- html_nodes(url2,'.elementor-text-editor p') %>% html_text()
  }


  output$dessin <- renderDygraph({
    market(currencyPair = input$CryptoPair)
  })
  output$description <- renderText({
   description_function(CryptoName = input$CryptoName)
  })
}

#Run the app
shinyApp(ui = ui, server = server)