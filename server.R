library('shiny')
library('httr')
library('jsonlite')
library('dplyr')


server <- function(input, output) {
  
  #Button is pressed, query API for the game
  observeEvent(input$search, {
    url <- paste0("http://www.speedrun.com/api/v1/games?name=", "super%20mario%20world")
    
    #Get list of games that user searches for and puts them in a data frame
    response <- GET(url)
    data <- fromJSON(content(response, "text"))
    games <- data.frame(data[1]) %>% flatten()
    
    #Queries API again using the games ID to get more information
    game.id <- games$data.id[1]
    response <- GET()
    
    output$userinput <- renderText({url})

  })
}
