
library(shiny)

fluidPage(
  titlePanel("Hello Shiny!"),)
dashboardPage(
  dashboardHeader(title="Steam Analysis",
                  tags$li(a(href = 'http://steampowered.com',
                            img(src="https://www.seekpng.com/png/full/866-8660479_steam-logo-vector-steam-logo-png.png", height="40px", width="140px"),
                            title = "Back to Apps Home"),
                          class = "dropdown")),
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Player", tabName = "dashboard", icon = icon("gamepad")),
      menuItem("Ratings", tabName = "widgets", icon = icon("star")),
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("About", tabName = "about", icon = icon("info"))
    )
  ),
  ## Body content
  dashboardBody(
    #custom css
    tags$head(tags$style(HTML(".col-sm-8 .small-box.bg-navy {padding: 20px}"))),
    tags$head(tags$style(HTML(".col-sm-4 .small-box.bg-red {padding: 20px}"))),
    
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              h1(glue("Top {nrow(steam)} Games with highest player"),style="font-weight:bold;"),
              fluidRow(
                div(style="height:100px",
                        
                valueBox(paste(month(min(steam$Release.date), label = T), 
                               year(min(steam$Release.date)),"-", month(max(steam$Release.date),label = T),year(max(steam$Release.date))  ), "All Release Date Game", icon = icon("calendar",style="color:#B8C7CE; padding-right:20px;"), color = "navy", width=8, ),
                valueBox(nrow(steam), "Total Games", icon = icon("gamepad"), color = "red",)
                ),
                style="padding-top:3rem; margin-bottom:3rem;" ),
              
              fluidRow(
                box(
                  dateRangeInput(inputId = "dateRange1",
                                   label = h3("Realese Date"),
                                   start = glue("{year(now())}-01-01"),
                                   end = max(steam$Release.date),
                                   min = min(steam$Release.date),
                                   max = max(steam$Release.date),
                                   format = "yyyy-M-dd",
                                   startview = "month",
                                   language = "id",
                                   separator = "-",
                                   autoclose = TRUE,
                                    ),
                    width = 4,height = 160),
                
                
               
                box(
                  # numericInput("rangePlot1",
                  #              label = h3("displayed"),
                  #              value = 5,
                  #              max = nrow(steam)
                  # ),
                  
                  sliderInput("rangePlot1",
                              label = h3("Slider Range"),
                              min = 0,
                              max = 15,
                              value = 5
                              ),
                  width = 8),
                
                box(
                  plotlyOutput("barPlot1"), 
                  width = 12),
                
                box(title = h3("Summary From Plot"), 
                    width = 12,
                    valueBoxOutput("summary1", width = 6),
                    valueBoxOutput("summary2", width = 6),
                    height = 270),
              )
      ),
      
      
      # Second tab content
      tabItem(tabName = "widgets", 
              fluidRow(
                valueBoxOutput("valueBoxRatings",width = 12),
                  ),
              fluidRow(
                box(
                  selectInput(inputId = "selectRatings1", 
                              label = h3("Select Ratings"), 
                              selected = unique(steam$Review.summary )[1], 
                              choices = unique( steam$Review.summary )),
                  width = 3, height = 465),
                
                tabBox(
                  title = glue("Total Review & Response in All Game"),
                  id = "tabset1", height = "250px",
                  tabPanel("Top 15", plotlyOutput("plotLolipopTop")), 
                  tabPanel("Bottom 15", plotlyOutput("plotLolipopBottom")),width = 9
                ), 
              )
      ),
      
      # Third  tab content
      tabItem(tabName = "data",
        box(
          h1("All Data"), DT::dataTableOutput("table1"),
          width = 12
        )
      ),

      # fourth   tab content
      tabItem(tabName = "about",
              fluidRow(
                box(
                  column(9,
                         h2(icon("info"),"About This Page"),
                         p("Dashboard ini menvisualisasikan tentang pemain Game yang tersedia di ",a("Steam", href="https://steampowered.com/")),
                         p("Dashboard ini ditujukan untuk pemain game yang ingin mencari game yang sesuai ."),
                         
                         h3(icon("newspaper-o"),"Contents in this dashboard "),
                         h4("- Tab 1(Game Player) "),
                         p("Terdapat date input untuk memilih realese date yang sesiu dengan keinginan"),
                         p("Memperlihatkan bar plot yang mengurutkan Peak Player Today dari besar ke kecil."),
                         p("Terdapat silder untuk mengatur jumlah data game yang akan tampil di bar plot."),
                         
                         h4("- Tab 2(Ratings)"),
                         p("Terdapat select input untuk memilih kategori Rantings"),
                         p("Memperlihatkan Lolipop plot yang mengurutkan Total Review dari kecil ke besar yang menampilkan Rating sesuai dengan yang kita pilih"),
                         
                         h4("- Tab 3(Data)"),
                         p("Memperlihatkan semua data dari Nama Game, Review Summary , Total Current Players, Total Peak Players Poday Release Date dan Total Reviews"),
                         
                         h4("- Tab 4(About)"),
                         p("Menceritakan Tentang Dashboard ini"),
                         
                         h3(icon("database"),"Source Data"),
                         p("Data diambil dari Website ",a("kaggle.com/angadchau/steam-top-100-gamesnov-2021", href="https://www.kaggle.com/angadchau/steam-top-100-gamesnov-2021")),
                         p(glue("Data yang tersedia adalah data dari {min(steam$Release.date)} sampai {max(steam$Release.date)} dari {nrow(steam)} game Teratas.")),
                         
                         h3(icon("file-code-o"),"View Code"),
                         p("Lihat Code dari dashboard ini ",a("github.com/Arsyadam", href="https://www.github.com/Arsyadam/")),
                   
                         h3(icon("address-card-o"),"Contact us"),
                         a(icon("instagram"), href="https://instagram.com/arsyadam.id/",style="font-size:25px; margin-left:5px;margin-right:5px;"),
                         a(icon("github"), href="https://github.com/Arsyadam",style="font-size:25px; margin-left:5x;margin-right:5px;"),
                         a(icon("envelope-o "), href="mailto:arsyadamid.work@gmail.com",style="font-size:25px; margin-left:5px;margin-right:5px;")
                        )   
                  ,width = 12)
              )
      )
      
    )
  )
)

