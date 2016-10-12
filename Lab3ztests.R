## This Week's Plan: Using data.csv

# 1) Binomial Distribution
# 2) Normal Distribution
# 3) Confidence Intervals

# 4) Z-test
# a) Plot
# b) Confidence Intervals
# c) P Values
# d) Effect Size
# e) Power

# 5) Single Sample t-test
# a) Plot
# b) Effect Size
# c) Power

# 6) Matched/Paired Sample t-test
# a) Plot
# b) Effect Size
# c) Power

# 7) Independent Sample t-test
# a) Plot
# b) Effect Size
# c) Power
# d) Homogeneity of Variance


## 1) Binomial Distribution

# Create variable x as sequence of values
# ranging from 0 to 20 with intervals of 1

x <- seq(0, 20, 1) 
x 

# plot(x,y) where y is a density binomial
# dbinom(x, size, prob, log = FALSE)

plot(x = x, y = dbinom(x, 20, 0.5)) # Density
plot(x = x, y = pbinom(x, 20, 0.5)) # Cumulative probability
plot(x = x, y = rbinom(x, 20, 0.5)) # Random



## 2) The Normal Distribution

# Create variable x as a sequence of values
# ranging from -3 to +3 with 0.1 intervals

x <- seq(-3, 3, 0.1) 

# plot(x,y) where y is the density of the normal distribution 
# with mean = 0, standard deviation = 1, type = line
# dnorm (x, mean = 0, sd = 1, log = FALSE)

plot(x = x, y = dnorm(x, mean = 0, sd = 1), type = 'l', 
     ylab = "Density", xlab = "X", main = "Normal Curve")




## 3) Confidence Intervals

mu <- 0
sd <- 1
n <- 200
error <- qnorm(0.975) * sd / sqrt(n) # qnorm is quantile function
# qnorm default is for mu = 0 and sd = 1, two-tailed
# So we use 0.975 to split the alpha of 0.05 to two sides for a 
# two-tailed test

left <- mu - error
right <- mu + error
left # This gives the lower bound value of the CI
right # This gives the upper bound value of the CI


# Plot 95% CI on the Normal Curve

x <- seq(-3, 3, 0.1) 
plot(x = x, y = dnorm(x, mean = 0, sd = 1), type = 'l', 
     ylab = "Density", xlab = "X", main = "Normal Curve")
abline(v = 1.96, col = "red") # Confidence Intervals
abline(v = -1.96, col = "red")




## 4) Z-test on Height Data

# setwd("~/Desktop/TA/2016:2017/Green/Labs/Lab3")
dat <- read.csv("data.csv")
head(dat)

# Use library() to open the `psych` package, 
# which contains useful functions for psychologists

library(psych)
describe(dat$height)

# Z-test
# There is no function in R for z
# so we have to write out the computation ourselves

# Research question: Does a single height score of 180 
# differ significantly from the population in our dataset?

X = 180
Mu = 173.86
Stdev = 12.59
N = 100
SqrtN = sqrt(N)

z <- (X - Mu) / (Stdev / SqrtN) 
z

# Confidence Interval for Z dat$height

Mu <- 173.86
Stdev <- 12.59
N <- 100
error <- qnorm(0.975) * Stdev / sqrt(N)
error
left <- Mu - error
right <- Mu + error
left
right



# P Value for Z

# Use pnorm to get distribution function
# pnorm(q, mean = 0, sd = 1)
# pnorm() yields probability for normal distribution at given quantile

pvalue2sided <- 2 * pnorm(-abs (z)) # 2-tailed
pvalue2sided

# The probability of a z score of 4.876886 
# or further from the mean is < 0.001, alpha = 0.05, two-tailed

pvalue1sided <- pnorm(-abs (z)) # 1-tailed
pvalue1sided


# Effect Size for Z using Cohen's d

dz <- (180 - 173.86) / 12.59 
dz

# d = 0.487 is a medium effect size


# Power Z

install.packages("pwr")
library(pwr)
pwr.norm.test(d = .487,
              n = 100,
              sig.level = 0.05,
              alternative = "two.sided")

# We have 0.998 power in this test.
# Therefore, we can conclude that the height of 180 was
# significantly different from our population mean height.



