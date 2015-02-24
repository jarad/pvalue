library(shiny)
library(ggplot2)
library(plyr)

source("isH0.R")

shinyServer(function(input,output) {
  
  simulated_data = reactive({
    y = rep(NA, input$n)
    for (i in 1:input$n) y[i] = isH0(input)
    
    data.frame(n=1:length(y), y=y)
  })
  
  ####################################
  # 'Basic' tab
  ####################################
  basic_data = reactive({
    o = summarize(simulated_data(), 
                  n_total = length(y), 
                  n_H0    = sum(y))
    
    data.frame(Truth = factor(       c("Null hypothesis","Alternative hypothesis"), 
                              levels=c("Null hypothesis","Alternative hypothesis")),
               Number     = with(o, c(n_H0, n_total-n_H0)),
               Percentage = with(o, c(n_H0, n_total-n_H0)/n_total))
  })
  
  output$basic_plot <- renderPlot({
    ggplot(basic_data(), aes(x=Truth, y=Percentage, label=Number)) + 
      geom_bar(stat="identity") + 
      geom_text(vjust=-.5) + 
      ylim(c(0,1))
  })
  
  output$basic_text <- renderText({
    o = basic_data()
    
    n = sum(o$Number)
    y = o$Number[o$Truth == "Null hypothesis"]
    p = y/n
    
    paste("Out of the ", n, " simulations that resulted in a pvalue of ", input$pvalue, 
          ", ", y, " (", 100*p, "%) of them were from the null hypothesis. ",
          "The estimated probability of the null hypothesis being true is ", round(p,2), ".", sep='')
  })
  
  ####################################
  # 'with Monte Carlo error' tab
  ####################################
  cumulative_data = reactive({
    o = simulated_data()
    
    mutate(o, 
           cy = cumsum(y),
           p  = cy/n,
           lcl = qbeta(.025, 0.5+cy, 0.5+n-cy),
           ucl = qbeta(.975, 0.5+cy, 0.5+n-cy))
  })
  
  output$plot <- renderPlot({
    ggplot(cumulative_data())+
      geom_point(aes(x=n,y=y))+
      geom_line( aes(x=n,y=p), linetype=2)+
      geom_line( aes(x=n,y=lcl))+
      geom_line( aes(x=n,y=ucl))+
      labs(x="Simulation number", y="Simulation outcome (1=null hypothesis)", 
           title="Proportion of simulations from the null hypothesis")+
      scale_linetype_manual(values=1:2, labels=c("p","cl"))
  })
  
  output$text <- renderText({
    o = cumulative_data()
    n = nrow(o)
    
    paste("Out of the ", n, " simulations that resulted in a pvalue of ", input$pvalue, 
          ", ", o$cy[n], " (",100*o$p[n], "%) of them were from the null hypothesis. ",
          "The estimated probability of the null hypothesis being true, based on your assumptions ",
          "on the left including an observed pvalue of ",
          input$pvalue, ", is ", round(o$p[n],2), " with a 95% Monte Carlo uncertainty interval of (", round(o$lcl[n],2),", ", 
          round(o$ucl[n],2),").", sep='')
  })


})
