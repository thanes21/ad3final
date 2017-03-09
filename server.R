library('shiny')
library('httr')
library('jsonlite')
library('dplyr')
library('ggplot2')
library('plotly')

server <- function(input, output) {
  
  #Button is pressed, query API for the game the user entered
  observeEvent(input$search, {
    
    #Get list of games that user searches for and puts them in a data frame
    games.response <- GET(paste0("http://www.speedrun.com/api/v1/games?name=", input$game, "&max=1"))
    data <- fromJSON(content(games.response, "text"))
    games <- data.frame(data[1]) %>% flatten()
    
    
    #Selects the first game's ID (most like the users search)
    game.id <- games$data.id[1]
    game.name <- games$data.names.international[1]
    output$name <- renderText(game.name) #Name of the game being displayed
    
    
    #Queries API for all categories of the game
    category.response <- GET(paste0("http://www.speedrun.com/api/v1/games/", game.id, "/categories"))
    body <- fromJSON(content(category.response, "text"))
    categories <- data.frame(body[1])
    
    
    #Renders categories of the game in a drop down menu
    output$category <- renderUI({
      selectInput("category", "Categories", categories$data.name)
    })
    
    
    #Queries API again using the games ID to get leaderboards of each category
    leaderboards.response <- GET(paste0("http://www.speedrun.com/api/v1/leaderboards/", game.id, "/category/", categories$data.id[1]))
    body <- fromJSON(content(leaderboards.response, "text"))
    leaderboards <- body$data$runs
    leaderboards <- as.data.frame(leaderboards) %>% flatten()
    
    #Renders a data table representation of a leaderboard
    display.leaderboard <- select(leaderboards, place, run.times.realtime_t, run.date)
    colnames(display.leaderboard) <- c("Place", "Time", "Date")
    output$leader <- renderTable(display.leaderboard)
    
    # Trying plot stuff
    output$plot <- renderPlotly({
      p <- ggplot(data = display.leaderboard, mapping = aes(x = Place, y = Time, color = Date)) +
        geom_point() +
        labs(x = "Place",
             y = "Time (seconds)")
      
      p <- ggplotly(p)
      
      return(p)
    })
  })
}

shinyServer(server)
