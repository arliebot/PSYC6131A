# Week 10: Factorial ANOVA

## Install Packages

install.packages("car")
library(car)

install.packages("pastecs")
library(pastecs)


## Get our data sets
# Dataset 1
setwd("~/Desktop/TA/2016:2017/Green/Labs/Lab8")
dat1 <- read.csv("ANOVAdata.csv")
head(dat1)
str(dat1)

# Define Factors
dat1$Coffee <- as.factor(dat1$Coffee)
dat1$Tea <- as.factor(dat1$Tea)
dat1$YN <- as.factor(dat1$YN)

# Dataset 2
dat2 <-read.csv("dataset_ANOVA_twoWay_interactions.csv")
head(dat2)


## Assumptions
# Here is a great cheat sheet for factorial ANOVA in R
# http://www.usabart.nl/eval/cs-factorial%20ANOVA.pdf


# 1) Normality
library(pastecs)
by(dat1$IQ, list(dat1$Tea, dat1$YN), stat.desc, basic=F, norm=T)
# Multiply	skew.2SE and	kurt.2SE by	2	to	get	the	Z-scores	of	
# skewness	and	kurtosis.	Compare	these	values	to	typical	cut-off	values	
# (Z >	±1.96:	p <	.05,	Z >	±2.58:	p <	.01,	Z >	±3.29:	p <	.001).	
# The	significance	of	the	Shapiro-Wilk	test	is	listed	under	normtest.p

# 2) Homogeneity for Variance
library(car)
leveneTest(IQ ~ Tea * YN, data = dat1)
# Non-significant Levene's test so OKAY to use ANOVA


## This week's plan  
# - Factorial ANOVA  
# - Interaction
# - Interaction Plot
# - Simple Effects
# - 3-way ANOVA
# - Interactions Plot


## Factorial ANOVA (Main Effects Only)
# We want to test if levels of IQ vary over the 3 levels of Tea and 2 levels of YN. 
# Run a 3 x 2 two-way ANOVA 
# (omit the interaction between factors for now and only look at main effects).
fit1 <- aov(IQ ~ Tea + YN, data = dat1)
summary(fit1)

# IQ is significantly different across levels of Tea F(1,496)=167.828, p< 0.001
# IQ is not significantly different across levels of YN F(1, 496)=0.033, p=0.856


### 1) Try a factorial ANOVA without an interaction with dat2 comparing ###
### StressReduction across levels of Treatment and Gender ###



## Factorial ANOVA (Main Effects and Interaction)  
# Now we are interested to test the interation of IQ levels
# over the 3 levels of tea and 2 levels of YN. 
# Run a 10 x 2 two-way ANOVA and add in the interaction with *
fit2 <- aov(IQ ~ Tea + YN + Tea*YN, data = dat1)
summary(fit2)

# There is a significant interaction, F(1,494)=5.820, p=0.00318


### 2) Try a factorial ANOVA with an interaction with dat2



## Plotting  
# Interaction plot
interaction.plot(x.factor = dat1$Tea, 
                 trace.factor = dat1$YN, 
                 response = dat1$IQ,
                 type="b", col=c(1:2), 
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24),	
                 xlab="Tea", ylab="IQ", 
                 main="Interaction Plot")


### 3) Try making an interaction plot for dat2 ###



## Simple Effects  
# We have a significant F and want to parse out the effect
# To find the simple effects, we need to subset the data and run 1-way ANOVAS.
# Use subset(data, condition) to divide the original dataset by "Treatment"

# 1 cup subset
sub1 <- subset(dat1, Tea == "1")
head(sub1)

# 2 cup subset
sub2 <- subset(dat1, Tea == "2")
head(sub2)

# 3 cup subset
sub3 <- subset(dat1, Tea == "3")

head(sub3)

# Run ANOVA on the tea subsets to investigate the impacts of YN within each

# 1 cup
fit3b <- aov(IQ ~ YN, sub1)
summary(fit3b)
# Even though the overall F for YN was not significant
# YN is significantly different under the 1 cup subset, F(1,148)=4.85, p=0.0292

