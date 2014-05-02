library(shiny)
library(ggplot2)

source("isH0.R")

shinyServer(function(input,output) {
  d <- reactive({
    y = rep(NA, input$n)
    for (i in 1:input$n) {
      y[i] = isH0(input$pvalue, 
                  input$pH0, 
                  input$dist, 
                  input$mean, 
                  input$sd, 
                  input$max_sims)
    }
    o = data.frame(y=y, n=1:length(y), cy=cumsum(y))
    o$p = with(o,cy/n)
    o$lcl = with(o, qbeta(.025, 0.5+cy, 0.5+n-cy))
    o$ucl = with(o, qbeta(.975, 0.5+cy, 0.5+n-cy))
    o
  })
  
  output$plot <- renderPlot({
    o = d()
    g = 
    ggplot(o)+
      geom_point(aes(x=n,y=y))+
      geom_line(aes(x=n,y=p), linetype=2)+
      geom_line(aes(x=n,y=lcl))+
      geom_line(aes(x=n,y=ucl))+
      labs(x="Simulation number", y="Simulation outcome (1=null hypothesis)", 
           title="Proportion of simulations from the null hypothesis")+
      scale_linetype_manual(values=1:2, labels=c("p","cl"))
    print(g)
  })
  
  output$text <- renderText({
    o = d()
    n = nrow(o)
    paste("Out of the ",n, " simulations that resulted in a pvalue of ", input$pvalue, 
          ", ", o$cy[n], " (",100*o$p[n], "%) of them were from the null hypothesis. ",
          "The estimated probability of the null hypothesis being true, based on your assumptions ",
          "on the left including an observed pvalue of ",
          input$pvalue, ", is ", round(o$p[n],2), " with a 95% Monte Carlo uncertainty interval of (", round(o$lcl[n],2),", ", 
          round(o$ucl[n],2),").", sep='')
  })
})
