library(shiny)
library(fueleconomy)
library(ggplot2)

# clean-up the fueleconomy dataset
fev <- fueleconomy::vehicles
fev$make <- as.factor(fev$make)
fev$model <- as.factor(fev$model)

# fev$cyl <- as.factor(fev$cyl)

fev$class <- gsub("[ /\\-]*[24][wW][dD]", "", fev$class)
fev$class <- gsub("Vans.*", "Vans", fev$class)
fev$class <- gsub("Sport Utility Vehicle", "SUV", fev$class)
fev$class <- gsub("-Large", "", fev$class)
fev$class <- gsub("s$", "", fev$class)
fev$class <- as.factor(fev$class)

fev$fuel <- gsub(".*(CNG|natural gas).*", "CNG", fev$fuel)
fev$fuel <- gsub(".*Electric.*", "Electric", fev$fuel)
fev$fuel <- gsub(".*propane.*", "Propane", fev$fuel)
fev$fuel <- gsub(".*(Gas|Midgrade|Premium|Regular).*", "Gas", fev$fuel)
fev$fuel <- as.factor(fev$fuel)

fev$trans <- as.factor(ifelse(grepl("Auto", fev$trans), "Auto", "Manual"))

fev$drive <- gsub(".*4-Wheel.*", "4WD", fev$drive)
fev$drive <- gsub(".*All-Wheel.*", "AWD", fev$drive)
fev$drive <- gsub(".*Wheel.*", "2WD", fev$drive)
fev$drive <- as.factor(fev$drive)

shinyServer(
  function(input, output){
  
    output$hwyCtySplit <- renderText({paste(input$iPctHwy/100, "/", 1-input$iPctHwy/100)})

    classSelection <- reactive({
      c_sel <- input$vehClasses
      if (is.null(c_sel)) {
        c_sel <- levels(fev$class)
      }
      c_sel
    })
    
    output$classSelection <- renderText({
      paste(classSelection(), collapse=", ")
    })

    output$fev_plot <- renderPlot({
      pctHwy <- input$iPctHwy/100
      pctCty <- 1-pctHwy
      .e = environment()
      
      c_sel <- classSelection()

      ggplot(data=fev[fev$year>=input$yearRange[1] & fev$year<=input$yearRange[2] & fev$class %in% c_sel,],
             aes(x=year, y=(pctCty*cty + pctHwy*hwy)), environment=.e) +
        geom_point(aes(colour=fuel)) +
        ylab(paste(pctCty, "× City MPG +", pctHwy, "× Highway MPG")) +
        ggtitle("Combined MPG by year and fuel type")
    })
  }
)