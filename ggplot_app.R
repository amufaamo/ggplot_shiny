library(shiny)
library(tidyverse)
library(ggsci)
library(ggpmisc)
library(gfonts)
library(DT)

#use_font("roboto", "/Users/masakazuifrec/Desktop/www/css/roboto.css")

ui <- fluidPage(
  titlePanel("Plot"),
  sidebarLayout(
    sidebarPanel(
      actionButton('iris_load', "Use iris dataset"),
      selectInput(inputId = "x_axis", label = "X axis", choices = NULL),
      selectInput(inputId = "y_axis", label = "Y axis", choices = NULL),
      selectInput(inputId = 'themes', label = "Themes", choices = c('theme_bw()', 'theme_gray()', 'theme_dark()', 'theme_classic()', 'theme_light()', 'theme_linedraw()', 'theme_minimal()', 'theme_void()')),
    ),
    mainPanel(
      DTOutput('table'),
      plotOutput('plot')
      
    ),
  )
)




server <- function(input, output, session) {
  
  df <- eventReactive(input$iris_load, {
    read.csv('data/iris.csv')
  })
  
  observeEvent(df(),{
    req(df())
    updateSelectInput(session, 'x_axis', choices = names(df()))
    updateSelectInput(session, 'y_axis', choices = names(df()))
  })
  
  output$table <- renderDT({
    df()
  })
  
  plot <- reactive({
    req(df())
    g <- ggplot(df(), aes_string(x = input$x_axis, y = input$y_axis))
    g <- g + geom_point()
    g <- g + eval(parse(text = input$themes))
    return(g)
  })
  
  output$plot <- renderPlot(plot())
}

shinyApp(ui = ui, server = server)


