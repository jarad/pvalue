require(shiny)
require(markdown)

shinyUI(fluidPage(
  
  headerPanel("Null hypothesis probability conditional on an observed pvalue"),
  
  sidebarPanel(
    #style="min-width:235px;max-width:275px",
    sliderInput('pvalue', 'Observed pvalue',
                min=.001, max=0.05, value=0.05, step=.001, round=FALSE),
    br(),
    sliderInput('pH0', 'Proportion of true null hypotheses',
                min=0, max=1,    value=0.5,  step=0.05,  round=FALSE),
    br(),
    
    h4('Alternative distribution'),
    selectInput('distribution', '', 
                list('normal',
                     'point mass',
                     't',
                     'log-normal',
                     'gamma',
                     'beta',
                     'uniform'), 
                'normal'),
    conditionalPanel(
      condition = 'input.distribution == "normal"',
      numericInput('normal_mean', 'Mean', value=0),
      numericInput('normal_sd', 'Standard deviation', value=1, min=0)
    ),
    conditionalPanel(
      condition = 'input.distribution == "point mass"',
      numericInput('point_location', 'Location', value=0)
    ),
    conditionalPanel(
      condition = 'input.distribution == "t"',
      numericInput('t_df', 'Degrees of freedom', value=1),
      numericInput('t_location', 'Location', value=0),
      numericInput('t_scale', 'Scale', value=1)
    ),
    conditionalPanel(
      condition = 'input.distribution == "log-normal"',
      numericInput('lognormal_location', 'Location', value=0),
      numericInput('lognormal_scale', 'Scale', value=1)
    ),
    conditionalPanel(
      condition = 'input.distribution == "gamma"',
      numericInput('gamma_shape', 'Shape', value=1),
      numericInput('gamma_rate', 'Rate', value=1)
    ),
    conditionalPanel(
      condition = 'input.distribution == "beta"',
      numericInput('beta_shape1', 'Shape1', value=1),
      numericInput('beta_shape2', 'Shape2', value=1)
    ),
    conditionalPanel(
      condition = 'input.distribution == "uniform"',
      numericInput('uniform_lb', 'Lower bound', value=0),
      numericInput('uniform_ub', 'Upper bound', value=1)
    ),
    br(),
    h4('Simulation parameters'),
    numericInput('n', 'Number of simulations', 1, min=1, step=1),
    numericInput('max_sims', 'Maximum attempts per simulation', 1000, min=1, step=1)#,
#    submitButton('Simulate.')
  ),
    
  mainPanel(
    tabsetPanel(
      tabPanel('Basic',                  plotOutput('basic_plot'), textOutput('basic_text')),
      tabPanel('with Monte Carlo error', plotOutput('plot' ),      textOutput('text')),
      tabPanel('Help', includeMarkdown('help.md'))
    )
  )
))
