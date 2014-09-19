library(shiny)

shinyUI(fluidPage(
     
     # Application title
     titlePanel("TDEE Calculation"),
     
     # Sliders for Age, Weight, Height, 
     sidebarLayout(
          sidebarPanel(
               sliderInput("age",
                           "Age:",
                           min = 0,
                           max = 100,
                           step = 1,
                           value = 30),
               sliderInput("weight",
                           "Weight (kg):",
                           min = 25,
                           max = 180,
                           step = 0.5,
                           value = 65),
               p("In Pounds: ", strong(textOutput("pounds", inline=T), " lbs")),
               radioButtons("sex",
                            "Sex:",
                            c("Male" = "male",
                              "Female" = "female")),
               radioButtons("activity",
                            "Acitivity Level:",
                            c("Sedentary -- Spend most of the day sitting, 
                              resting" = "sed",
                              "Lightly Acitve -- Desk job with little exercise" 
                              = "light",
                              "Moderately Active -- Light Industry job 
                              (electrical, carpentry) or office job with 1-2 hours of 
                              exercise daily" = "mod",
                              "Very Active -- Professional Athlete or daily 
                              exercise comparable to running 9-13 miles" = "very",
                              "Extremly Active -- Very labourous job or daily 
                              exercise comparable to running 14-17 miles" 
                              = "extreme"))
          ),
          
          # Show results
          mainPanel(
               sliderInput("weeks",
                           "Number Of Weeks To Show:",
                           min = 1,
                           max = 100,
                           step = 1,
                           value = 25),
               sliderInput("cals",
                           "Average Number Of Calories Consumed Daily:",
                           min = 1200,
                           max = 4000,
                           step = 10,
                           value = 2000),
               tabsetPanel(type="tabs",
                           tabPanel("Table",tableOutput(outputId="tdee")),
                           tabPanel("Plot", plotOutput("distPlot"),
                                    radioButtons("measure",
                                                 "Show Weight: ",
                                                 c("Imperial" = "imp",
                                                   "Metric" = "met")))
                           )
          )
     )
))
