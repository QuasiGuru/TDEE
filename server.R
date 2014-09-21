library(shiny)

shinyServer(function(input, output) {
     
     # Function that take a user's current weight and given parameters
     #and returns a data frame containing week, new weight, bmr and tdee
     getWeeklyTotals <- function(week,weight) {
          if(input$sex == "male") {
               #Calculate Resting Metabolic Rate (BMR) For Males 
               bmr <- 66 + (13.7 * weight) + (5 * input$height) - (6.8 * input$age)
          } else {
               #Calculate Basic Metabolic Rate (BMR) For Females 
               bmr <- 655 + (9.6 * weight) + (1.8 * input$height) - (4.7 * input$age)
          }
          
          #Calcuate Total Daily Energy Expenditure (TDEE)
          if(input$activity == "sed") {
               tdee <- bmr * 1.2
          } else if (input$activity == "light") {
               tdee <- bmr * 1.375
          } else if (input$activity == "mod") {
               tdee <- bmr * 1.55
          } else if (input$activity == "very") {
               tdee <- bmr * 1.725
          } else {
               tdee <- bmr * 1.9
          }
          
          #Table Containing Weekly Progress
          df <- data.frame(Week=week,kg=weight,lbs=weight*2.2,BMR=bmr,TDEE=tdee)
     }
     
     #Get Form Values
     dataInput <- reactive({
          #Original Values
          df <- getWeeklyTotals(1,input$weight)
          
          #Get New Weight, and calcuate from there.
          for (i in 1:(input$weeks-1)) {
               newWeight <- df$kg[i] - ((df$TDEE[i]  - input$cals)*7)/ 7700
               df <- rbind(df,getWeeklyTotals(i+1,newWeight))
          }
          
          #Return data frame
          df
          
     })
     
     #Convert From kg to lbs
     output$pounds <- renderText({
          input$weight * 2.2
     })
     
     #Convert from cm to feet and inches
     output$inches <- renderText({
          paste(floor(input$height / 2.54 / 12), "feet", 
                floor((input$height / 2.54) %% 12), "inches", sep = " ")
     })
     
     #Table Showing Weight Progression
     output$tdee <- renderTable({
          df <- dataInput()
          df[,2:5]
     })
     
     #Plot Showing Weight Progression
     output$distPlot <- renderPlot({
          df <- dataInput()
          
          #Line Graph with Weight in kg
          if (input$measure == "met") {
               plot(df$Week,df$kg,type="l",main="Weight Loss/Gain Pattern",
                    xlab="Week", ylab="Weight(kg)",col="red",lwd="2")
          } else {
               #Line Graph with Weight in lbs
               plot(df$Week,df$lb,type="l",main="Weight Loss/Gain Pattern",
                    xlab="Week", ylab="Weight(lbs)",col="red",lwd="2")
          }
     })
})
