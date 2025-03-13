iris
head(iris)
library(tidyverse)
as_tibble(iris)


class(as_tibble(iris))
class(iris)

tibble(
  x = 1:3,
  y = 1,
  z = x^2 + y,
  `x squared` = x^2
)

tribble(
  ~x, ~y, ~Z,
  #----------
  "a", 2, 3.6,
  "b", 1, 8.5
)

as_tibble(iris) %>% print(n = 20)
options(pillar.print.max = 5,  # should be pillar.print_max
        pillar.print.min = 3,  # should be pillar.print_min 
        tibble.width = 70)

View(as_tibble(iris))

head(iris, 2)

tb <- tibble(x = 1:5, 
             y = 11:15)

tb$x
tb[["x"]]
tb[[1]]
tb %>% .$x

class(tb)
class(as.data.frame(tb))

library(nycflights13)
?flights

flights

arrange(flights, desc(dep_delay))

select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

select(flights, starts_with("dep"), tailnum)
select(flights, contains("dep"), tailnum)

select(flights, time_hour, air_time, everything())

transmute(flights,
         dep_time,
         hour = dep_time %/% 100,
         minute = dep_time %% 100)
