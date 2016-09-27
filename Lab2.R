### Week 2: Plotting the Data ###

# Always look at the data before running your analysis!
# Data is beautiful: https://www.reddit.com/r/dataisbeautiful   

# Most statistical analyses have assumptions
# (normality, homogeneity of variance, missingness, etc...)
# and visualizing helps identify issues 
# so you can choose the appropriate analysis.



## This Week's Plan: Plotting Basics!

# - Histogram
# - Stem-and-leaf
# - Pie chart
# - Barplot (including stacked)
# - Boxplot(s)
# - Scatterplot (with a linear trend, and with a lowess trend)



## Histogram

# Create a variable x and use the hist() function.
x <- c(0,0,0,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,5,5,6)
hist(x)

# To add titles 
hist(x, main="Title of Histogram", xlab="X Axis Title", 
     ylab="Y Axis Title") # Y axis is frequency

## We can also create a histogram for .csv files

# Set working directory
setwd("~/Desktop/TA/2016:2017/Green/Labs/Lab2") 

# Read in the data
dat <- read.csv("data.csv", header=TRUE)
head(dat)

# Histogram for variable "sports" within the dataset "dat"
hist(dat$sports)
hist(dat$sports, main = "Histogram of Sports", xlab = "Sports")



## Stem and Leaf

# These can be very useful to quickly see the shape of your data.
stem(x)

z <- c(1,1,2,2,2,2,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,5,6,6,6,6,6,7,7,7,7,8,8,8,8,9,9,10,11,11,11,12,12)
stem(z)

# Stem and leaf for our dataset
stem(dat$height)



## Pie Chart

# Pie charts get a bad rap (for good reason, they are difficult to read)
pie(x) # this isn't going to work, it needs quantities
freqx <- table(x)
pie(freqx)

# Pie chart for given frequencies
w <- c(5,20,25,50)
pie(w)

# Pie chart for given frequencies with labels
y <- c(25, 25, 25, 25)
z <- c("Group1", "Group2", "Group3", "Group4")
pie(y, labels = z, main = "Pie Chart")   


## Pie charts with our data.csv
# Get variable and create a frequency table
sp_dat <- table(dat$sports)  
sp_dat
z2 <- c("Roller Derby", "Hockey", "Soccer", 
        "Bouldering", "Swimming", "Skiing",
        "Rugby", "Cricket", "Baseball", "Sailing")
pie(sp_dat, labels = z2, main = "Sports Pie Chart") 


## Waffle charts are better

install.packages("waffle")
library("waffle")
waffle(y) # Isn't that pretty and easy to read?



## Barplots

# Barplots are for categorical data

barplot(table(x))
barplot(table(x), col="blue", main="Barplot for X", 
        xlab="X Title", ylab="Y Title")


## Try barplots with our data using "sports"

sportstable <- table(dat$sports) # get frequencies
barplot(sp_dat, names.arg = z2, main = "Barplot of Sports", 
        ylab = "Frequency")



## Stacked Barplot

# This shows the # of people in each sport separated by sex.

stackdat <- table(dat$sports, dat$sex)
barplot(stackdat, 
        col=c("red","orange","yellow","green","blue","purple"))



## Boxplots

# Boxplots are for continuous data

boxplot(y) # y <- c(5, 25, 30, 60)
# They aren't effective if the data isn't spread

boxplot(x)

boxplot(x, horizontal=TRUE, main = "Boxplot of X")

# We can use boxplots to see all our data at once
boxplot(dat, main = "Boxplot of data.csv") # Sex is omitted b/c not numerical



## Scatterplots

# Plot the correlation between a and b

a <- c(1,1,1,1,1,1,2,2,2,2,3,3,3,3,3,3,4,4,4,5,5,6)
b <- c(2,2,3,4,4,5,4,5,5,5,6,5,4,4,3,4,3,2,3,3,2,1)

plot(a,b)

c <- c(1,2,2,1)
d <- c(2,2,1,1)
plot(c,d)

# To get a visual correlation matrix for all variables
plot(dat)

# Select two groups from the data to plot
plot(dat$height, dat$sports, main="Scatterplot Height Sports")
# These seem unrelated

# The two IQ variables have a higher correlation
plot(dat$iq1, dat$iq2, main="Scatterplot Height Sports")


## Scatterplot with Regression Line

# Linear trend line
plot(dat$iq1, dat$iq2) # plot(x,y)
abline(lm(dat$iq2~dat$iq1)) # lm puts y first

## Scatterplot with Lowess Trend for data.csv variables
plot(dat$iq1, dat$iq2)
lines(lowess(dat$iq1,dat$iq2), col="red") 

# Make up data to plot
n <- 100
v <- seq(n) # seq() Generates a sequence of values of n size
u <- rnorm(n, 0, 1) # rnorm(n,mean=0,sd=1) Generates random normal data
Data <- data.frame(v, u) # combine into data.frame
plot(u ~ v, Data) # plot

# fit a loess line for generated data
loess_fit <- loess(u ~ v, Data)
lines(Data$v, predict(loess_fit), col = "blue")


# Scatterplot with both lines
plot(dat$iq1, dat$iq2, main = "Scatterplot of IQ1 and IQ2",
     xlab = "IQ1", ylab = "IQ2")
abline(lm(dat$iq2~dat$iq1), col = "blue")
lines(lowess(dat$iq1,dat$iq2), col="red") 



## Homework

# 1) Create 2 continuous interval-level variables 
# 2) Create 2 categorical-level factors with 2 and 4 levels
# 3) Combine the 4 variables into a data.frame and name it
# 4) Add column names "A", "B", "C", "D"
# 5) Find the frequency of "A" for factor "C" using table()
#    name it freqAC
# 6) Plot the frequencies using plot(freqAC)
# 7) Find the frequency of "C" for factor "D" using table()
# 8) Plot using a split barplot
# 9) Create a scatterplot of A and B
# 10) Rejoice in the knowledge that you can code in R!





### Answers to homework. No cheating!!! Try it on your own first :)

A <- c(1, 1.2, 1.1, 1.3, 1.4, 2.2, 2, 2, 2, 1.5, 1.5, 2.1)
B <- c(2, 2.2, 2.3, 2.22, 2.4, 2.5, 2.6, 2.1, 2.7, 3, 3.1, 3.3)
C <- factor(c(1,2,1,2,1,2,2,1,2,2,1,1))
D <- factor(c(1,2,3,4,4,3,2,1,4,3,2,1))

dataframe <- data.frame(A,B,C,D)
dataframe

colnames(dataframe) <- c("Memory","Happiness", "Coffee", "Order")
dataframe

freqAC <- table(A,C)
plot(freqAC)

freqCD <- table(C,D)
barplot(freqCD)

plot(A,B)
abline(lm(B~A))
