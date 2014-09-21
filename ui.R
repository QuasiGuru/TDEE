library(shiny)

shinyUI(fluidPage(
     
     # Application title
     titlePanel("Body Weight Planner"),
     
     sidebarLayout(
          sidebarPanel(
               #Daily Calorie Consumption
               h4("Calorie Consumption"),
               sliderInput("cals",
                           "Average Number Of Calories Consumed Daily:",
                           min = 1200,
                           max = 4000,
                           step = 10,
                           value = 2000),
               br(),
               
               # Sliders/Buttons for Age, Weight, Height and Sex 
               h4("BMR Parameters"),
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
               sliderInput("height",
                           "Height (cm):",
                           min = 10,
                           max = 245,
                           step = 1,
                           value = 170),
               p("In Feet: ", strong(textOutput("inches", inline=T))),
               radioButtons("sex",
                            "Sex:",
                            c("Male" = "male",
                              "Female" = "female"),
                            inline=T),
               br(),
               
               # Activity Level
               h4("TDEE Parameters"),
               radioButtons("activity",
                            "Acitivity Level:",
                            c("Sedentary -- Little or no exercise" = "sed",
                              "Lightly Acitve -- light exercise/sports 1-3 days/week" 
                              = "light",
                              "Moderately Active -- moderate exercise/sports 3-5 days/week" = "mod",
                              "Very Active -- hard exercise/sports 6-7 days a week" = "very",
                              "Extremly Active -- very hard exercise/sports & physical job or 2x training" 
                              = "extreme")),
               br(),
               
               #Page Options
               h4("View Options"),
               sliderInput("weeks",
                           "Number Of Weeks To Show:",
                           min = 1,
                           max = 100,
                           step = 1,
                           value = 25),
               radioButtons("measure",
                            "Show Plot: ",
                            c( "Metric" = "met",
                               "Imperial" = "imp"),
                            inline = T)
          ),
          
          # Show results
          mainPanel(
               #Picture
               img(src="scale.png", height=299, width=300),
               tabsetPanel(type="tabs",
                           #Table Of Weight Progression
                           tabPanel("Table",tableOutput(outputId="tdee")),
                           
                           #Plot Of Weight Progression
                           tabPanel("Plot", plotOutput("distPlot")),
                           
                           #Instructions
                           tabPanel("Instructions",
                                    p("1. Use the BMR parameters (age, weight, height,
                                      sex) to determine your Basic Metabolic Rate.
                                      BMR indicates the calories you would expend in a day
                                      if you were in a coma"),
                                    p("2. Select your daily activity level to determine your 
                                      Total Daily Energy Expenditure.  TDEE estimates the total
                                      number of calories you expend in a day.  Thus, if you consume
                                      the same number of calories, your weight would stay the same. These
                                      levels assume a sedentary occupation (office job), so
                                      you can bump up your activity levels if your are more
                                      physically active at work.  However, in most cases,
                                      it is better to be conservative in your estimate."),
                                    p("3. Estimate how many calories you are consuming.
                                      The general rule is for every 7700 calorie differnce between
                                      your TDEE and actual calorie consumption equals 1 kg
                                      loss in weight (or 1 lb for 3500 calorie difference"),
                                    p("4. The table and graph show the weekly changes in weight
                                      and TDEE for the parameters you have chosen.")
                                    )
                           )
          )
     )
))
