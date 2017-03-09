library('shiny')
library('httr')
library('jsonlite')
library('dplyr')
library('tidyr')


server <- function(input, output) {
  
  #Button is pressed, query API for the game the user entered
  observeEvent(input$search, {
    
    #Get list of games that user searches for and puts them in a data frame
    # games.response <- GET(paste0("http://www.speedrun.com/api/v1/games?name=", input$game, "&max=1"))
    games.response <- GET(paste0("http://www.speedrun.com/api/v1/games?name=", "super mario world", "&max=1"))
    data <- fromJSON(content(games.response, "text"))
    games <- data.frame(data[1]) %>% flatten()
    
    
    #Selects the first game's ID (most like the users search)
    game.id <- games$data.id[1]
    game.name <- games$data.names.international[1]
    output$name <- renderText(game.name)
    
    #Queries API for all categories of the game
    # category.response <- GET(paste0("http://www.speedrun.com/api/v1/games/", game.id, "/categories"))
    category.response <- GET(paste0("http://www.speedrun.com/api/v1/games/", "pd0wq31e", "/categories"))
    body <- fromJSON(content(category.response, "text"))
    categories <- data.frame(body[1])
    
    
    #Queries API again using the games ID to get leaderboards of each category
    # leaderboards.response <- GET(paste0("http://www.speedrun.com/api/v1/leaderboards/", game.id, "/category/", categories$data.id[1]))
    leaderboards.response <- GET(paste0("http://www.speedrun.com/api/v1/leaderboards/", "pd0wq31e", "/category/", categories$data.id[1]))
    body <- fromJSON(content(leaderboards.response, "text"))
    leaderboards <- body$data$runs
    leaderboards <- as.data.frame(leaderboards) %>% flatten()
    
    #Queries API again using the user ID to get usernames
    test <- as.data.frame(leaderboards$run.players)
    test
    
    #Creates data frame to display
    display.leaderboard <- select(leaderboards, place, run.players, run.times.realtime_t, run.date)
    display.leaderboard <- display.leaderboard %>%
      mutate(run.players = )
      

    output$leader <- renderTable(display.leaderboard)
    
  })
}

