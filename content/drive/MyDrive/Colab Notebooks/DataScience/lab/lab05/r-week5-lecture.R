library(tidyverse)
head(iris)
as_tibble(iris)
class(as_tibble(iris))

tibble(
  x = 1:3,
  y = 1,
  z = x ^ 2 + y,
  `x squared` = x^2
)

tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)
 

#Tibble (local)

install.packages("nycflights13")
library(nycflights13)
nycflights13::flights %>%
  print(n = 10, width = Inf)

#Tibble(global)
options(pillar.print_max = 10,
        pillar.print_min = 5,
        tibble.width = Inf)


#Tibble(view)
nycflights13::flights %>% View

#data frame
head(iris, 10)
tail(iris)
?print.data.frame



#subsetting
tb <- tibble(x = 1:5,
             y = 11:15)
 
tb$y; tb[["y"]];tb[[2]]
# Extract by name
tb$x; tb[["x"]]
#pipe
tb %>% .$x  #数据框 tb 的列 x 提取出来，并返回一个向量

as.data.frame(tb) # tb to dataFrame
class(tb)
class(as.data.frame(tb))


#===================================================
library(nycflights13)
library(tidyverse)
?flights
 (flights)
#====filter
(jan2 <- filter(flights, month == 1, day == 2))
on_schedule <- filter(flights, arr_delay <= 20, dep_delay <= 20)
on_time_departure <- filter(flights, between(dep_delay, -1, 1))

# same results
nov_dec <- filter(flights, month == 11 | month == 12)
nov_dec2 <- filter(flights, month == 11 & day == 12)
nov_dec_v2 <- filter(flights, month %in% c(11, 12))

#=====arrange
arrange(flights,year,month,desc(dep_delay))
arrange(flights,year,month,-dep_delay)  # desc = "-"
#=====select
select(flights, year,month,day)
flights
select(flights, year:arr_time) #from year to arr_tiime
select(flights, -(year:day)) # except
 
select(flights, starts_with("dep"), tailnum)
select(flights, contains("dep")) 
select(flights, time_hour, air_time, everything()) #move colums
select(flights, everything())  
(flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time
))
#======mutate
mutate(flights, hours= air_time/60)
transmute(flights,hours = air_time/60) # only new col

#======group_by
by_month <- group_by(flights, month)
#对 dep_delay 列进行求平均值的操作。na.rm = TRUE 表示在计算平均值时忽略缺失值
delay_by_month <- summarise(by_month, delay = mean(dep_delay, na.rm = TRUE)) 
arrange(delay_by_month,-delay)

summarise(by_month,
          avg_arr_delay1 = mean(arr_delay,na.rm = TRUE),
          avg_arr_delay2 = mean(arr_delay[arr_delay>0],na.rm=TRUE))

daily <- group_by(flights, year,month,day)
(per_day <- summarise(daily,flights=n()))
(per_month <- summarise(per_day, flights = sum(flights))) 
(per_year <- summarise(per_month, flights = sum(flights))) 


#===================================================pipe

library(magrittr) #pipe lib

x <- 1:4

#1
mean(x^2)
#2
x^2 %>% mean() 
x^2 %>% mean

#3
x^2 |> mean()
# x^2 |> mean  # error, must be mean()



by_month <- group_by(flights, month)
delay_by_month <- summarise(by_month,
                            delay = mean(dep_delay, na.rm = TRUE))
arrange(delay_by_month, -delay)

flights %>%
group_by( month) %>%
  summarise(delay = mean(dep_delay, na.rm = TRUE)) %>%
  arrange(-delay)


flights %>% filter(month==1)

#==========================
group1 = filter(flights,month==1)
class(group1)
#==========================
df <- data.frame(x = c(1, 2, 3),
                 y = c(4, 5, 6))

# 对每行进行求和操作
result <- df %>%
  rowwise() %>%
  mutate(total = sum(x, y))

print(result)
#==========================

flights %>% rowwise() %>% mutate(finalMark = max(dep_time,sched_dep_time)) %>% arrange(finalMark)

exam = select(flights,year,month,day) %>% arrange(day)
exam

# Generate the sequence of even numbers from 0 to 20
even_sequence <- seq(0, 20, by = 2)

even_sequence
length(even_sequence)
even_sequence <- even_sequence[-length(even_sequence)]
# Reshape the sequence into a 5x2 matrix
even_matrix <- matrix(even_sequence, nrow = 5, byrow = TRUE)
even_matrix
 

















