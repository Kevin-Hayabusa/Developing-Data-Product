library(shiny)
library(ggplot2)
library(DT)



function(input, output) {
        

        tickerTS <- reactive({getSymbols(input$symbol,from=input$dateRange[1],to = input$dateRange[2],auto.assign = FALSE)
        })
        
        hisReturn <- reactive({
                na.trim(tickerTS()/lag.xts(tickerTS(),input$period)-1)
        })
        output$timeSeries <- renderPlot({    
                chartSeries(tickerTS(), theme = chartTheme("white"),
                            type = "line", TA = NULL,name = input$symbol)
        })
        
        output$hist <- renderPlot({
                
                myReturn <- coredata(hisReturn())[,6]
                MyMean <- mean(myReturn)
                MyMedian <- median(myReturn)
                MySd <- sd(myReturn)
                MyPercentile <- quantile(myReturn,input$percentile)
                bins <- seq(min(myReturn), max(myReturn), length.out = input$bins + 1)
                hist(myReturn,xlab = "Return%", col='lightblue',breaks = bins,main='Historical Return',probability = TRUE,xaxt='n')
                axis(1, at=pretty(myReturn), lab=pretty(myReturn) * 100, las=TRUE)
                lines(density(myReturn))
                abline(v = MyPercentile,
                       col = "red",
                       lwd = 3)
                legend("topleft", legend = c(paste("Mean =", round(MyMean*100, 2),"%"),
                                             paste("Median =",round(MyMedian*100, 2),"%"),
                                             paste("Std.Dev =", round(MySd*100, 2),"%"),
                                             paste("Percentile = ",round(MyPercentile*100, 2),"%")),
                       bty = "n")
        })
        output$qq <- renderPlot({
                myReturn <- coredata(hisReturn())[,6]
                qqnorm(myReturn)
                qqline(myReturn)
        })
        output$sum  <- renderPrint({
                summary(hisReturn())[,-1]
        })
        output$data  <- DT::renderDataTable({
                DT::datatable(as.data.frame(tickerTS()),rownames = TRUE)
        })
        
}