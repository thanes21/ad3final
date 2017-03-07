#Loads the Shiny library
library('shiny')


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
      actionButton("search", "Search")
    ),
    
    #Creates the main panel that displays the data
    mainPanel(
      verbatimTextOutput("userinput")
    )
  )
)
