
# ------ Install the all packages that required in this project------
# List of packages
packages <- c("tidyverse", "nycflights13")
# Find packages that are not installed
packages_to_install <- packages[!(packages %in% installed.packages()[,"Package"])]
# Install required packages
if(length(packages_to_install) > 0){
  install.packages(packages_to_install,
                   dependencies=TRUE)
}


# ------ Load new packages ------
sapply(packages, library, character.only = TRUE)

# 2.Consider the following data sets about student grades
COMP828exams <- tribble(
                        ~studID, ~exam_mark,
                        1, "A",
                        2, "B",
                        3, "C+"
                      )

class(COMP828exams)
dim(COMP828exams)

COMP828classlist <- tribble(
                      ~studentID, ~name, ~programme,
                      1, "Charlotte", "CIS",
                      2, "Zoe", "CIS",
                      3, "Caitlin", "MA",
                      4, "Abel", "MSc"
                    )

class(COMP828classlist)
dim(COMP828classlist)


STAT800classlist <- tribble(
                      ~studentID, ~name,
                      1, "Charlotte",
                      2, "Zoe",
                      6, "Conor",
                      7, "Archie"
                    )

# 2.1 Create a dataset containing the name, ID and exam mark of all COMP828 students.
# Include students who didn’t sit the exam
COMP828classlist %>% left_join(COMP828exams,by= c("studentID" = "studID"))


# 2.2 Create a dataset containing the name, ID and exam mark of the COMP828 students who
# sat the exam.
COMP828classlist %>% right_join(COMP828exams, by = c("studentID" = "studID"))

# 2.3 Create a dataset containing the name, ID and exam mark of the COMP824 students who
# sat the exam.
COMP828classlist %>% semi_join(COMP828exams, by = c("studentID"="studID"))

# 2.4 Which students didn’t sit the COMP824 exam?
COMP828classlist %>% (COMP828exams, by = c("studentID" = "studID"))

# 2.5 Create a dataset containing the name and ID of all students studying either COMP824
# or STAT800 or both. Ensure your new dataset has only 2 columns: one for ID and one
# for name.
COMP828classlist %>% select(-programme) %>% full_join(STAT800classlist, by = c("studentID"="studentID", "name"="name"))

COMP828classlist  %>% full_join(STAT800classlist, by = c("studentID"="studentID", "name"="name"))

# 2.6 Create a dataset containing the name and ID of all students studying both COMP824
# and STAT800. Ensure your new dataset has only 2 columns: one for ID and one for
# name.
COMP828classlist %>%
  inner_join(STAT800classlist, by =c ("studentID"="studentID", "name"="name"))
# -----------------------------------------------------------------------------------------
# left_join:  This function will retain all rows from the left data frame and merge the data based on matches in the right data frame. 
#             If there is no match in the right data frame, fill in missing values ​​(NA).

# right_join: This function retains all rows from the right data frame and merges the data based on matches in the left data frame.
#             If there is no match in the left data frame, fill in the missing values.

# inner_join: This function will only retain the matching rows in the two data frames, that is, retain the intersection part.

# semi_join:  This function will return the rows in the left data frame that exist in the right data frame, 
#             but will not merge the data, only retaining the rows in the left data frame.

# anti_join:  This function returns the rows in the left data frame that do not exist in the right data frame.
#             It does not merge the data and only retains the rows in the left data frame.

# full_join:  This function retains all rows in both data frames and merges the data based on matches.  
#             If there is no match in a data frame, missing values ​​are filled.


# -----------------------------------------------------------------------------------------

# ----------------------------- flights -----------------------------------
# 3. Load the package nycflights13. Use the appropriate join function to create a dataset
# that can answer the following questions. You will need to you some other functions well
# (e.g. filter).

# 3.1 Create a table showing the names of the destinations that JetBlue Airways flies to. Include
# a column showing the number of flights to each destination.
selected_airlines <- airlines %>% filter(name %in% c("JetBlue Airways"))
jetblue <- flights %>%
  semi_join(selected_airlines, by = "carrier") %>%
  count(dest) %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  select(dest, name, n)
jetblue

# 3.2 What destinations do both JetBlue Airways and United Air Lines Inc (UA) fly to?
united <- flights %>%
  filter(carrier == "UA") %>%
  count(dest) %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  select(dest, name, n)
inner_join(jetblue, united, by = c("dest" = "dest", "name" = "name"),
           suffix = c("JetBlue", "United"))


# 4. Use ggplot to construct a bar plot showing the number of flights per month. Add a title
# and subtitle to your plot.
flights %>% group_by(month) %>%
  summarize(Number_of_Flights = n())%>%
  ggplot()+
  geom_col(mapping = aes(x = month, y = Number_of_Flights),
           fill = "darkorchid4")+
  labs(title = "Monthly Total Flights",
       subtitle = paste("2013"),
       y = "Number of Flights",
       x = "Time") + theme_bw(base_size = 15) +
  scale_x_continuous("Month", breaks = 1:12, labels = month.abb )


# 5. Join flights and airports plot flight paths of 10 flights using longitude and latitude.
flights_loc <- flights %>%
  select(carrier, flight, tailnum, origin, dest) %>%
  inner_join(select(airports, faa, name, lat, lon),
             by = c("origin"="faa")) %>%
  inner_join(select(airports, faa, name, lat, lon),
             by = c("dest"="faa"),
             suffix = c("_origin", "_dest"))
flights_loc %>%
  slice_head(n= 10) %>%
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


# 6. Challenge: Create a plot showing a line between the 20 most common origin/destination
# pairs. Use line thickness to represent the frequency with which flights fly between the two
# locations, and colour to represent the origin.
# Multiple solutions are possible. This is one.
# Find most common origin/destination pairs.
orig_dest_freq <- flights %>%
  count(origin, dest) %>%
  inner_join(select(airports, faa, name, lat, lon),
             by=c("origin"="faa")) %>%
  inner_join(select(airports, faa, name, lat, lon),
             by=c("dest"="faa"),
             suffix = c("_origin", "_dest")) %>%
  arrange(-n)
# select 20 most common pairs
top_orig_dest_freq <- orig_dest_freq %>%
  slice_head(n=20)
# identify unique destinations
top_dest_freq <- top_orig_dest_freq %>%
  select(dest, lat_dest, lon_dest, name_dest) %>%
  distinct()

# plot top 20 origin/destination pairs
# create plot
p <- top_orig_dest_freq %>% ggplot() +
  geom_segment(mapping = aes(
    x = lon_origin, xend = lon_dest,
    y = lat_origin, yend = lat_dest,
    col = origin,
    linewidth = n,
    alpha = 0.8)) +
  # customise transformation used for line width
  scale_linewidth("Number of flights", range = c(1, 5),
                  trans = "log10") +
  # add map of USA States
  borders(database = "state") +
  # specify aspect ratio of map
  coord_quickmap() +
  # add labels showing destination faa code
  geom_text(mapping = aes(x = lon_dest, y = lat_dest, label = dest),
            nudge_x = -1,
            data = top_dest_freq) +
  # add point showing destination faa code
  geom_point(mapping = aes(x = lon_dest,
                           y = lat_dest)) +
  # add customise labels
  labs(y = "Latitude", x = "Longitude",
       title = "20 most common routes flown from NYC in 2013",
       colour = "Origin") +
  guides(alpha = "none")


p