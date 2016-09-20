## Let's get started coding!

# We write code in the `Script Editor` and Save file
# Code that begins with a # is treated as a comment and is not `run`
# or `Returned` to the `Console`

# Lab 1 Plan:

# - Type data into variables
# - Basic arithmetic (with constants and variables)
# - Creating vectors
# - Binding columns and rows into a matrix or dataframe
# - Naming columns and rows of a matrix
# - Reading and writing .csv datasets

## Topic 1: Creating Variables

# We create `variables` by typing them into the `Script Editor`.
# Let's create a `variable` called x

x <- c(1,2,3,4,5)

# Call x by clicking `Run` or by pressing `Command` and `Return`.  

x

# So what happens when we `Run` x?
# The variable x is saved in the R Workspace 
# and will exist until it is deleted (or R is restarted). 
# x is a variable of type `numeric` ranging in length from 1 to 5

# We can rename x

cups_of_coffee <- x

# Let's make another variable for y

y <- c(2,4,6,8,10)

# You can check the contents of the Workspace with the ls() function.

ls()

## Topic 2: Basic Arithmetic

# What if you want to use R to calculate a grade for a student you TA. 
# Say the student got 18/25 on the first test
# 20/25 on the second test
# and 22/25 on the third test. 
# They want to know what they need on the final /25 
# to get an A (85%) in the course.

total <- (18+20+22) # create y to sum scores
total               # call y
85-total            # subtract y from desired score
# run it            # returned value for grade required /25 for 85% final

# You can tell the student that they will need to get a perfect score
# on the final to get that coveted 85% final grade


## Addition + Subtraction - Multiplication * Division / Exponent ^
  
1+1 
2-1
3*2
4/2
2^2


## PEDMAS 

# R will figure out the order of operations for you!
  
(1+2)*3/4^3

# And you can do arithmetic to vectors

x <- c(1,2,3,4,5)
z <- x^2 # x squared
z

## Adding a constant

# You can add a constant to a vector easily by adding the constant 5
# to the variable x. Remember x <- c(1,2,3,4,5)

x
x+5

## QUICK SAVE!

# Sometimes R and RStudio crash, so make sure you save frequently.  

# You can save by pressing `Command` and `s` 
# or by clicking `File` then `Save`
  

## Creating vectors

# Vectors are a sequence of data of the same numerical type. 
# Remember: Nominal, Ordinal, Interval, Ratio? 
# Data in a vector must all be of the same kind.

Nominal <- factor(c("Arlie", "Matthew", "Huxley", "Lulu", "Mya"))  

Ordinal <- ordered(c("1st", "2nd", "3rd", "4th", "5th"))  
# R orders the list alphabetically by default

Ordinal_2 <- ordered(c("First", "Second", "Third"))
# Observe levels in Environment

Ordinal_3 <- ordered(c("First", "Second", "Third"), 
levels = c("First", "Second", "Third"))
# So you can specify the level order by adding ", levels = c("","") 

Interval <- c(0, 1, 2, 3, 4, 5)

Ratio <- c(1, 1.5, 2, 5, 5.5, 7)

# This is not a vector! Who can tell me why?

wrong <- c("Arlie", 1, 2.111111111111119, "Blue")
# Because one value is of type `character` R classifies `wrong` as 
# `character` class.


## Storing Data as a Matrix

# We can combine vectors of the same size and data type into a matrix.

matrix <- matrix(data = c(x,y,z), 
                   nrow = 5, ncol = 3)
                   
matrix

# We can also create a data set to combine into a matrix

matrix_2 <- matrix(data = c(-5,2,7,1,2,3,3,6,-4), 
                 nrow = 3, ncol = 3)
matrix_2


## Binding columns and rows

# Add columns and rows to a matrix using rbind and cbind

w <- c(1,2,3)       # Create new vector w

rbind(matrix_2,w)   # Bind w to matrix_2 as new row

cbind(matrix_2,w)   # Bind w to matrix_2 as new column



## Binding columns and rows into a data frame

# We can combine vectors of the same size but different data types 
# into a data frame.

n <- c(2, 3, 5) 
s <- c("aa", "bb", "cc") 
b <- c(TRUE, FALSE, TRUE) 

dataframe <- data.frame(n, s, b)       
dataframe


## Naming columns and rows of a matrix

colnames(matrix_2) <- c("X","Y","Z")
matrix_2

rownames(matrix_2) <- c("A","B","C")
matrix_2


## Reading and writing .csv datasets

# There are all kinds of great free datasets available for you to play around with!
# These are all already built into R in the datasets package!
# https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/00Index.html
# Historical datasets are available here:  
# https://cran.r-project.org/web/packages/HistData/index.html

# If the dataset is built in to R, 
# you just need to know it's name to call it.

data(cars)
cars

# Can you find the `cars` data set in your environment?
# How many variables are there?
# How many observations are there?
# What happens if you click the triangle?
# What happens if you click the word cars?


## Opening Your Own Data in RStudio

# 1) Save data as .csv in Excel
# 2) Put the data in the same folder you saved your RScript
#    - download the class file data.csv
#    - save it to desired folder
# 3) Set that folder as your working directory
#    - Click `Files` 
#    - Navigate to the folder you want
#    - Click `More` 
#    - Click `Set as Working Directory`
# 4) read.csv

## read.csv

mydata <- read.csv("data.csv")
mydata

## Dataset FAQ 
# 1) If you open RStudio by double clicking on the RScript.R file, 
# RStudio will automatically set that folder to be the working directory

# 2) If you haven't included a row of variable names in the dataset, 
# you'll want to add this:

mydata_2 <- read.csv("data.csv", header = FALSE)
mydata_2


## HELP!

# I got an **Error!** Or I forgot what that function was called. 
# What do I do now? 
# You can use the R Studio **Help** tab to search for key words. 
# Or you can use ? and ?? in the R Script Editor.  

# ? will search for an exact match to what you type in any loaded packages  

# ?? will search for a similar match across all packages installed locally

?t.test
?ttest
??ttest


## Homework

# 1) Install R and RStudio on your personal computer (if you aren't going to be using the ones in Hebb)
# 2) Practice making vectors and doing some basic math (use fictional data)
#    - Create a vector for the number of cups of coffee you drink each day
#    - Create a vector for typical number of hours of sleep
#    - Add a constant to cups of coffee and rename it coffee_plus1
#    - Sum cups of coffee for a total coffee score
# 3) Try loading your dataset (or one from one of the links I provided)
#    - What is your default working directory?
#    - How are variables coded in the environment?
#    - Can you see your data set in RStudio if you click on it?
# 4) Try installing the "fortunes" package from CRAN, load the library, and run fortune()
# 5) What happens if you overwrite a variable? Create new values for y.


## FIN

email me your questions: arliebelliveau@gmail.com