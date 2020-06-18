#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


# install.packages("shiny") # uncomment this to install the package
# install.packages("shinyWidgets") # uncomment this to install the package
library(shiny)
library(shinyWidgets)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Asymptotic Properties of OLS Regression Estimators"),
  
  withMathJax(),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderTextInput("n",
                      "Sample Size (n):",
                      choices = c(5, 10, 50, 100, 500, 1000, 5000, 10000),
                      selected = 5, grid = T),
      selectInput("Errors",
                  "Distribution of Error Term:",
                  choices = c("Normal" = "Normal",
                              "Non-normal" = "Non_normal"),
                  selected = "Normal"),
      selectInput("Sims",
                  "Number of Simulations (N):",
                  choices = c("1,000" = "1000",
                              "10,000" = "10000",
                              "100,000" = "100000"),
                  selected = "1000")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  tabPanel("Population Model",
                           fluidRow(
                             column(width = 12,
                                    helpText('The population regression function is 
                                             $$colGPA = \\beta_0 + \\beta_1 hsGPA + \\beta_2 SAT + u$$
                                             where the coefficients are \\(\\beta_0 = 2.0\\), 
                                             \\(\\beta_1 = 0.75\\), \\(\\beta_2 = 0.25\\),
                                             and \\(Var(u)=\\sigma^2\\).'
                                             ),
                                    p('The focus of this app is on the asymptotic properties of the OLS
                                      estimator, \\(\\hat{\\beta}_1\\), of \\(\\beta_1\\). For our purposes,
                                      "asymptotic" means "as the sample size increases." Thus, we are 
                                      investigating how taking larger samples changes the OLS estimators.
                                      Use the slider on the left to adjust the sample size and explore its
                                      effect on the sampling distribution of \\(\\hat{\\beta}_1\\).'),
                                    p('The error term, \\(u\\) in the Classical Linear Model, is assumed to be normally
                                      distributed. In this app, you may choose normal error terms (which 
                                      uses a standard normal error term) or non-normal error terms for 
                                      comparison sake. The non-normal error terms are generated from a 
                                      chi-square distribution with 1 degree of freedom, which is a very
                                      right-skewed distribution.'),
                                    p('Finally, you can adjust the number of
                                      simulations, \\(N\\). This will only affect the estimated
                                      sampling distribution in the Asymptotic Normality tab. The larger
                                      \\(N\\), the more simulations (this is like the number of hypothetical
                                      samples you have taken). This gives you a more accurate sense of the 
                                      true sampling distribution, but also takes more time. Using the default
                                      of 1,000 should be fine for illustrative purposes.')
                                    )
                             )
                           ),
                  tabPanel("Consistency", 
                           fluidRow(
                             column(width = 12,
                                    h2("Consistency of \\(\\hat{\\beta}_1\\)",align = "center"),
                                    plotOutput("consistent"),
                                    helpText('The OLS estimator, \\(\\hat{\\beta_1}\\), is a consistent estimator
                                             of \\(\\beta_1 = 0.75\\). This means that 
                                             $$ P(|\\hat{\\beta}_1 - \\beta_1|>\\epsilon)\\to 0 \\quad 
                                             \\text{as}\\ n\\to\\infty$$ for every \\(\\epsilon > 0\\).
                                             Practically, this means the probability of some difference, or gap,
                                             between \\(\\hat{\\beta}_1\\) and \\(\\beta_1\\) gets closer and 
                                             closer to 0 for larger and larger samples. Put simply, this property
                                             means that increasing the sample size (gathering more data) 
                                             actually increases the probability of the OLS estimator being
                                             "correct." You can see this illustrated in the plot above. As you
                                             increase \\(n\\), the sampling distribution (the distribution of 
                                             possible values of \\(\\hat{\\beta}_1\\)) should collapse around 
                                             the value of \\(\\beta_1\\), which in this case is 0.75. As this
                                             distribution becomes more narrowly centered around \\(\\beta_1\\),
                                             there is less and less probability of observing estimates far
                                             from the true value, 0.75.')
                                    )
                             )
                           ),
                  tabPanel("Asymptotic Normality", 
                           fluidRow(
                             column(width = 12,
                                    h2("Asymptotic Normality of \\(\\hat{\\beta}_1\\)",align = "center"),
                                    plotOutput("normal"),
                                    helpText('The OLS estimator, \\(\\hat{\\beta_1}\\), asymptotically follows
                                             a normal distribution. Mathematically, 
                                             $$\\sqrt{n}(\\hat{\\beta}_1-\\beta_1)\\sim N(0,\\sigma^2/a_j^2)$$
                                             or, equivalently,
                                             $$\\sqrt{n}\\hat{\\beta}_1\\sim N(\\beta_1,\\sigma^2/a_j^2)$$
                                             as \\(n\\to\\infty\\), where \\(a_j^2\\) is some positive constant
                                             that represents the asymptotic variance.
                                             This means that the sampling distribution of
                                             \\(\\hat{\\beta}_1\\) should look more and more like a normal 
                                             distribution for larger and larger samples (as \\(n\\) gets bigger).
                                             We know that under the CLM, the error term follows a normal
                                             distribution, which also implies that \\(\\hat{\\beta}_1\\)
                                             is normally distributed, regardless of the sample size. But if
                                             the error term is non-normal, this is no longer guaranteed.
                                             Asymptotic normality is important because even if the error
                                             term is non-normal, as long as \\(n\\) is large, 
                                             \\(\\hat{\\beta}_1\\) is normally distributed.'),
                                    p('In the simulation shown above, the solid line represents a true normal
                                      distribution and the dashed line represents the sampling distribution
                                      of \\(\\hat{\\beta}_1\\). You should notice that when the error term is
                                      normal, the sampling distribution is also normal for any sample size.
                                      But when the error term is non-normal, the sampling distribution is only
                                      normal if the sample size is large.')
                                             
                                    )
                             )
                           ) #,
                  # tabPanel("Asymptotic Efficiency",
                  #          fluidRow(
                  #            column(width = 12,
                  #                   h2("Asymptotic Efficiency of \\(\\hat{\\beta}_1\\)",align = "center"),
                  #                   p("Here's a bunch of blababadablbabadeeblablabadeeblabadeeblabad")
                  #                   )
                  #            )
                  #          )
      )
    )
  )
))
