library(shinydashboard)
library(shiny)
library(PerformanceAnalytics)
library(ellipse)
library(caret)
library(DT)

server <- function(input, output, session) 
{
  #######################################################################
  ##########################################################################
    data <- reactive({ 
    req(input$file1) ## ?req #  require that the input is available
    inFile <- input$file1
    })
    output$contents <- DT::renderDataTable({
    req(input$file1)
    df <- read.csv(input$file1$datapath)
    #data <- data.frame(df),
    library(DT)
    DT::datatable(df, options = list(pageLength = 5), width = "4")
    })
    output$summary <- renderPrint({
    req(input$file1)
    df <- read.csv(input$file1$datapath)
    datas <- data.frame(df)
    library(skimr)
    print(skim(datas))
    })
    output$corrplot<- renderPlot({
    req(input$file1)
    df <- read.csv(input$file1$datapath)
    data <- df[,c(1,2,3,4)]
    x<-as.numeric(data[,as.numeric(input$var)])
    y<-as.numeric(data$Sepal.Length)
    plot(x, y, log = "xy", xlab=colnames(data)[as.numeric(input$var)], ylab="Sepal.Length")
    chart.Correlation(cbind(x,y), histogram=TRUE, pch=19)
    title(xlab=colnames(data)[as.numeric(input$var)], ylab="Sepal.Length")
    })
    output$FtrPlot<- renderPlot({
    req(input$file1)
    df <- read.csv(input$file1$datapath)
    #data <- df[,c(1,2,3,4)]
    # split input and output
    x <- df[,1:4]
    y <- df[,5]
    # scatterplot matrix
    library(ellipse)
    featurePlot(x=x,y=y, plot="ellipse")
    })
    output$boxPlot<- renderPlot({
    req(input$file1)
    df <- read.csv(input$file1$datapath)
    # split input and output
    x <- df[,1:4]
    y <- df[,5]
    library(ellipse)
    featurePlot(x=x, y=y, plot="box")
    })
    output$attPlot<- renderPlot({
    req(input$file1)
    df <- read.csv(input$file1$datapath)
    # split input and output
    x <- df[,1:4]
    y <- df[,5]
    library(ellipse)
    scales <- list(x=list(relation="free"), y=list(relation="free"))
    featurePlot(x=x, y=y, plot="density", scales=scales)
    })
  
    output$modelSummary <- renderPrint({
    req(input$file1)
    df <- read.csv(input$file1$datapath)
    model <- load(file = "irisn.rda")
    YE <- df[,1:4]
    #y_pred = predict(get(model), newdata = YE)
    #print(y_pred)
    dat2 <- data.frame(YE, Predicted = predict(get(model), YE))
    print(dat2)
      # Downloadable csv of selected dataset ----
      output$downloadData <- downloadHandler(
      filename = function() {
        paste(input$dat2, "predictions.csv", sep = "")
      },
      content = function(file) {
        write.csv(dat2, file, row.names = FALSE)
      }
      )
    })
    
    #predonfly
    # You can access the value of the widget with input$num, e.g.
    observeEvent(input$go, {
      frames <- cbind(Sepal.Length=as.numeric(input$sl),Sepal.Width=as.numeric(input$sw),Petal.Length=as.numeric(input$pl),Petal.Width=as.numeric(input$pw))
      frames <- data.frame(frames)
      model <- load(file = "irisn.rda")
      dt <- data.frame(Predicted = predict(get(model), frames))
      output$predvalue <- renderPrint(dt)
      probs <- exp(predict(get(model), type = "prob" , newdata=frames))
      output$prob <- renderPrint(probs)
      if (dt == "setosa")
      {
        output$img <- renderImage({
        filename1 <- normalizePath(file.path('./images',paste('setosa', input$n, '.jpg', sep='')))
        # Return a list containing the filename
        list(src = filename1, height=300,width=400)},
          deleteFile = FALSE)
      }
      else if (dt == "virginica")
      {
        output$img <- renderImage({
          filename2 <- normalizePath(file.path('./images',paste('virginica', input$n, '.jpg', sep='')))
          # Return a list containing the filename
          list(src = filename2, height=300,width=400)},
          deleteFile = FALSE)
      }
      else
      {
        output$img <- renderImage({
          filename3 <- normalizePath(file.path('./images',paste('versicolor', input$n, '.jpg', sep='')))
          # Return a list containing the filename
          list(src = filename3, height=250,width=400)},
          deleteFile = FALSE)
      }
      
    }) #observe event end
    
} #server end