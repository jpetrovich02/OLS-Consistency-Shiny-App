#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

b0 <- 2.0 # intercept coefficient
b1 <- 0.75 # slope coefficient of hsGPA
b2 <- 0.25 # slope coefficient of SAT


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  simulation <- reactive({
    set.seed(123)
    
    N <- as.numeric(input$Sims)
    Normal = input$Errors == "Normal"
    n = input$n # sample size
    if(Normal){
      sigma <- 1 # error sd (square root of error variance)
    }else{ # chi-square errors
      df <- 1
      sigma <- sqrt(2*df)
      mu <- df
    }
    
    # Generate observed values of SAT and hsGPA
    SAT <- sample(x = seq(from = 400,to = 1600,by = 10),size = n,replace = T)
    hsGPA <- rnorm(n = n,mean = 3.0,sd = 0.3)
    X <- matrix(cbind(rep(1,n),hsGPA,SAT),nrow = n,ncol = 3)
    
    # Create an "empty" vector to store estimates for each sample
    b1hat <- numeric(N) # vector of N 0s (placeholders)
    b2hat <- numeric(N) # vector of N 0s (placeholders)
    
    # Generate u and y for each sample and estimate regression model
    for(i in 1:N){
      if(Normal){
        u <- rnorm(n = n,mean = 0,sd = sigma) # simulate errors from a normal distribution
      }else{
        u <- rchisq(n = n,df = df) - mu # simulate errors from a chi-sq. dist. then center
      }
      y <- b0 + b1*hsGPA + b2*SAT + u # observed y values
      
      estlm <- lm(y ~ hsGPA + SAT) # estimate mlr model
      b1hat[i] <- coef(estlm)["hsGPA"]
      b2hat[i] <- coef(estlm)["SAT"]
    }
    
    # Plot
    # par(mfrow = c(1,2)) # Place two plots on one line
    Q <- solve(t(X)%*%X)
    sdbhat1 <- sigma*sqrt(Q[2,2])
    
    out <- list(n= n,
                sdbhat1 = sdbhat1,
                b1hat = b1hat)
    out
  })
   
  output$consistent <- renderPlot({
    m <- 3 # multiplier to determine width of plot
    xlim <- c(b1 - 3*m,b1 + 3*m)
    sdbhat1 <- simulation()$sdbhat1
    n <- simulation()$n
    xticks <- seq(from = -8,to =8,by = 4) + 0.75
    
    curve(dnorm(x,b1,sdbhat1),
          from = b1-3*sdbhat1,
          to = b1+3*sdbhat1,
          main = bquote(atop("Sampling Distribution of" ~ hat(beta)[1],
                             "n = " ~ .(n))),
          xlab = expression(hat(beta)[1]),
          ylab = "Density",
          xlim = xlim,
          xaxt = 'n')
    axis(1, at=xticks, labels=xticks)
    # lines(density(b1hat),lty = 2)
    abline(v = b1)
  })
  
  output$normal <- renderPlot({
    sdbhat1 <- simulation()$sdbhat1
    n <- simulation()$n
    b1hat <- simulation()$b1hat
    xticks <- seq(from = -8,to =8,by = 4) + 0.75
    
    plot(density(b1hat),
         lty = 2,
         main = bquote(atop("Sampling Distribution of" ~ hat(beta)[1],
                            "n = " ~ .(n))),
         xlab = expression(hat(beta)[1]),
         ylab = "Density",
         xaxt = "n")
    axis(1, at = xticks, labels = xticks)
    curve(dnorm(x,b1,sdbhat1),
          from = b1-3*sdbhat1,
          to = b1+3*sdbhat1,
          add = T)
    # lines(density(b1hat),lty = 2)
    abline(v = b1)
  })
  
})
