library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Null hypothesis probability conditional on an observed pvalue"),
  
  sidebarPanel(
    #style="min-width:235px;max-width:275px",
    sliderInput('pvalue', 'Observed pvalue',
                min=.001, max=0.05, value=0.05, step=.001, round=FALSE),
    br(),
    sliderInput('pH0', 'Proportion of true null hypotheses',
                min=0, max=1,    value=0.5,  step=0.1,  round=FALSE),
    br(),
    
    h4('Alternative distribution'),
    selectInput('distribution', '', 'normal', 'normal'),
    numericInput('mean', 'Mean', value=0),
    numericInput('sd', 'Standard deviation', value=1, min=0),
    br(),
    h4('Simulation parameters'),
    numericInput('n', 'Number of simulations', 100, min=1, step=1),
    numericInput('max_sims', 'Maximum attempts per simulation', 1000, min=1, step=1),
    submitButton('Simulate.')
  ),
    
  mainPanel(
    plotOutput('plot'),
    h4('Results'),
    textOutput('text'),
    includeMarkdown('help.md')
  )
))