## 5) Single Sample t-test

# Let's reimagine the height data as sample not population.
# Do our sample heights differ from the made-up national average 
# of 180?

t.test (dat$height, mu = 180) # this is in base R


# Effect Size Single Sample t-test

t <- -4.876
df <- 99

r = sqrt( ( t^2 ) / ( ( t^2 ) + ( df * 1) ) )
r
r^2

# 19.36% of variance is accounted for

M <- 173.86
mu <- 180
Stdev <- 12.59
d = (M-mu)/Stdev
d

# This is a medium effect size


# Power Single Sample t-test

pwr.t.test(d = .488,
           n = 100,
           sig.level = 0.05,
           type = "one.sample",
           alternative = "two.sided")


# Confidence Interval for Single Sample t-test

M <- 173.86
tCritical <- 1.984 # Look it up
Stdev <- 12.59
n <- 100

M + tCritical * Stdev / sqrt(n)
M - tCritical * Stdev / sqrt(n)


## 6) Matched/Paired Sample t-test

# Plots
# How Related is the Data? 

plot(dat$iq1, dat$iq2)
abline(lm(dat$iq2 ~ dat$iq1))

# Plot the Differences

dat$diff <- (dat$iq1 - dat$iq2)
boxplot(dat$diff) # Median is close to zero


# Run the Paired/Matched t-test

t.test(dat$iq1, dat$iq2, paired=TRUE)


# Effect Size Paired/Matched t-test using Cohen's d

diff <- dat$iq2 - dat$iq1
diff
sdiff <- sd(diff) # sd is base R
mdiff <- mean(diff) # mean is base R
d <- mdiff/sdiff
d

# This is a small effect size


# Power Paired/Matched Sample t-test

pwr.t.test(d = .127,
           n = 100,
           sig.level = 0.05,
           type = "paired",
           alternative = "two.sided")



## 7) Independent Sample t-test

# Plot the data with a cool plot
install.packages("ggplot2")
library(ggplot2)
qplot(dat$sex, dat$height, data=dat, geom="boxplot")+
  xlab("Sex")+
  ylab("Difference Scores")+
  stat_summary(fun.y=mean, colour="red", size=5, geom="point")


# Independent Sample t-test
t.test(height~sex, data=dat, var.equal=FALSE) 

# var.equal=F supresses the Welch Correction, which is the default

# Homogeneity of Variance for Independent Sample t-test
# (Welch-Satterthwaite)

t.test(height~sex, data=dat, var.equal=TRUE) 


# Effect Size for Independent Sample t-test using Cohen's d

fheight <- dat$height[dat$sex=="f"]
mheight <- dat$height[dat$sex=="m"]

mf <- mean(fheight)
mm <- mean(mheight)

sf <- sd(fheight)
sm <- sd(mheight)
sp <- sqrt((sf^2 + sm^2) / 2) # pooled standard deviation

d <- (mf - mm) / sp
d


# Power for Independent Sample t-test

pwr.t.test(d = 1.485,
           n = 50,
           sig.level = 0.05,
           type = "two.sample",
           alternative = "two.sided")


## Homework:

# 1) What happens if you change the probability of our
#    binomoial density plot to 0.75?
# 2) What happens if we change it's size to 5, 10, & 15?
# 3) What happens if you change the intervals in the x sequence
#    for the normal distirbution to 0.5?
# 4) What happens if you change type from 'l' to 'p'
#    for the normal distribution?
# 5) What quantile would you use in qnorm() to get a one-tailed test?
# 6) Calculate a single sample z-test using dat$iq1 
#    and Fabiola Mann's IQ x=162. What is the effect size?
# 7) Calculate a single sample t-test using dat$iq1 and Mu=100
# 8) Imagine our participants all joined kettlebell class! 
#    Create a new variable called weight2 by adding a constant 
#    of 2 to each score. Use cbind() to add the new variable to data.csv
# 9) Run a paired t-test on their before weight and after weight2
#10) Run an independent sample t-test comparing men and women's 
#    sports interest for our made-up data.csv dataset.


# Try running these tests with the rat data or with data you make up