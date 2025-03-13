# install package
install.packages("readr")
library(readr)
# install package for the arrange()
install.packages("dplyr")
library(dplyr)
# ggplot2 package
install.packages("ggplot2")
library(ggplot2)

#3  Check the working directory using getwd()
getwd()
# or using right side files path

# 4 Create two new directories within your project called “labs” and “data
dir.create("labs")
dir.create("data")


# 7 Project Directory
knitr::opts_knit$set(root.dir = '../')

# 8. Import the file auckland_weather.csv into R using read_csv(). Check that the date
# column has been imported as dttm.
# 8.1 Import data
fname <- read.csv("data/auckland_weather.csv")
# View the dataset
View(fname)
# Using head function just see top 10 rows
head(fname, n =10)

dim(fname)

# 9 The first two rows of data are useless to our project, so we will skip these two rows.
# and rename the dataset as weather

# comment = "#": This parameter specifies that any lines in the CSV file that begin with "#" should be treated as comments and ignored. 
# Comments are typically used for annotations or explanations within the file and are not part of the actual data.
weather <- read_csv("data/auckland_weather.csv", skip = 2, comment = "#")
head(weather, n=10)
dim(weather)




# 10. Use the R function dplyr::arrange to sort the weather data in order of wind speed (in
# descending order). Which day and time was the windiest?
names(weather)
# based on the cols names, we will choose the wind speed knots cols
# ok, after the we choose the col, we better know the data type of this columns, we could use class() function
class(weather$wind_speed_knots)
# Because it is of numeric type, then 
# 10.1 using arrange() function
arrange(weather,desc(wind_speed_knots)) 
# 10.2  if we using the pipe method, we also could face the requirement.
weather %>% arrange(-wind_speed_knots)
# Let us check the output. Are the output results of these two methods the same?
arrange(weather,desc(wind_speed_knots))  == weather %>% arrange(-wind_speed_knots)

# And we already know, the data type of the wind speed is the numerical
# so we could using max function to the maximun vlaue of the wind speed
max_value_ws = max(weather$wind_speed_knots)
max_value_ws
date_max_ws = weather$date[weather$wind_speed_knots == max_value_ws]
date_max_ws
# Keep all of them in one command, we will get
weather$date[weather$wind_speed_knots == max(weather$wind_speed_knots)]

# Method 2, 
# The pipe operator %>% takes the result on the left as the first argument to the function on the right.  
# However, in some cases you may want to use the previous result somewhere in the pipeline rather than as the first argument to the function.
weather %>% arrange(-wind_speed_knots) %>% .[1,"date"]
# this part, this is the first row , and choos date column.
head(weather,n =3)
# This data set has been sorted by wind speed in descending order. let us see top 3 rows.
head(weather %>% arrange(-wind_speed_knots),n=3)

# other explain
names(weather)
# Based on the output we could know the first columns is the date.
# So, let choose the first column and the first row.
weather %>% arrange(-wind_speed_knots) %>% .[1,1]


# 11.  Use the R function dplyr::filter to print the records which had a wind speed of between
# of over 28 and 30 knots. Your result should have 9 rows.

# The values of the wind speed should be 28,29,30, and we need to use between function.
# Hint: Use the function between().
filter(weather, between(wind_speed_knots, 28, 30))
# Pipe method 1
weather %>% filter(between(wind_speed_knots, 28, 30))


# 12 What is the median wind speed? What percentage of records have a wind speed equal to
# the median? What percentage of records have a wind speed of this value or less?

# 12.1 -------- the median value of wind speed --------------
# median wind speed = 9
summary(weather$wind_speed_knots)
# median function
median(weather$wind_speed_knots)
# Method 2 by using pipe method
weather$wind_speed_knots %>% median()
# Method 3 by using pipe method
# pull() function will reply a vector based on the choosed column
weather %>% pull(wind_speed_knots) %>% median()
# Method 4 by using pipe method
weather %>% summarise(median_wind_speed_knots = median(wind_speed_knots))

# 12.2 ---- What percentage of records have a wind speed = median? ----
# Answer: approx 6%
# The first step we need the total number of the values of the wind speed.
# Different method to get the total number of the data wind speed.
dim(weather)[1]
nrow(weather)
length(weather$wind_speed_knots)
total_value = length(weather$wind_speed_knots)
# get the number of median value of wind speed.
length(weather$wind_speed_knots[weather$wind_speed_knots==9])
sum(weather$wind_speed_knots == 9)
mid_value = sum(weather$wind_speed_knots == 9)
# get the percentage
mid_value/total_value
# --------------------
sum(weather$wind_speed_knots == 9)/dim(weather)[1]

# What percentage of records have a wind speed <= 9?
# Answer: approx 50% (actual value 51.6%)
# By definition of "median", 50% of the data is below this value and
# 50% is above this value.
# For this dataset, we have 6% records with a wind speed of 9, so
# the actual number is slightly above 50%
sum(weather$wind_speed_knots <= 9)/dim(weather)[1]


