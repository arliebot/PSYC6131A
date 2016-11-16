## A priori and post-hoc pairwise comparisons for 1-way ANOVA
# Which comparison is significant?

# Install Packages
install.packages("agricolae")
library(agricolae)

install.packages("WRS2")
library("WRS2")

install.packages("psych")
library(psych)

install.packages("GGally", dependencies = TRUE)
library(GGally)


# Get Data
# setwd("~/Desktop/TA/2016:2017/Green/Labs/Lab7")
dat.c <- read.csv("coffeedata.csv")

# Define/Rename Data

dat.c$IQ <- dat.c$IQ_adj # Rename IQ_adj to IQ to make coding easier
dat.c$IQ_adj <- NULL     # Remove IQ_adj from the dataset

dat.c$coffee <- factor(dat.c$coffee) # Specify coffee as a factor
dat.c$tea <- factor(dat.c$tea)       # Specify tea as a factor

# Look at the data
head(dat.c)
str(dat.c)

#install.packages("psych")
#library(psych)
describe(dat.c)

#install.packages("GGally")
#library(GGally)
ggpairs(dat.c)



## A priori comparisons  
# Multiple t-tests doesn't control family-wise error.
# 1−(.95^10) for 10 comparisons at 0.05 alpha 
# = 40.12% chance of type 1 error (false positives)
# This is not ideal 

t.test(IQ ~ coffee,
       data = dat.c[dat.c$coffee==1|dat.c$coffee==2,], var.equal=TRUE) 

t.test(IQ ~ coffee,
       data = dat.c[dat.c$coffee==1|dat.c$coffee==3,], var.equal=TRUE) 

t.test(IQ ~ coffee,
       data = dat.c[dat.c$coffee==1|dat.c$coffee==4,], var.equal=TRUE) 

t.test(IQ ~ coffee,
       data = dat.c[dat.c$coffee==1|dat.c$coffee==5,], var.equal=TRUE) 

t.test(IQ ~ coffee,
       data = dat.c[dat.c$coffee==2|dat.c$coffee==3,], var.equal=TRUE) 

t.test(IQ ~ coffee,
       data = dat.c[dat.c$coffee==2|dat.c$coffee==4,], var.equal=TRUE) 

t.test(IQ ~ coffee,
       data = dat.c[dat.c$coffee==2|dat.c$coffee==5,], var.equal=TRUE) 

t.test(IQ ~ coffee,
       data = dat.c[dat.c$coffee==3|dat.c$coffee==4,], var.equal=TRUE) 

t.test(IQ ~ coffee,
       data = dat.c[dat.c$coffee==3|dat.c$coffee==5,], var.equal=TRUE) 

t.test(IQ ~ coffee,
       data = dat.c[dat.c$coffee==4|dat.c$coffee==5,], var.equal=TRUE) 

### 1) Try comparing the ages of people who drink 1 cup and 2 cups of tea ###



# Bonferroni t (Dunn's test) 
# Divides alpha by the number of tests being conducted
pairwise.t.test(dat.c$IQ, dat.c$coffee, 
                p.adjust.method="bonferroni") 
# This gives us p values for all comparisons
# 3 cups vs 5 cups and 4 cups vs 5 cups are significantly different

### 2) Try running the Bonferroni test on IQ and tea ###



# Holm test
pairwise.t.test(dat.c$IQ, dat.c$coffee, 
                p.adjust.method="holm") 

# Can also do "hochberg", "hommel", "BH", "BY", "fdr", "none"

### 3) Try running the Holm test on IQ and tea ###




## Post hoc tests 
# Run post-hoc once you've found a significant ANOVA
fit1 <- aov(IQ ~ tea, data = dat.c)
summary(fit1)


## Fisher's LSD  
# install.packages("agricolae")
# library(agricolae)
# 3 groups is best for LSD, so lets use "tea"
LSD.test(fit1, "tea", console = TRUE)

# Howell criticizes Fisher because it doesn't control alpha
# If you want to also incorporate p adjustment methods
LSD.test(fit1, "tea", console = TRUE, p.adj = "bonferroni")

### 4) Try running LSD.test on coffee and IQ using groups 3-5 cups only
fit1 <- aov(IQ ~ coffee, data = dat.c[as.numeric(dat.c$coffee) > 2,])
summary(fit1)



## Tukey's HSD test
fit <- aov(IQ ~ coffee, data = dat.c)
fit
TukeyHSD(fit) 
# Look at the p adj for significant mean differences

### 5) Try the Tukey post-hoc test with age and tea ###



## The Ryan Procedure (REGWQ)  
# Puts mean differences in order from largest to smallest
# mutoss() doesn't work anymore so Matt wrote us a function to source :)
source("https://dl.dropboxusercontent.com/u/30825176/regwq.R") 
result <- regwq(IQ~coffee, data=dat.c, alpha=0.05,MSE=NULL, df=NULL)
result

### 6) Try running the REGWQ with Age and tea ###


# Benjamini-Hochberg test 
pairwise.t.test(dat.c$IQ, dat.c$coffee, p.adjust.method="BH") 


# Robust ANOVA 
# install.packages("WRS2")
library("WRS2")
# Post-hoc linear contrast analysis on trimmed means
lincon(IQ ~ coffee, data = dat.c) # default trims 20%
lincon(IQ ~ coffee, data = dat.c, tr = .1) # change the trim as desired

### 7) Try running a robust ANOVA with linear contrasts and a 15% trim ###




### Answers ###

# 1) Comparing age of people who drink 1 and 2 cups of tea
t.test(Age ~ tea,
       data = dat.c[dat.c$tea==1|dat.c$tea==2,], var.equal=TRUE) 

# 2) Try running the Bonferroni test on IQ and tea
pairwise.t.test(dat.c$IQ, dat.c$tea, p.adjust.method="bonferroni") 

# 3) Try running the Holm test on IQ and tea
pairwise.t.test(dat.c$IQ, dat.c$tea, 
                p.adjust.method="holm") 

# 4) Try running LSD.test on coffee and IQ using groups 3-5 cups only
fit1 <- aov(IQ ~ coffee, data = dat.c[as.numeric(dat.c$coffee) > 2,])
summary(fit1)
LSD.test(fit1, "coffee", console = TRUE)

# 5) Try the Tukey post-hoc test with Age and tea
fit <- aov(Age ~ tea, data = dat.c)
fit
TukeyHSD(fit) 

# 6) Try running the REGWQ with Age and tea
source("https://dl.dropboxusercontent.com/u/30825176/regwq.R") 
result <- regwq(Age ~ tea, data=dat.c, alpha=0.05,MSE=NULL, df=NULL)
result

# 7) Try running a robust ANOVA with linear contrasts and a 15% trim
lincon(IQ ~ coffee, data = dat.c, tr = .15)

