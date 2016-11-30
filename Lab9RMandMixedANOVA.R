## Repeated Measures and Mixed Design ANOVA 



## Install Packages
install.packages("ez", dependencies = TRUE)
library(ez)


## Get the Data
# Set working directory and get our data
setwd("~/Desktop/TA/2016:2017/Green/Labs/Lab9")

# RM ANOVA Data
RMdat <- read.csv("RMAnova.csv")
RMdat
str(RMdat)

RMdat2 <- read.csv("RMAnovaClass.csv")
RMdat2


# Mixed ANOVA Data
# 1 Between Subjects 1 Within Subjects Variable
Mixdat <- read.csv("MixANOVA.csv")
Mixdat

Mixdat2 <- read.csv("MixAnovaClass.csv")
Mixdat2


## WITHIN DESIGN (RM ANOVA)
# Step 1) Reshape data into long format (so far we've only used wide format data)
rm_long <- reshape(RMdat, 
                   varying = c("Wk1", "Wk2", "Wk3", "Wk4", "Wk5"), # Variables in columns that we want to all be in a single column
                   v.names = "Score", # What we call the scores associated with those variables
                   timevar = "Week", # What we want to call the new column
                   idvar = "Subject", # Identification variable
                   direction = "long") # "long" or "wide" format
rm_long

# Step 2) Set IDVs as factors
rm_long$Subject <- factor(rm_long$Subject) 
rm_long$Week <- factor(rm_long$Week, labels = c("Wk1", "Wk2", "Wk3", "Wk4", "Wk5"))
str(rm_long)
rm_long

# Step 3) Check Variance Covariance Table
cov(RMdat[,2:6])
# Use RMdat in wide format not long format
# Check to make sure the diagonals (variances) are fairly equal 
# (within 4* of each other) and off diagonals (covariances) are fairly equal 
# to each other. Diagonals and off diagonals do not have to be equal to one another.

# Step 4) Run the RM ANVOA
fit1 <- aov(Score ~ Week + Error(Subject), data = rm_long)
summary(fit1)
# F(4)=85.04, p<0.001
# Problem with aov() no check for Sphericity

# Step 5) Run better RM ANOVA with ezANOVA()
# install.packages("ez", dependencies = TRUE)
# library(ez)
mod2 <- ezANOVA(
  data = rm_long,
  dv = Score,
  wid = Subject,
  within = .c(Week),
  return_aov=TRUE) 
#.c means combine (if we want more than 1 within subjects variable). 
# We don't need it here, but it's an OK default to keep for your notes.

mod2
# F(4)=85.04, p<0.001
# Mauchly's Test of sphericity is not significant, so we met that assumption.
# Otherwise we would report the GG (Greenhouse-Geisser or Huynh-Feldt correction)



## Effect Size
# Eta Square <- SSeffect/(SSeffect+ SSerror)
2449.2 / (2449.2 + 230.4)
# 91% of variation in DV is explained by IDV



## Contrasts for RM ANOVA
# There is not a good method for post-hoc tests for repreated measures ANOVA in R
# Without using lm() or glm() (which you learn in regression next semester)
# If you have individual t-tests to follow up from a significant F, 
# use repeated measures t.test()
t.test(RMdat$Wk1,RMdat$Wk2,paired=TRUE) # Not sig
t.test(RMdat$Wk1,RMdat$Wk3,paired=TRUE) # Sig
t.test(RMdat$Wk1,RMdat$Wk4,paired=TRUE) # Sig
t.test(RMdat$Wk2,RMdat$Wk3,paired=TRUE) # Sig
t.test(RMdat$Wk2,RMdat$Wk4,paired=TRUE) # Sig
t.test(RMdat$Wk3,RMdat$Wk4,paired=TRUE) # Sig

# Then we can make Bonferroni or Holm corrections to the p values
# p.adjust(pvalue, method = "bonferroni or holm", n = number of comparisons)
p.adjust(.8494, method = "bonferroni", n = 6)
p.adjust(0.0000006224, method = "bonferroni", n = 6)
p.adjust(0.0000002095, method = "bonferroni", n = 6)
p.adjust(0.0000004941, method = "bonferroni", n = 6)
p.adjust(0.000000009997, method = "bonferroni", n = 6)
p.adjust(0.002463, method = "bonferroni", n = 6)

# The Holm method is less conservative generally preferred to the Bonferroni


## Plot it!
# By subject
interaction.plot(x.factor = rm_long$Week, 
                 trace.factor = rm_long$Subject, 
                 response = rm_long$Score,
                 type="b", col=c(1:2), 
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24),	
                 xlab="Week", ylab="Score", 
                 main="Repeated Measures ANOVA Plot")

# By Week 
plot(rm_long$Week, rm_long$Score, xlab = "Week", ylab = "Score", 
     main = "Repeated Measures", type = "l")

### Try running a repeated measures ANOVA with the RMAnovaClass.csv dataset ###



## One Between and One Within-Subjects Variable 
# BETWEEN/WITHIN DESIGN
Mixdat