# 2 cups
fit4b <- aov(IQ ~ YN, sub2)
summary(fit4b)
# YN is significantly different under the 2 cup subset, F(1,200)=4.067, p=0.0451

# 3 cups
fit5b <- aov(IQ ~ YN, sub3)
summary(fit5b)
# YN is not significantly different under the 3 cup subset, F(1,146)=3.143, p=0.0784


### 4) Try making subsets and running ANVOAs for dat2 ###


# Pairwise comparisons
# If Gender had 3 levels in our example, we might want to follow up with 
# pairwise comparisons for our significant *F*s. 
# They are the same as the ones we learned last week (Bonferroni, Tukey, etc...)
# We don't have to this time because we split our 3-level factor into subsets



## 3-way ANOVA
fit6 <- aov(IQ ~ Coffee * Tea * YN, data = dat1) # * will output all main effects and interactions
summary(fit6)

# Significant Coffee effect, significant Tea effect, and significant Tea by YN interaction

## Interactions Plot 3-way ANOVA
# We're going to split the data into 2 plots (facets) to show side by side

# Subset YN 1
subYN1 <- subset(dat1, YN == "1")

# Subset YN 2
subYN2 <- subset(dat1, YN =="2")

op <- par(mfrow = c(1,2)) # this puts 2 plots on 1 row in the plot viewer

# Plot for YN = 1
interaction.plot(x.factor = subYN1$Coffee, 
                 trace.factor = subYN1$Tea, 
                 response = subYN1$IQ,
                 type="b", col=c(1:2), 
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24),	
                 xlab="Tea", ylab="IQ", 
                 main="Interaction Plot YN 1")

# Plot for YN = 2
interaction.plot(x.factor = subYN2$Coffee, 
                 trace.factor = subYN2$Tea, 
                 response = subYN2$IQ,
                 type="b", col=c(1:2), 
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24),	
                 xlab="Tea", ylab="IQ", 
                 main="Interaction Plot YN 2")

# The closer you are to the data, the easier interpretation of 3-way ANOVA becomes
# Personally, if there are more than 2 variables, I hope the interaction is not significant ;)

par(op) # This ends the graphical parameters we set


### Answers ###

### 1) Try a factorial ANOVA without an interaction with dat2 comparing 
### StressReduction across levels of Treatment and Gender
fit1b <- aov(StressReduction ~ Treatment + Gender, data = dat2)
summary(fit1b)

# Treatment is significant, F(2,56)=11.011, p<0.001


### 2) Try a factorial ANOVA with an interaction with dat2
fit2b <- aov(StressReduction ~ Gender + Treatment + Gender*Treatment, 
            data = dat2)
summary(fit2b)

# Gender is not significant, Treatment is significant, 
# and the Gender by Treatment interaction is significant.


### 3) Try making an interaction plot for dat2 ###
interaction.plot(x.factor = dat2$Treatment, 
                 trace.factor = dat2$Gender, 
                 response = dat2$StressReduction,
                 type="b", col=c(1:2), 
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24),	
                 xlab="Treatment", ylab="Stress Reduction", 
                 main="Interaction Plot")

### 4) Try making subsets and running ANVOAs for dat1 ###

# Medical subset
subMedical <- subset(dat2, Treatment == "medical")
head(subMedical) # Now only  displays for "medical" Treatment

# Mental subset
subMental <- subset(dat2, Treatment == "mental")

# Physical subset
subPhysical <- subset(dat2, Treatment == "physical")

# Run ANOVA on the treatment subsets to investigate the impacts of gender within each

# Medical
fit3 <- aov(StressReduction ~ Gender, subMedical)
summary(fit3)
Anova(fit3)
# No significant difference for gender under the subMedical subset, F(1,18)=0, p=1

# Mental
fit4 <- aov(StressReduction ~ Gender, subMental)
summary(fit4)
# A significant gender difference under the subMental subset, F(1,18)=7.5, p=0.0135

# Physical
fit5 <- aov(StressReduction ~ Gender, subPhysical)
summary(fit5)
# A significant gender difference under the subPhysical subset, F(1,18)=30, p<0.001


