library(shiny)

shinyServer(function(input,output) {
  output$plot <- renderPlot({
    plot(0,0)
  })
})
