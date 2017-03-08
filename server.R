library('shiny')
library('httr')
library('jsonlite')
library('dplyr')


server <- function(input, output) {
  
  #Button is pressed, query API for the game the user entered
  observeEvent(input$search, {
    
    #Get list of games that user searches for and puts them in a data frame
    games.response <- GET(paste0("http://www.speedrun.com/api/v1/games?name=", "super%20mario%20world"))
    data <- fromJSON(content(games.response, "text"))
    games <- data.frame(data[1]) %>% flatten()
    
    
    #Selects the first game's ID (most like the users search)
    game.id <- games$data.id[1]
    
    
    #Queries API for all categories of the game
    category.response <- GET(paste0("http://www.speedrun.com/api/v1/games/", game.id, "/categories"))
    body <- fromJSON(content(category.response, "text"))
    categories <- data.frame(body[1])
    
    
    #Queries API again using the games ID to get leaderboards of each category
    leaderboards.response <- GET(paste0("http://www.speedrun.com/api/v1/leaderboards/", game.id, "/category/7kjrn323"))
    body <- fromJSON(content(leaderboards.response, "text"))
    leaderboards <- body$data$runs
    leaderboards <- as.data.frame(leaderboards) %>% flatten()
    


  })
}
