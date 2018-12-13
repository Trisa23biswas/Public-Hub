library(shiny)
library(shinydashboard)

# Define UI for data upload app ----
ui <- dashboardPage(skin = "green",
  dashboardHeader(title = "IRIS Data Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Charts", tabName = "Charts", icon = icon("stats", lib = "glyphicon")),
      menuItem("Prediction (File Upload)", tabName = "pred", icon = icon("list-alt", lib = "glyphicon")),
      menuItem("Prediction (User Input)", tabName = "pred1", icon = icon("list-alt", lib = "glyphicon"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              fluidRow(
                box(title="File Upload", fileInput("file1", "Choose CSV File"), status = "success", solidHeader = TRUE, width = "12"),
                box(title = "Data Preview",DT::dataTableOutput("contents"), status = "success", solidHeader = TRUE, width = "7"),
                box(title = "Data Summary",verbatimTextOutput("summary"), status = "success", solidHeader = TRUE, width = "5")
                
              )
      ),
      
      # Second tab content
      tabItem(tabName = "Charts",
              h2("Analysis"),
              selectInput("var",
                          label = "Choose a variable",
                          choices = c("Sepal.Width"=2, "Petal.Length"=3,
                                      "Petal.Width"=4),
                          selected = 2),
              fluidRow(
                box(title = "Co-relation Chart", plotOutput("corrplot"), status = "success", solidHeader = TRUE),
                box(title = "Lattice Graph", plotOutput("FtrPlot"), status = "success", solidHeader = TRUE),
                box(title = "Box and Whisker Plots", plotOutput("boxPlot"), status = "success", solidHeader = TRUE),
                box(title = "Probability Density Plot", plotOutput("attPlot"), status = "success", solidHeader = TRUE)
              )   
      
      ),
      
      #third tab content
      tabItem(tabName = "pred",
              h2("Model Prediction"),
              verbatimTextOutput("modelSummary"),
              downloadButton("downloadData", "Download Predictions")
              ),
      
      #fourth tab content
      tabItem(tabName = "pred1",
              h2("Enter the required values"),
              fluidRow(
              box(title = "Sepal Length" ,numericInput("sl", label = "", value = "1"), status = "success", solidHeader = TRUE, width = 3),
              box(title = "Sepal Width", numericInput("sw", label = "", value = "1"), status = "success", solidHeader = TRUE, width = 3),
              box(title = "Petal Length", numericInput("pl", label = "", value = "1"), status = "success", solidHeader = TRUE, width = 3),
              box(title = "Petal Width", numericInput("pw", label = "", value = "1"), status = "success", solidHeader = TRUE, width = 3)
              ),
              actionButton("go","Predict", icon("paper-plane"), 
                           style="color: #fff; background-color: #00a65a; border-color: #00a65a"),
              verbatimTextOutput("predvalue"),
              verbatimTextOutput("prob"),
              imageOutput("img")
              
              )
  ) #tabitems close
)# dashboard body close
)# dashboard page close 

