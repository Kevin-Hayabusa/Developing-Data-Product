library(shiny)
library(ggplot2)
library(quantmod)
library(lubridate)


fluidPage(
        
        titlePanel("Historial VaR"),
        
        sidebarPanel(
                textInput(inputId="symbol",label = "Yahoo Ticker",value = "SPY"),
                
                sliderInput('period', 'Return Period', min=1, max=10,
                            value=5, step=1, round=0),
                sliderInput(inputId = "bins",
                            label = "Number of bins:",
                            min = 1,
                            max = 50,
                            value = 30),
                sliderInput(inputId = "percentile",
                            label = "Percentile:",
                            min = 0,
                            max = 1,
                            value = 0.5),
                dateRangeInput('dateRange',
                               label = 'Date range input: yyyy-mm-dd',
                               start = Sys.Date() - years(10), end = Sys.Date()
                )
                
        ),
        
        mainPanel(
                tabsetPanel(
                        tabPanel('Plot',
                                 plotOutput('hist'),
                                 plotOutput('qq')),
                        tabPanel('Chart',
                                 plotOutput('timeSeries')),
                        tabPanel('Summary',
                                 verbatimTextOutput('sum')),
                        tabPanel('Data',
                                 DT::dataTableOutput("data"))
                )
        )

        
)