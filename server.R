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

    #Reactive data to change leaderboard based on category chosen
    data <- reactive({
      
      #Filters all the categories for the chosen category
      filtered <- filter(flatten(categories), data.name == input$category)
      
      #Queries API again using the games ID to get leaderboards of each category
      leaderboards.response <- GET(paste0("http://www.speedrun.com/api/v1/leaderboards/", game.id, "/category/", filtered$data.id))
      body <- fromJSON(content(leaderboards.response, "text"))
      leaderboards <- body$data$runs
      leaderboards <- as.data.frame(leaderboards) %>% flatten()

      #Queries API again using the game ID to get player names
      leaderboards.players.response <- GET(paste0("http://www.speedrun.com/api/v1/leaderboards/", game.id, "/category/", filtered$data.id, "?embed=players"))
      body <- fromJSON(content(leaderboards.players.response, "text"))
      leaderboards.players <- body$data$players$data$names$international
      leaderboards.players <- as.vector(leaderboards.players)
      
      #Gets the country where each speedrun was accomplished
      leaderboards.countries <- body$data$players$data$location$country$names$international
      leaderboards.countries <- as.vector(leaderboards.countries)
      
      #Creates a data frame representing a leaderboard based on the given category
      display.leaderboard <- select(leaderboards, place)
      display.leaderboard$country <- leaderboards.countries
      display.leaderboard$names <- leaderboards.players
      display.leaderboard$run.times.realtime_t <- leaderboards$run.times.realtime_t
      display.leaderboard$run.date <- leaderboards$run.date
      colnames(display.leaderboard) <- c("Place", "Country", "Player", "Time", "Date")
      
      return(display.leaderboard)
    })
    
    #Renders a data table representation of a leaderboard
    output$leader <- renderTable(data())
    
    #Creates plot
    output$plot <- renderPlotly({
      p <- ggplot(data = data(), mapping = aes(x = Place, y = Time, color = Date)) +
        geom_point() +
        labs(x = "Place",
             y = "Time (seconds)")
      
      p <- ggplotly(p)
      
      return(p)
    })
    
    #Creates plot of number of speedruns in a country
    output$country.plot <- renderPlotly({
      p <- ggplot(data = data(), mapping = aes(x = Country, width = 20)) +
        geom_bar(fill = "purple") +
        labs(title = "Which Country Had The Most Speed Runs?",
             x = "Country",
             y = "Number of speedruns") +
        theme(axis.text.x = element_text(angle = 45)) +
        theme(legend.position="none")
      
      p <- ggplotly(p)
      
      return(p)
    })
  })
}

shinyServer(server)