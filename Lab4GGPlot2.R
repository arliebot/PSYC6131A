## Lab 4: Advanced Plotting
# We have generated graphics with base R functions. 
# Hadley Wickham's package `ggplot2` offers more options.  

# Install and load these packages:
install.packages("ggplot2", dep=T)
library(ggplot2)
install.packages("GGally")
library(GGally)

# Download this data:
dat <- read.csv("exerciseDat.csv")

## Today's Plan 
# 1) Introduce ggplot2  
# 2) Language  
# 3) Data  
# 4) Basic Geoms with `qplot()`  
# 5) `GGally` and `ggpairs`  
# 6) `ggplot2` Proper

## Getting started with ggplot2
# install.packages("ggplot2", dep=T)
# library(ggplot2)
# setwd("~/Desktop/TA/2016:2017/Green/Labs/Lab4")

# `qplot()` is a convenience function in `ggplot2` that 
# stands for *quick* plot.  
# The primary arguments for `qplot()` are:  
  # * `x` - values we want on the x-axis  
  # * `y` - values we want on the y-axis 
  # (not necessary, depending on plot)  
  # * `data` - dataset  
  # * `geom` - geometric object to use 
  # ("point" if x and y are given, "histogram" if not)  


## Get our data
# We're going to be using two new datasets created by 
# Carrie Smith and Matthew Sigal from the quantitative 
# methods program. It's made up data on memory.

dat <- read.csv("exerciseDat.csv", header=TRUE, 
                stringsAsFactors=FALSE)
head(dat)
dat$gender <- factor(dat$gender, 
                     levels = c(0,1), 
                     labels = c("Female", "Male"))
dat$group <- factor(dat$group, 
                    levels = c("cram", "mnemonic", "none"), 
                    labels = c("cram", "mnemonic", "none"))
dat$pass <- factor(dat$pass, 
                   levels = c(0,1), 
                   labels = c("Fail", "Pass"))


## Histogram
qplot(score1, data = dat, geom = "histogram")
# Gives a warning because binwidth is being automatically selected
qplot(score1, data = dat, geom = "histogram", bins = 15)
qplot(score1, data = dat, geom = "histogram", bins = 50)

## Scatterplot
qplot(score1, score2, data = dat, geom = "point")


## More Options
# **Graphic Manipulation**:
  # * `xlim` and `ylim`: define limits for x and y axis
  # * e.g., xlim = c(0, 100)
  # * `bins` when creating histograms
  # * `log`: log transform any of the variables
     # * Can be x, y, or xy for both
     # * However, I usually prefer to transform my variables myself
     # * e.g., `dat$score1.log <- log(dat$score1)`

## More Options
# **Graphic Manipulation**:
  
  # * `main`, `xlab`, and `ylab`: title sections of graphic
  # * `colour`, `size`: Differentiate points by grouping variable
  # * `facets`: Create separate plots by grouping variable
    # * e.g., one variable: facets = ~ gender
    # * e.g., two variables: factets = group ~ gender
  # * `theme`: allows other customizations
  # * try adding `+ theme_bw()` for black and white graphics
  # * see [this link](http://docs.ggplot2.org/current/theme.html) for additional details

qplot(score1, score2, data = dat, colour = gender,
      facets = ~ group, main = "Scores by Group and Gender",
      xlab = "Score on Test 1", ylab = "Score on Test 2")


## Other Geoms
# There are many different geoms we can plot. 
# See a list here: http://docs.ggplot2.org/current/

## Bargaphs
qplot(gender, data = dat, geom = "bar", 
      ylab = "Sample Size") + theme_bw()


## Boxplots
qplot(group, score1, data = dat, geom="boxplot")


## Boxplots with Jitter
qplot(group, score1, data = dat, geom=c("boxplot", "jitter"))


## Boxplot with stat_summary
# You can summarize y values at every unique x using `stat_summary`.  
# For more information see: 
# http://docs.ggplot2.org/current/stat_summary.html

qplot(group, score1, data=dat, geom = 'boxplot') + 
  stat_summary(fun.y=mean, colour="red", size=5, geom="point")
# Try median, min, max...


## Scatterplot with Regression Line
qplot(score1, score2, data = dat, geom = "point",
      main = "Score 1 by Score 2 with Regression Line") + 
  stat_smooth(method = "lm")


## Scatterplot Matrix
# We can plot several combinations at once in a correlation matrix 
# with the function `ggpairs` in the package `GGally`

# install.packages("GGally")

## Scatterplot Matrix
library(GGally)
ggpairs(na.omit(dat[c(3,4,6,7)])) # all continuous variables

# This function works on practically all variable types!
ggpairs(na.omit(dat[2:5]))  # continuous + categorical

# * gender (factor)
# * mathPre (numeric)
# * readPre (numeric)
# * group (factor)


## ggplot2 Proper
# `qplot()` is a simple function for learning the `ggplot2` basics. 
# There are other functions.

# General Principals for `ggplot2`:
# Functions:
  
# 1. Define the data you want to plot and create a plot template 
#    with `ggplot()`
# 2. Specify the aesthetics of the shapes that will be used to 
#    represet the data with `aes()`
# 3. Specify the graphical shapes (`geoms`) that will be used to 
#    view the data
#    * Add them with the appropriate function; 
#      e.g. `geom_point()` or `geom_line()`
# 4. Call the object to render and view it

## General Principals for `ggplot2`
# Terminology

# * One or more `Layers` consisting of:
  #  * `Data`: What we want to see!
  #  * `Mapping`: Defines the aesthetics of the graphic
# * `Stat`: Statistical transformations of the data (e.g., binning or averaging)
# * `Geom`: Geometric objects that are drawn to represent the data (simple or complex)
# * `Position`: Position adjustments for each geom (e.g., jitter, dodge, stack)
# * `Scale`: Controls mapping between data and aesthetics (variable or constant; colour/position) 
# * `Themes`: Relatively new `ggplot2` feature that allows for visual adjustments of a plot object 
# * `Coord`: The coordinate system (provides axes and gridlines)
# * `Facet`: Allows us to break up the data into subsets

## Layer Functions Like Photoshop
# `ggplot2` object is your canvas and each funciton is another layer. 
# Add them onto a plot with the **+** sign 
# (which has to be at the end of the line, 
# not the start of the next line).

## Building a grouped scatterplot:
dat <- iris
head(dat)
p1 <- ggplot(data = dat, 
             aes(x = Sepal.Length, 
                 y = Sepal.Width, 
                 colour = Species)) +
  geom_point()
p1



## List of Available Customizations
# All of the geoms, stats, scales, coordinate systems, 
# and faceting options (and more!) are listed at:
# http://docs.ggplot2.org/current/
  
## Some cool R Scripts to try:  
# http://rvisualization.com/r-scripts/
  

## Homework
# 1) Try making `ggplot2` graphics with our class dataset.  
# 2) Look at the `iris` dataset and try plotting different variables.

