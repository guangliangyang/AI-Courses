#----COMP828 Week 10

?mtcars

#---Correlation

cor(mtcars$mpg,mtcars$wt)

cor(mtcars[,c(1,3,4,5,6)])


#----Linear Regression
model1 <- lm(mpg~wt,data=mtcars)
summary(model1)

model2 <- lm(mpg~hp+wt,data=mtcars)
summary(model2)

#----Logistic Regression
plot(mtcars$wt,mtcars$am)

model3 <- glm(am~wt,data=mtcars,family=binomial)
summary(model3)

model4 <- glm(am~hp+wt,data=mtcars,family=binomial)
summary(model4)
