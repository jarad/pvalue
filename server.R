library(shiny)

shinyServer(function(input,out) {
  output$plot <- renderPlot({
    plot(0,0)
  })
})