# Interval is the within subjects variable  
# Group is the between subjects variable

Mixdat$Subject <- 1:24 # Need Subject variable for reshapinng

mix_long <- reshape(Mixdat, 
                    varying = c("Int1", "Int2", "Int3", 
                                "Int4", "Int5", "Int6"),
                    v.names = "Score",
                    timevar = "Interval",
                    idvar = "Subject",
                    direction = "long")

mix_long
str(mix_long) # Check structure

# Set IDVs as factors
mix_long$Group <- factor(mix_long$Group, 
                         labels = c("Control", "Same", "Different")) 
                        # Labels are optional, we could have kept 1, 2, 3
mix_long$Subject <- factor(mix_long$Subject)
mix_long$Interval <- factor(mix_long$Interval, 
                            labels = c("Int1", "Int2", "Int3", "Int4", "Int5", "Int6"))

# Run the RM ANOVA
mod <- ezANOVA(
  data = mix_long,
  dv = Score,
  wid = Subject,
  within = .c(Interval),
  between = Group)

mod

# Group: F(2)=7.8, p=0.0029     (Between Subjects F)
# Interval: F(5)=29.85, p<0.001  (Within Subjects F)
# Group*Interval: F(10)=3.017, p=0.00216     (Interaction)

# Mauchly's test for sphericity was significant, so we use the corrected p values 
# for the within and interaction Fs.
# We use the Greenhouse-Geisser (GG) or Huynh-Feldt (HF) corrections
# Interval_Corrected: F(5)=29.85, p<0.001
# Interation_Corrected: F(10)=3.017, p=0.00918


## Plot it!

interaction.plot(x.factor = mix_long$Interval, 
                 trace.factor = mix_long$Group, 
                 response = mix_long$Score,
                 type="b", col=c(1:2), 
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24),	
                 xlab="Intercal", ylab="Score", 
                 main="Mixed Design Interaction Plot")


### Try running a mixed-design ANVOA with the MixAnovaClass.csv dataset ###



### Answers ###

# 1) Repeated-measures ANOVA
RMdat2
# Step 1) Reshape data into long format (so far we've only used wide format data)
rm_long2 <- reshape(RMdat2, 
                   varying = c("Time1", "Time2", "Time3"),
                   v.names = "Score", 
                   timevar = "Time", 
                   idvar = "ID", 
                   direction = "long")

# Step 2) Set IDVs as factors
rm_long2$ID <- factor(rm_long2$ID) 
rm_long2$Time <- factor(rm_long2$Time, labels = c("1", "2", "3"))
str(rm_long2)
rm_long2

# Step 3) Check Variance Covariance Table
cov(RMdat2[,2:4])
# Everything is colinear because I made up the data set :P

# Step 4) Run the RM ANVOA
fit1b <- aov(Score ~ Time + Error(ID), data = rm_long2)
summary(fit1b)
# F(2,22)=7.566, p<0.001

# Step 5) Run better RM ANOVA with ezANOVA()
mod2b <- ezANOVA(
  data = rm_long2,
  dv = Score,
  wid = ID,
  within = .c(Time),
  return_aov=TRUE) 
mod2b
# F(2,22) = Infinity, p<0.001


## Effect Size
# Eta Square <- SSeffect/(SSeffect+ SSerror)
78.9368 / (78.9368 + 0)
# 100% of variation in DV is explained by IDV



# 2) Mixed Design ANOVA

Mixdat2

# Interval is the within subjects variable  
# Group is the between subjects variable

mix_long2 <- reshape(Mixdat2, 
                    varying = c("Time1", "Time2", "Time3"),
                    v.names = "Score",
                    timevar = "Time",
                    idvar = "ID",
                    direction = "long")
mix_long2
str(mix_long) # Check structure

# Set IDVs as factors
mix_long2$Group <- factor(mix_long2$Group) 
mix_long2$ID <- factor(mix_long2$ID)
mix_long2$Time <- factor(mix_long2$Time)

# Run the RM ANOVA
modb <- ezANOVA(
  data = mix_long2,
  dv = Score,
  wid = ID,
  within = .c(Time),
  between = Group)

modb

# Group: F(1) = 538.36, p<0.001   (Between Subjects F)
# Interval: F(2) = 26395860000000000000, p<0.001  (Within Subjects F)
# Group*Interval: F(2) = 2932873000000000000 p<0.001  (Interaction)

# Mauchly's test for sphericity was significant, so we use the corrected p values 
# for the within and interaction Fs.
# We use the Greenhouse-Geisser (GG) or Huynh-Feldt (HF) corrections
# But the data is terrible, so the numbers are exaggerated.


## Plot it
interaction.plot(x.factor = mix_long2$Time, 
                 trace.factor = mix_long2$Group, 
                 response = mix_long2$Score,
                 type="b", col=c(1:2), 
                 leg.bty="o", leg.bg="beige", lwd=2, pch=c(18,24),	
                 xlab="Time", ylab="Score", 
                 main="Interaction Plot")
