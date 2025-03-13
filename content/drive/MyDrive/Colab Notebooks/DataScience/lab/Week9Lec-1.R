#----COMP828 Week 9
library(tidyverse)
#install.packages("nycflights13")
library(nycflights13)

flights
airlines
planes
airports
weather

planes %>%
  count(tailnum) %>%
  filter(n > 1) # unique

weather %>%
  count(year, month, day, hour, origin) %>%
  filter(n > 1) # not unique


#----Surrogate Key Small Exampl

(tb <- tibble(x=c("A","B","B"), y=c(4,6,6)) )
tb %>% count(x, y)%>% filter(n > 1)
tb %>% mutate(surrogate_key = row_number())


#-----Joins

flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

flights2 %>%
  # remove columns for easier printing
  select(-origin, -dest) %>%
  # left join by carrier code
  left_join(airlines, by = "carrier")


#----Different Joints Small Example
(x <- tribble( ~key, ~val_x, 1, "x1", 2, "x2", 3, "x3" ))
(y <- tribble( ~key, ~val_y, 1, "y1", 2, "y2", 4, "y3" ))

x %>%
  inner_join(y, by="key")

x %>%
  left_join(y, by="key")

x %>%
  right_join(y, by="key")

y %>% left_join(x,by="key")   #same

x %>% full_join(y, by="key")

x %>% full_join(y)    #Natural Join

#----Back to flights
flights2 %>% left_join(weather)
flights2 %>% left_join(planes, by = "tailnum")

flights2 %>% left_join(airports, c("dest" = "faa"))   #diff names but same variable


#----Semi and Anti join - small example
(exams <- tribble(~studID, ~grade,
                  1, "A",
                  2, "B",
                  3, "C+",
                  5, "D" ))

(classlist <- tribble( ~studentID, ~name,
                       1, "Charlotte",
                       2, "Zoe",
                       3, "Caitlin",
                       4, "Abel" ))

classlist %>%
  semi_join(exams, by=c("studentID"="studID"))

classlist %>%
  anti_join(exams, by=c("studentID"="studID"))

exams %>%
  anti_join(classlist, by=c("studID"="studentID"))

#----Back to Flights
top_dest <- flights %>% count(dest, sort = TRUE) %>%
  slice_head(n = 10) %>% print(n = 10)

#----Flights with dest in top_dest
flights %>% semi_join(top_dest)

#----Flights whose plane is not in "planes" (Ghost planes)
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)

#----Producing Maps using Flights data
flights_loc <- flights %>%
  select(carrier, flight, tailnum, origin, dest) %>%
  inner_join(select(airports, faa, name, lat, lon),
             by = c("origin"="faa")) %>%
  inner_join(select(airports, faa, name, lat, lon),
             by = c("dest"="faa"),
             suffix = c("_origin", "_dest"))


flight_paths_plot <- flights_loc %>%
  slice_head(n= 100) %>%
  ggplot() +
  geom_segment(mapping = aes(
    x = lon_origin, xend = lon_dest,
    y = lat_origin, yend = lat_dest,
    col = origin),
    arrow = arrow(length = unit(0.1, "cm"))) +
  borders(database = "state") +
  #borders(database = "world") +
  coord_quickmap() +
  labs(y = "Latitude", x = "Longitude")

flight_paths_plot


(dest_freq <- flights %>%
    count(dest) %>%
    inner_join(airports, by=c("dest"="faa")) %>%
    arrange(-n) )

common_dest_plot <- ggplot() +
  geom_point(data = dest_freq,
             aes(x = lon , y = lat, size = n),
             alpha = 0.5, col = "blue") +
  borders(database = "state") +
  #borders(database = "world") +
  coord_fixed(1.3) +
  guides(fill=FALSE, scale = "none")

common_dest_plot