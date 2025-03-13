# 1. Install the packages
# 1.1  list the packages
# stringr is working through stringr.
packages <- c("tidyverse", "stringr", "lubridate", "forcats", "nycflights13")
# 1.2 Find packages that are not installed
# * installed.packages() function will returns a list of all currently installed software packages with all information.
# * installed.packages()[,"Package"] will return all package columns, which means the name of the software.
# * packages %in% installed.packages()[,"Package"]: check if the elements in the "packages" in the list the 
# installed sofware packages. And return a logical vector which means True or False.
# * !(packages %in% installed.packages()[,"Package"]): Negation of taking logical vectors
packages_to_install <- packages[!(packages %in% installed.packages()[,"Package"])]
# 1.3 Install required packages
if(length(packages_to_install) > 0){
  install.packages(packages_to_install,
                   dependencies=TRUE)
}

# 1.4 Load the packages
# ?sapply
# sapply() will be sued to apply a Function over a List or Vector
# Here packages is the list, and library is the function.
# Which mean we will use the library function to import the packages
# character.only=TRUE --- means Consider each element as a character type rather than any other type.
sapply(packages, library, character.only=TRUE)


# (2) Consider the following string vector.
x <- c("25th May 2019", "April 19th 2005", "12 December 1984")
x
class(x)
class(x[0])
# Trying  part for student understand the data type
trying_testing = c("25th May 2019", "April 19th 2005", "12 December 1984",1,0,x)
class(trying_testing)
class(trying_testing[3])

# Addtional information Different type of R given by Wenqiang
# Numeric vector
numeric_vector <- c(1, 2, 3, 4, 5)
class(numeric_vector)
# Character vector
character_vector <- c("apple", "banana", "orange")
class(character_vector)
# Logical vector
logical_vector <- c(TRUE, FALSE, TRUE, TRUE)
class(logical_vector)
# Vector with mixed types
# if you combine elements of different types in a vector, R will try to cast them to a common type
mixed_vector <- c(1, "two", TRUE)
class(mixed_vector)

mixed_vector_2 <- c(1, TRUE)
class(mixed_vector_2)

# Empty vector
empty_vector <- c()
class(empty_vector)
# Using the assignment operator '<-' or '='
numbers <- 1:5
class(numbers)

# 2.1 Identify all digits in x
# Used to view strings
view(x)
str_view(x)
# regular expression is a Text processing tools that can be used for operations such as matching, 
# searching, replacing strings, and string splitting
# "[\\d]" is a paramete. And in regular regression "\\d" means match numeric characters
str_view(x, "[\\d]")

# 2.2 Identify the year in each element of x.
# Hint. Consider the following code and adapt as needed. str_view(x, "ˆ[\\d]{2}")
str_view(x, "[\\d]{4}$")
# More details
# [\\d] means match any numeric character.
# {4} means that the preceding pattern |  is repeated exactly four times.
# $ means match the end of the string.

# 2.3 Identify the month in each element of x
# Identify any words starting with a capital letter.
str_view(x, "[A-Z][a-z]*")
# [A-Z] means match any uppercase letter.
# [a-z]* means match any number of lowercase letters, including zero.



# (3) Consider the following string vector:
x <- c("apple", "pear", "banana", "eggplant")


# Use the appropriate stringr function for each of the following questions.
# 3.1 Sort the elements of x in alphabetical order
str_sort(x)

# 3.2 replace all vowels in x with -
# aeiou is in [a,e,i,o,u]
# str_replace_all replace the  '[aeiou]' to '-'.
str_replace_all(x, "[aeiou]", "-")


# 3.3 Use str_c to create the following output from the appropriate elements of 
# str_c: is a function in the stringr package that is used to concatenate multiple strings into one string.
# x[1]
# x[3]
# sep = "": This is a function in the stringr package that is used to concatenate multiple strings into one string.
# 1.
str_c("I like to eat, eat, eat ", x[1], "s and ", x[3], "s.", sep = "")
# 2.
str_c("I like to eat, eat, eat ", x[1], "s and ", x[3], "s.")
# 3.
str_c("I like to eat, eat, eat ", x[1], "s and ", x[3], "s.", sep = "-")

# challenge version:
# rep("eat", 3) will repeat the string "eat" three times, generating a character vector of length 3 c("eat", "eat", "eat")
# The collapse = ", " parameter specifies the use of commas and spaces as separators 
              #   when concatenating these three repeated strings.
str_c("I like to ",
      str_c(rep("eat", 3), collapse = ", "),
      " ", x[1], "s and ", x[3], "s.", sep = "")

# -----------------------------------------------------------
# Dates and Times
# • Check that the lubridate package has been installed. Find out what the date and time
# is, right now
today() # this is a date
now() # this is a date-time

