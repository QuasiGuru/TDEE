library(shiny)

shinyServer(function(input, output) {
     
     getWeeklyTotals <- function(week,weight) {
          if(input$sex == "male") {
               #Calculate Resting Metabolic Rate (RMR) For Males 
               if (input$age <= 3) {
                    rmr <- 60.9 * weight - 54
               } else if (input$age <= 10) {
                    rmr <- 22.7 * weight + 495
               } else if (input$age <= 18) {
                    rmr <- 17.5 * weight + 651
               } else if (input$age <= 30) {
                    rmr <- 15.3 * weight + 679
               } else if (input$age <= 60) {
                    rmr <- 11.6 * weight + 879
               } else {
                    rmr <- 13.5 * weight + 487
               }
               
               #Calculate Thermic Effect Of Exercise (TEE) For Males
               if (input$activity == "sed") {
                    tee <- rmr * 0.3
               } else if (input$activity == "light") {
                    tee <- rmr * 0.6
               } else if (input$activity == "mod") {
                    tee <- rmr * 0.7
               } else if (input$activity == "very") {
                    tee <- rmr * 1.1
               } else {
                    tee <- rmr * 1.4
               }
          } else {
               #Calculate Resting Metabolic Rate (RMR) For Females 
               if (input$age <= 3) {
                    rmr <- 61 * weight - 51
               } else if (input$age <= 10) {
                    rmr <- 22.5 * weight + 499
               } else if (input$age <= 18) {
                    rmr <- 12.2 * weight + 746
               } else if (input$age <= 30) {
                    rmr <- 14.7 * weight + 496
               } else if (input$age <= 60) {
                    rmr <- 8.7 * weight + 829
               } else {
                    rmr <- 10.5 * weight + 596
               }
               
               #Calculate Thermic Effect Of Exercise (TEE) For Females
               if (input$activity == "sed") {
                    tee <- rmr * 0.3
               } else if (input$activity == "light") {
                    tee <- rmr * 0.5
               } else if (input$activity == "mod") {
                    tee <- rmr * 0.6
               } else if (input$activity == "very") {
                    tee <- rmr * 0.9
               } else {
                    tee <- rmr * 1.2
               }
          }
          
          #Calcuate Total Daily Caloric Expenditure (TDEE)
          tdee <- (rmr + tee) * 0.1 + rmr + tee
          
          #Table Containing Weekly Progress
          df <- data.frame(Week=week,kg=weight,lb=weight*2.2,RMR=rmr,TEE=tee,
                           TEF=(rmr+tee) * 0.10,TDEE=tdee)
     }
     
     dataInput <- reactive({
          df <- getWeeklyTotals(1,input$weight)
          calConsumed <- 2000
          
          for (i in 1:input$weeks) {
               newWeight <- df$kg[i] - ((df$TDEE[i]  - input$cals)*7)/ 7700
               df <- rbind(df,getWeeklyTotals(i+1,newWeight))
          }
          
          
          df
          
     })
     
     output$pounds <- renderText({
          input$weight * 2.2
     })
     
     output$tdee <- renderTable({
          df <- dataInput()
          df[,2:7]
     })
     
     
     output$distPlot <- renderPlot({
          df <- dataInput()
          if (input$measure == "met") {
               plot(df$Week,df$kg,type="l")
          } else {
               plot(df$Week,df$lb,type="l")
          }
     })
})
