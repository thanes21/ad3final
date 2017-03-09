#Loads the Shiny library
library('shiny')
library('ggplot2')
library('plotly')

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
      actionButton(inputId = "search", "Search"),
      
      #Drop down menu for user to select a category in the searched game
      uiOutput("category")
    ),
    
    #Creates the main panel that displays the data
    mainPanel(
      
      #Name of the game
      h2(textOutput("name")),
    
      #Creates the tab format
      tabsetPanel(

        #Leaderboard of the game
        tabPanel("Table", tableOutput("leader")),
        
        #Plot of the runs
        tabPanel("Plot", plotlyOutput("plot"), "This is an interactive plot showing the top runs for your game of choice. Each point represents a run, and its position on the graph indicates the time of the run. Hover over one of the data points to see all the information!"),
      
        #Plot of the countries
        tabPanel("Country", plotlyOutput("country.plot"), "This is an interactive plot showing the number of speedruns recorded in a certain country. Hover over one of the bars to see the exact number of speed runs! How well does your country speed run?"),
        
        #A video embed of the top record
        tabPanel("Video", uiOutput('video'))
      )
    )
  )
)

shinyUI(ui)