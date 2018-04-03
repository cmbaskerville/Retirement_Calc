library(shiny)
library(dplyr)
hist_returns <- read.csv("C:/Users/Chris Baskerville/Documents/R_sessions and files/R_Projects/Index_Returns_Shiny/Index_returns.csv")

ui <- fluidPage(
  sliderInput(inputId = "Current Age", 
              label = "What is your current age?", 
              value = 35, min = 18, max = 100),
  
  sliderInput(inputId = "save_time", 
              label = "How long before you retire?", 
              value = 10, min = 1, max = 40),
  
  sliderInput(inputId = "life_span", 
              label = "How long do you think you'll live?", 
              value = 85, min = 40, max = 100),
  
  
  wellPanel(
    numericInput(inputId = "large_cap_weight",
               label = "Percent Large Cap Stocks",
               value = 20, min = 0, max = 100),
  
    numericInput(inputId = "small_cap_weight",
               label = "Percent Small Cap Stocks",
               value = 20, min = 0, max = 100),
  
    numericInput(inputId = "international_weight",
               label = "Percent International Stocks",
               value = 20, min = 0, max = 100),

    numericInput(inputId = "bond_weight",
             label = "Percent Bonds",
             value = 20, min = 0, max = 100),

    numericInput(inputId = "CD_weight",
             label = "Percent Bank Deposits",
             value = 20, min = 0, max = 100)
  ),
  actionButton("run", "Calculate")
)

server <- function(input, output){
  mydata <- reactive({
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    tbl <- read.csv("C:/Users/Chris Baskerville/Documents/R_sessions and files/R_Projects/Index_Returns_Shiny/Index_returns.csv", header = input$header, sep = input$sep,  dec = input$dec)
    
    return(tbl)
  })
  
  output$table.output <- renderTable({
    mydata()
  })
  
  output$plot1 <- renderPlot({
    x <- mydata()[,1]
    plot(x)
  })
}
shinyApp(ui = ui, server = server)