# 1. Install the packages
# 1.1  list the packages
packages <- c("tidyverse", "readxl")
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


# Tidy data
# 2. What are the 3 principals of tidy data? Complete the following sentences
# ---   Each variable must have --- its own column
# ---   Each observation must have --- its own row
# ---   Each value must have --- its own cell

# 3. Download the file auckland_weather.xlsx from Canvas. Open the file in Excel and note
# some of the issues that you might face when importing into R.
# 4. Import the weather sheet using readxl::read_excel(). You will need to customise the
# import options. Hint: consider the number of rows or range that should be imported.

# Set the relative path
fname_path <- "auckland_weather.xlsx"
# Here, the sheet mean we will read the "weather" work sheet.
# skip: I have already explaiend last week, it will skip firt two rows
# n_max = 3165 means  the maximum number of rows to read as 3165
weather_raw <- read_excel(fname_path, sheet = "weather",
                          skip = 2,
                          n_max = 3165
                          #, range = "A3:F3168"
)

view(weather_raw)
dim(weather_raw)
head(weather_raw, n = 10)
 
# (5) Use the R function tidyr::separate to separate the ymd variable into six separate
# columns: year, month, day, hour, minute and second. The required output is shown
# below.

names(weather_raw)
# There is no ymd variable, So we need to guess what is that, normally, 
# The ymd - year, month, and day  --- So we will choose the date column.
weather <- tidyr::separate(weather_raw, date,
                    into=c("year", "month", "day",
                           "hour", "minute", "second"),
                    remove=FALSE, convert=TRUE)
# Data: The data frame to be processed.
# Col: The column name to be split.
# into: set the new columns names 
# remove=FALSE: It means not deleting the original date column.
# convert=TRUE: Convert the data type of the new column to the appropriate type
head(weather, n = 5)

# (6) Use table(x) to determine the unique values of the new columns day and month.
# Before we use the table function, I will using the unique function to the unique values
unique(weather$day)
unique(weather$month)
# the results of the Unique() function will only show the number of value names
# For e table function, The result is not only the value, but also the number of each value
table(weather$day)
table(weather$month)

# (7) Use the R functions dplyr::group_by and dplyr::summarise to create a tibble called
# daily containing the daily high temperature, daily low temperature
# and daily maximum relative humidity during the data collection period. The required
# output is shown below.
daily <- weather %>%
  group_by(year, month, day) %>%
  summarise(daily_high = max(temperature),
            daily_low = min(temperature),
            max_humidity = max(relative_humidity))
daily

# ?summarise


# (8) Create a new column called date in the format yyyy-mm-dd. Save the result as new tibble
# called daily_date. The required output is shown below.
# Hint: unite the relevant columns, then use mutate and the function date() to convert the
# character variable into a date variable.


# Use the unite() function:  to combine the year, month, and day columns into a new column that called date_raw
# mutate(date = date(date_raw)): Create a new column date using the mutate() function,
#                                where the date is parsed from the text in the data_raw column. 
#                                The data() function converts a character type date to a date type.
# select(date, everything(), -date_raw): Use the select() function to rearrange the order of columns.
                                      #  Here, first select the date column, then use the everything () function to select all other columns, 
                                      #  and finally use - date raw to exclude the date raw column.
daily_date <- daily %>%
  unite(date_raw, year, month, day, sep = "-") %>%
  mutate(date = date(date_raw)) %>%
  select(date, everything(), -date_raw)
head(daily_date, n = 5)


# (9) Create a plot of daily high and daily low temperatures. Hint: review the lecture notes
# and adapt the code for this dataset.
# Pivot the data

# Check the data
head(daily_date, n = 5)

# This section first passes the daily_date data box to the pivot longer() function and 
#               specifies the column names to be converted. Change the data type to the longer type.
# # names_to = "temperature_type: The parameter specifies the name of the new column after conversion,
#               which is used to represent the original column name.
# values_to = "temperature: The parameter specifies the name of the new column after conversion,
              # which is used to represent the value of the original column.
# (....) -brackets-  Assign the result of to the variable daily_long

(daily_long <-
    daily_date %>% pivot_longer(c("daily_high", "daily_low"),
                                names_to = "temperature_type",
                                values_to = "temperature"))

# Create plot
# processing the daily_long data set
# "linear plot": The x-axis is date, the y-axis is temperature, and the color type will be based on the temperature type
# Manually setting color mapping, the color will be set as red and blue.

daily_long %>% ggplot() +
  geom_line(mapping = aes(x = date,
                          y = temperature,
                          col = temperature_type)) +
  # manual change colours (optional)
  scale_color_manual(breaks = c("daily_high", "daily_low"),
                     values=c("red", "blue"))


# (10) High humidity and high temperatures often lead to unpleasant, “sticky” or “muggy”
# weather. Use the daily_date tibble and the dplyr::filter function to find the days
# which had a humidity of over 90%, a daily high of over 22 and a daily low of over 19.
daily_date %>% filter(max_humidity > 90 &
                        daily_high > 22 &
                        daily_low > 19)

# (11) Use ggplot to create a plot of daily high, daily low and maximum humidity. Multiple
# answers are possible
daily_long %>% ggplot() +
  geom_point(mapping = aes(x = temperature,
                           y = max_humidity,
                           col = temperature_type))+
  labs(title = "Daily temperature vs humidity (with jitter)")

daily_long %>% ggplot() +
  geom_jitter(mapping = aes(x = temperature,
                            y = max_humidity,
                            col = temperature_type),
              width = 0.05,
              height = 0.2) +
  labs(title = "Daily temperature vs humidity (with jitter)")



scale <- 3.25
daily_long %>% ggplot() +
  geom_line(mapping = aes(x = date,
                          y = temperature,
                          col = temperature_type)) +
  # manual change colours (optional)
  scale_color_manual(breaks = c("daily_high", "daily_low"),
                     values=c("red", "blue")) +
  geom_line(aes(x = date, y = max_humidity/scale))+
  scale_y_continuous(sec.axis =
                       sec_axis(~.*scale,
                                name="Maximum daily relative humidity"))+
  labs(title = "Daily temperature and humidity over time")


# create temperature differences column
daily_date2 <- daily_date %>%
  mutate(daily_diff = daily_high - daily_low)
# pivot longer
daily_date2_long <- daily_date2 %>%
  pivot_longer(c("daily_high", "daily_low", "daily_diff"),
               names_to = "temperature_type",
               values_to = "temperature")
#plot stacked column chart
daily_date2_long %>% filter(temperature_type != "daily_high") %>%
  ggplot() +
  geom_col(mapping = aes(x = date,
                         y = temperature,
                         fill = temperature_type),
           position = "stack")

# (12) Import the mt cars data using read_csv() as follows:
# • Read the top 5 rows only
mt_cars <- read_csv(readr_example("mtcars.csv"))
# • Exclude the column names
read_csv(readr_example("mtcars.csv"), col_names = FALSE)

#Change the type of the `cyl` and `gear` columns to be an integer rather than double.
read_csv(readr_example("mtcars.csv"),
         col_types = cols(
           cyl = col_integer(),
           gear = col_integer())
)

#Change the type of the `mpg` columns to be an integer rather than double.
mt_cars <- read_csv(readr_example("mtcars.csv"),
                    col_types = cols(
                      mpg = col_integer())
)

# Change the type of the mpg columns to be integer rather than double and observe the
# output. Use problems() to inspect the issues.
# 
problems(mt_cars)
