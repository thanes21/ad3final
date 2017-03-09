#Loads the Shiny library
library('shiny')
library('shinyLP')

#Defines a UI with a sidebar layout and multiple tabs for the user to choose
ui <- fluidPage(
  #Title of the app
  titlePanel("Speedrun"),
  
  #Creates the sidebar
  sidebarLayout(
    
    #Creates the widgets that the user can use to change the data
    sidebarPanel(
      
      
      #Users input to search for game
      textInput("game", "Game", value = ""),
      
      
      #Button pressed for user to search
      actionButton("search", "Search"),
      
      HTML('<iframe width="600" height="400" src="//www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>')     
    ),
    
    #Creates the main panel that displays the data
    mainPanel(
      h2(textOutput("name")),
      
      tableOutput("leader")
      
      )
  )
)
