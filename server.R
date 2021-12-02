library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$table1 = DT::renderDataTable({
      steam
    })

    output$barPlot1 <- renderPlotly({
      wrPlot1 <- 
        steam %>% 
        filter(Release.date >= input$dateRange1[1] & Release.date <= input$dateRange1[2]) %>% 
        head(input$rangePlot1) 
      
      plot1 <- 
        wrPlot1 %>% 
        ggplot(aes(x = Peak.players.today, y = reorder(Game,Peak.players.today), 
                   text = glue("{Game}
                        Realese Date : {Release.date}
                        Peak Player Today: {scales::comma(Peak.players.today, 1)}
                        Current Players: {scales::comma(Current.players, 1)}"))) + 
        geom_col(mapping=aes(fill=Current.players)) +
        scale_x_continuous(labels = scales::comma) +
        labs(title = , 
             x = "Peak Player Today", 
             y = NULL, 
             fill = "Current Players") 
      
      ggplotly(plot1, tooltip="text")
    })
    
    
    output$summary1<- renderValueBox({
        wrBox1 <- steam %>% 
                  select(Game, Peak.players.today, Release.date) %>% 
                  filter(Release.date >= input$dateRange1[1] & Release.date <= input$dateRange1[2]) %>% 
                  head(1)
        
        valueBox(
            wrBox1$Game ,HTML(paste(h4(glue("Realese Date : {wrBox1$Release.date} | ({scales::comma(wrBox1$Peak.players.today, 1)})")),br(),"Most Peak Players Today")) , 
            icon = icon("star"),
            color = "yellow", width = 12
      )
    })
    
    output$summary2<- renderValueBox({
      wrBox1 <- steam %>% 
        select(Game, Current.players, Release.date) %>% 
        filter(Release.date >= input$dateRange1[1] & Release.date <= input$dateRange1[2]) %>% 
        head(1)
      
      valueBox(
        wrBox1$Game ,HTML(paste(h4(glue("Realese Date : {wrBox1$Release.date} | ({scales::comma(wrBox1$Current.players, 1)})")),br(),"Most Current Player")) , 
        icon = icon("clock-o"), width = 12
      )
    })
    
    output$valueBoxRatings <- renderValueBox({
      mostTotReview <- steam %>% 
        select(Game, Total.reviews,Review.summary) %>% 
        filter(Review.summary==input$selectRatings1) %>% 
        arrange(-Total.reviews) %>% 
        head(1)
      
      valueBox(glue("{mostTotReview$Game}"), 
               HTML(paste(h3(glue("({scales::comma(max(mostTotReview$Total.reviews), 1)})"), 
               style="font-size:25px;"),br(),glue("Most Total Review in {mostTotReview$Review.summary}"))), 
               icon = icon("arrow-up"), 
               color = "red", 
               width = 12)
      
    })
    
    output$plotLolipopTop <- renderPlotly({
      wrPlot2 <- 
        
        steam %>% 
        select(Game, Total.reviews, Review.summary) %>% 
        filter(Review.summary==input$selectRatings1) %>% 
        head(15)
      
      
      plot2 <- 
        wrPlot2 %>% 
        ggplot(aes(x = Total.reviews, y = reorder(Game,Total.reviews), 
                   text = glue("{Game}
                          Total Review: {scales::comma(Total.reviews, 1)}
                          Response : {Review.summary} "))) +
        geom_point(size = 3, colour = "black") + 
        geom_segment(aes(x=Total.reviews, xend=Total.reviews, y=0, yend=reorder(Game,Total.reviews)))+
        scale_x_continuous(labels = scales::comma) +
        labs(title = glue("Total Review in {input$selectRatings1}"), 
             x = "Total Review", 
             y = NULL, 
             fill = NULL) 
      
      
      
      
      ggplotly(plot2, tooltip="text")
    })
    
    output$plotLolipopBottom <- renderPlotly({
      wrPlot3 <- 
        steam %>% 
        select(Game, Total.reviews, Review.summary) %>% 
        filter(Review.summary==input$selectRatings1) %>% 
        tail(15)
      
      
      plot2 <- 
        wrPlot3 %>% 
        ggplot(aes(x = Total.reviews, y = reorder(Game,Total.reviews), 
                   text = glue("{Game}
                          Total Review: {scales::comma(Total.reviews, 1)}
                          Response : {Review.summary} "))) +
        geom_point(size = 3, colour = "black") + 
        geom_segment(aes(x=Total.reviews, xend=Total.reviews, y=0, yend=reorder(Game,Total.reviews)))+
        scale_x_continuous(labels = scales::comma) +
        labs(title = glue("Total Review in {input$selectRatings1}"), 
             x = "Total Review", 
             y = NULL, 
             fill = NULL) 
      
      
      
      
      ggplotly(plot2, tooltip="text")
    })
    
    
})