# 4. Creating dates and times
# 4.1  Run the following code to create dates/times from strings. Inspect the output, then
# modify the code to use today’s date.

# The ymd() function parses a date string into a date object and returns a date type value.
# The mdy() function parses a date string into a date object and returns a date type value.
# The ymd_hms() function parses a datetime string into a datetime object and returns a datetime type value.
ymd("1993-01-31")
mdy("January 31st, 1993")
ymd_hms("1923-01-31 13:10:32")
# The object returned by the md_hms() function is a datetime object, so its category is POSIXct.
class(ymd_hms("1923-01-31 13:10:32"))
# 4.2 Use parse_date_time to parse the following string. Inspect the output, then modify the
# code to use today’s date. Call your result y.
x <- "Thursday 1993-01-31 20:11:59"
class(x)
# The desired output for y is:
(y <- parse_date_time(x, "A Ymd HMS"))
# class(ymd_hms("1923-01-31 13:10:32"))

# The function of "parse_date_time()" is a function under the lubridate.
# parse_date_time() does is parse datetime strings.
class(ymd_hms("1923-01-31 13:10:32"))

# 5. Extracting date-time components
 # 5.1 Use the function year to extract the value of the year from y.
# year() function is under the "lubridate" package
year(y)

# 5.2 Use the function month to extract the value of the month from y. What do the options
# label and abbr do? Use ?month to find out more, then test your answer by running the
# code in R.


# month(y): This function returns a value containing the month of each date in the datetime object y,
# ranging from 1 to 12, representing each month of the year. 
# For example, 1 represents January, 2 represents February, and so on.


# return is a number
month(y)
#date part month(y, label = TRUE): This function returns the abbreviation or full name of the month containing each date in datetime object y,
# rather than a numeric value.  If label = TRUE, the abbreviation of the month is returned, such as "Jan", "Feb", etc.  
# This format is more concise when outputting months
# abbreviation of month.
month(y,label = TRUE)
# If abbr = FALSE, the complete month name is returned.
month(y,label = TRUE, abbr = FALSE)


# 5.3 What do the functions mday, yday and wday do?
mday(y)
yday(y)
wday(y)

# New trying given by Wenqiang
trying_testing_value = today()

# return the date part of the time object
mday(trying_testing_value)
# return the number of days in the year for this date
yday(trying_testing_value)
# Return the information about the day of the week for this date.
# By default, 1 means Sunday, 2 means Monday, and so on, and 7 means Saturday.
wday(trying_testing_value)

# Factors
# 6. The following dataset contains a list of classes and their location (one of North, City, South,
# and online). Create a factor variable containing the location. Arrange by geographic
# location from north to south, with online at the end.

schedule <- tibble(
  class = c("COMP824/01", "COMP824/N1", "STAT400/01", "STAT400/02", "STAT400/M1"),
  location = c("City", "Online", "City", "North", "South" )
)
schedule

loc_levels = c("North", "City", "South", "Online")
schedule %>%
  mutate(location = fct(location, levels = loc_levels)) %>%
  arrange(location)

# mutate(.data, new_variable = expression)
# data: Represents the data frame or data table to be operated on.
# new_variable: Indicates the name of the new variable to be created or modified.
# expression: Expression that is used to operate on existing variables or to define new variables.
# The fct() function is a function in the forcats package and is used to operate on factor variables.
# fct() will Unordered variables are changed to ordered variables. And the ordered rules will following loc_levels
# arrange(location) arrange the rules follow the order location_level
# -----------------------------------------------------------------
# Application:flights
# more information from Wenqiang 
# This "flights" dataset is typically a sample dataset in the nycflights13 package
?flights
# see dataset
View(flights)
# check dataset type
class(flights)
# check the shape of the dataset
dim(flights)
# only row numbers
nrow(flights)
# col numbers
ncol(flights)
# what is col names
names(flights)
# using head()
head(flights, n = 5)
# 7. Create a subset of the flights data using the following codetools
flights_subset <-  flights[1:10,]

# 8.Convert the variable origin to a factor with levels EWR, LGA JFK. Determine the
# order of the factors based on the latitude of the three airports, i.e. put the northern most
# airport first, and the southern most airport last. Use the dataset airports to determine
# the latitude.

names(airports)
dim(airports)
# filter(): Using the condition to find the different data.
# arrange function: arrange the data through the condition which is lat here.
# pull function(): The pull() function is used to extract a single column from a data frame and convert it into a vector or list.


# double check the data
airports[,'faa']
head(flights,n = 5)

