library(shiny)

vehicle_classes = c("Compact Car", "Large Car", "Midsize Car", "Midsize Station Wagon",
                    "Minicompact Car", "Minivan", "Small Pickup Truck", "Small Station Wagon",
                    "Small SUV", "Special Purpose Vehicle", "Standard Pickup Truck", "Standard SUV",
                    "Subcompact Car", "SUV", "Two Seater", "Van")

shinyUI(pageWithSidebar(
  headerPanel("US Vehicle Fuel Economy"),
  
  sidebarPanel(
    h3("Parameters:"),
    sliderInput("iPctHwy", "Percentage highway driving:",
                min=0, max=100, value=45, step=1),
    
    sliderInput("yearRange", "Years to consider:",
                min = 1984, max = 2015, value = c(1984, 2015),
                sep = ""),
    
    selectInput("vehClasses", "Vehicle classes to consider (default: all):", vehicle_classes,
                multiple=TRUE)

    #submitButton("Submit")
  ),
  mainPanel(
    plotOutput('fev_plot'),
    
    h4("Highway / city driving split:"),
    verbatimTextOutput("hwyCtySplit"),

    h4("Vehicle classes:"),
    verbatimTextOutput("classSelection")
  )
))
