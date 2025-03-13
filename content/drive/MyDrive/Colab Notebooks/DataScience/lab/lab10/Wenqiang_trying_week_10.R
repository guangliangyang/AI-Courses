# Question 1
# (a) Choose a dataset used previously in the lab sessions and put them in the R system.
# I use the dataset `Soccer_Table_2014-2015.csv` given in Week 3 lab.
# Thanks to Kirsten Spencer who supplied the dataset.
library(readr)
Soccer_Table_2014_2015 <- read_csv("Soccer_Table_2014-2015.csv")
# head(Soccer_Table_2014_2015,n =5)

soccer <- Soccer_Table_2014_2015 # Rename
View(soccer)

# The shape of the dataset
dim(soccer)
# columns of the dataset
names(soccer)
head(soccer,n =5)

# -----------------------------------------------------------------------
# (b) Select two or more variables that you want to find the correlation. State the reason(s) why you are
# interested to see their relationship.

# I'm interested to see the relationship between the goal difference (GD) and the points (Pts) as I expected their positive relationship.
# However, I would like to see from the data how much they are positively related.

# -----------------------------------------------------------------------
# (c) Find the correlation coefficient or the correlation matrix depending on the number of variables you
# choose and interpret it/them.
cor(soccer$GD,soccer$Pts)
# The correlation coefficient of 0.68 indicates the relatively strong
# relationship between the goal difference and the points.

# -----------------------------------------------------------------------
# (d) Did results agree with what you expect?
# The result is what I expected as the teams with higher points should
# have higher goal difference.

# -----------------------------------------------------------------------
# Regression
# (a) Based on the above dataset, are there any causalities you are interested in? If yes, state the reason(s).
# Otherwise, find another dataset.

# Yes, I'm interested to see how much the number of wins and being a
# home team affect the points.

# -----------------------------------------------------------------------
# (b) Use a regression model to investigate the causalities you are interested in

# First, we need to organize the data to have only home and away results.
names(soccer)
unique(soccer$`Table Type`)
table(soccer$`Table Type`)
soccer2 <- soccer[which(soccer$`Table Type`=="Home League Table"
                        | soccer$`Table Type`=="Away League Table" ),]

soccer2

#View(soccer2)
# Then, we generate a dummy variable for being the home team.

soccer2$home <- ifelse(soccer2$`Table Type`==
                         "Home League Table", 1, 0)
table(soccer2$home)
table(soccer2$`Table Type`)
soccer2$home
soccer2$`Table Type`

# After that we run a regression model having the points as the response
# variable and the number of wins and being a home a team as the predictors.
summary(lm(Pts ~ W + home, data = soccer2))



# -----------------------------------------------------------------------
# (c) Interpret the results given in (b)

# Both the number of wins and being the home team have the positively and
# significantly strong effect on the points where the number of wins has
# a stronger effect.
# Overall, the variations in the number of wins and being the home team
# as the predictor # variables can explain the variations in the points
# for almost 96%, which is very high.

# -----------------------------------------------------------------------
# Logistic Regression
# (a) Use a logistic regression to model a casual effect of interest in your dataset.
# In this case, I'm interested to see if the number of wins and being
# the home team have the positive effect on the positive goal difference.
# First, we need to create a binary response variable from the goal difference.
soccer2$GP <- ifelse(soccer2$GD > 0, 1, 0)
# Then, we fit the logistic regression model.
summary(glm(GP ~ W + home, data = soccer2))

# -----------------------------------------------------------------------
# (b) Interpret the results in (a).
# The higher number of wins significantly increases the probability of having
# a positive goal difference while being a home team can increase that chance
# but with a lot less statistical significance.