# give the flights columns
names(flights)
# mutate function is normally used to create a new column, or give an exisited column some new values.
# the form of the function is "mutate(data, new_column = expression)"
# and
#  fct() function is part of the "forcats" package, which is used for working with factor variables.
flights %>%
  mutate(
    origin = fct(origin, airport_levels)
  )


# 9. Convert the variable destination to a factor with levels contained in the airports dataset.
# Use appropriate tidyverse functions to compute the top 10 destinations with the most
# flights. Use ggplot to display this in a column chart, with the bars ordered by number
# of flights.


## multiple answers are possible.
## notice the error message
# flights %>%
# mutate(
# dest = fct(dest, airports %>% pull(faa))
#)
#option 1: use factor
flights %>%
  mutate(
    dest = factor(dest, airports %>% pull(faa))
  ) %>% count(dest) %>% arrange(-n) %>% print(n=20)

# option 2: specify NA values
airport_levels <- airports %>% pull(faa)
missing_airports <- setdiff(unique(flights$dest), airports$faa) %>% unique()
flights2 <- flights %>%
  mutate(
    dest = fct(dest,
               airports %>% pull(faa),
               na = missing_airports)
  )
# Plot
flights2 %>%
  count(dest) %>%
  arrange(-n) %>%
  slice_head(n=20) %>%
  ggplot() +
  geom_col(mapping = aes(y = fct_reorder(dest, n),
                         x = n))



# 10. Challenge/Optional: Modify the plot in the previous question to include the top 20 des-
#   tinations. Make sure that NA is listed last in the plot.


# 11. dates and date-times can also be created from individual variables. Three methods are
# shown below.

# Create a departure variable using the year, month, day, hour and minute variables in the
# flights dataset with the function make_datetime. Inspect, then run the code.


flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(departure = make_datetime(year, month, day, hour, minute))

# • Create a departure variable using the year, month, day, hour and minute variables in the
# flights dataset with the functions ymd_hm and str_c. Inspect, then run the code.
flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(departure = ymd_hm(str_c(year, month, day, hour, minute, sep =" ")))


# Create a departure variable using the year, month, day, sched_dep_time variables in
# the flights dataset with the function make_datetime. Notice how you can use the modulo
# operator to extract the relevant information from sched_dep_time. See ?"%%" for more
# info. Inspect, then run the code.

# example of
123 %% 100
123 %/% 100
flights %>%
  select(year, month, day, sched_dep_time) %>%
  mutate(departure_time = make_datetime(year, month,
                                        day, sched_dep_time %/%100,
                                        sched_dep_time %% 100))




# 12. Optional: The previous exercise presented three methods for doing the same thing. Which
# is fastest? The .R file COMP824_lab_week08_compare_methods.R provides some code to
# compare the three methods. Inspect the code, then increase the number of runs to a larger
# number. Write some code to analyse the results and use ggplot2 to create an appropriate
# plot.

# make_datetime is quickest
# ymd_hms_str_c is slowest







# This code compares the computation time of 
# three methods for constructing a 
# date-time variable from individual columns.

n_runs <- 30

comp_time <- tibble(run = 1:n_runs,
                    make_datetime = as.numeric(NA),
                    ymd_hms_str_c =  as.numeric(NA),
                    make_dep_time = as.numeric(NA),
)



for(i in  1:n_runs){
  times <- numeric(4)
  
  times[1] <- Sys.time()
  
  # method 1
  flights %>% 
    select(year, month, day, hour, minute) %>% 
    mutate(departure = make_datetime(year, month, day, hour, minute))
  
  times[2] <- Sys.time()
  
  # method 2
  flights %>% 
    select(year, month, day, hour, minute) %>% 
    mutate(departure = ymd_hm(str_c(year, month, day, hour, minute, sep =" ")))
  
  times[3] <- Sys.time()
  
  # method 3
  flights %>% 
    select(year, month, day, dep_time) %>% 
    mutate(departure_time = make_datetime(year, month, 
                                          day, dep_time %/%100,
                                          dep_time  %% 100)) 
  times[4] <- Sys.time()
  
  # Collate times
  diff_times <- diff(times)
  comp_time[i,"make_datetime"] <- diff(times)[1]
  comp_time[i,"ymd_hms_str_c"] <- diff(times)[2]
  comp_time[i,"make_dep_time"] <- diff(times)[3]
} #end for









# -------------------------------------------------------------------




comp_time %>% summary()

comp_time %>%
  pivot_longer(cols = c("make_datetime", "ymd_hms_str_c", "make_dep_time"),
               names_to = "method") %>%
  ggplot() +
  geom_density(mapping = aes(x = value, fill = method)) +
  labs(
    title = str_c("Computation time to create date for ",
                  "three different methods, with ",
                  n_runs, " runs"),
    x = "seconds"
  )




