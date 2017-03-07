#Load the Shiny library
library('shiny')

#Load in the UI and Server from separate .R files
source('ui.R')
source('server.R')

#Create a new Shiny App using the given UI and server
shinyApp(ui = ui, server = server)
