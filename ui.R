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
    p("This app provides a simple interface for examining fuel economy as a function of model year among
      cars sold in the US between 1984 and 2015. The dataset is based on the CRAN",
      a("fueleconomy", href="http://cran.r-project.org/web/packages/fueleconomy/index.html"),
      "dataset. The dataset has been sanitized considerably, but still makes a five-way fuel-type distinction
      between gas, diesel, electric, propane, and compressed natural gas (CNG)."),
    p("The user has three controls to change the appearance of the plot:"),
    p("1. Standard combined highway/city MPG ratings are biased towards city driving (55%) rather than
      highway driving (45%). The first parameter allows adjustment of this bias, according to the user's own
      driving preference or interest."),
    p("2. A range slider allows selecting a subset of the available years."),
    p("3. And there are 16 different vehicle classes, which may be individually selected or excluded from
      consideration, using the multi-select box at the bottom of the parameters panel."),

    plotOutput('fev_plot'),
    
    h4("Highway / city driving split:"),
    verbatimTextOutput("hwyCtySplit"),

    h4("Vehicle classes:"),
    verbatimTextOutput("classSelection")
  )
))
