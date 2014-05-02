library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Posterior probability conditional on an observed pvalue"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput('pH0', 'Pr(H0)',
                  min=0, max=1,    value=0.5,  step=0.1,  round=3),
      sliderInput('pvalue', 'Observed p-value',
                  min=0, max=0.05, value=0.05, step=.005, round=3)
    ),
    
    mainPanel(
      plotOutput('plot')
    )
  )
))