# 13 Use ggplot() to create a histogram of wind speed in Auckland Choose a binwidth of
# 5mm.
ggplot(data = weather) +
  geom_histogram(mapping = aes(x = wind_speed_knots),
                 binwidth = 5)


# 14, Create a dataset daily_weather containing the daily high and low temperatures.

library(lubridate)
library(stringr)
library(dplyr)

# method one 
daily_weather <- summarise(
  group_by(
    mutate(weather, date_ymd = ymd(str_sub(date, 1, 10))),
    date_ymd
  ),
  hi = max(temperature),
  lo = min(temperature)
)

# Method two by using pipe
# mutate() function to create a new variable date_ymd, which contains the date information extracted from the date column.
# ymd() function: Represents the date format of "year-month-day".
# The str_sub() function extracts a substring from a string.  Here it extracts the first 10 characters from each element of the date column,
# The group_by() function is used to group data based on a specified variable which date_ymd.
# The summarize() function performs summary statistics on the grouped data and calculates the highest and lowest temperature values in each group.
daily_weather <- weather %>% mutate(date_ymd = ymd(str_sub(date, 1, 10))) %>%
  group_by(date_ymd) %>%
  summarise(hi = max(temperature),
            lo = min(temperature))

daily_weather

length(weather$temperature[weather$temperature == max(weather$temperature)])
weather %>% mutate(date_ymd = ymd(str_sub(date, 1, 10))) %>% group_by(date_ymd) %>% summarise(hi = max(temperature))

# 15. Create a line graph with two lines, showing the high and low temperatures. Adjust the
# labels. Save your plot as the object p.
p <- daily_weather %>% ggplot() +
  geom_line(mapping = aes(x = date_ymd, y = hi), col = "red") +
  geom_line(mapping = aes(x = date_ymd, y = lo), col = "blue") +
  labs(x = "date",
       y = "temperature, degrees C",
       title = "High and Low Temperatures for Auckland")
p
# Note: we will learn a better way to do this later in the course.


# 16. Customise the appearance of the dates in your previous plot using scale_x_date.
#  What does the following code do?
p + scale_x_date(date_breaks = "1 month",
                 date_labels = "%d%b%y")
# Modify the code to show the date for the start of each week.
p + scale_x_date(date_breaks = "1 week",
                 date_labels = "%d%b%y")
# Change the appearance of the date to show yyyy-mm-dd for each week, and change the
# direction of the text to be vertical.
p + scale_x_date(date_breaks = "1 week",
                 date_labels = "%Y-%m-%d")+
  theme(axis.text.x = element_text(angle = 270))


# ------------- Forbes Richest Athletes ---------------
# 17. Download the dataset Forbes_richest_athletes.csv from Canvas and import into R.
(richest <- read_csv("data/Forbes_richest_athletes.csv"))


# 18. Data cleaning
# Use the command mutate to create a new variable containing the Sport in lower case.
richest <- richest %>% mutate(Sport = str_to_lower(Sport))
richest

# • Use the command rename to rename the earnings variable to earnings.
richest <- richest %>% rename(earnings = `earnings ($ million)`)
richest


# 19. Use R to investigate the following:
#  How many athletes are included each year?
richest %>% count(Year) %>% print(n=30)

# Which soccer player earns the most?
richest %>% filter(Sport == "soccer") %>% arrange(-earnings)


# extract full name
richest %>% filter(Sport == "soccer") %>% arrange(-earnings) %>% slice_head(n=1) %>% pull

# • Which athlete has appeared the most times in this dataset?
#   Hint: use the function count
richest %>% count(Name) %>% arrange(-n)

# Which sport has the richest athletes?
#   Hint: think about how you will define “richest athletes”. There are multiple answers
# Multiple answers are possible.
# Here are a few ways to address this question
earnings_by_sport <- richest %>% group_by(Sport) %>% summarise(
  mean_earnings = mean(earnings),
  median_earnings = median(earnings),
  max_earnings = max(earnings),
  sum_earnings = sum(earnings),
  n = n()
)
# based on mean, median earnings: MMA
# based on max earnings boxing
# based on total earnings and number of players in dataset, Basketball
earnings_by_sport %>% arrange(-mean_earnings)

earnings_by_sport %>% arrange(-median_earnings)


earnings_by_sport %>% arrange(-max_earnings)

earnings_by_sport %>% arrange(-sum_earnings)

earnings_by_sport %>% arrange(-n)

richest %>% ggplot() +
  geom_boxplot(mapping = aes(x = Sport, y = earnings))+
  theme(axis.text.x = element_text(angle = 270, vjust = 0.5, hjust=1))
# Note: our data contains information about the 10 most highly paid athletes each year.

