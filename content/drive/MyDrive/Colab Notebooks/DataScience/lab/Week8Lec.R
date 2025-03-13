#----COMP828 Week 8
library(tidyverse)
library(cowplot)

double_quote <- "\"" # or '"'
writeLines(double_quote)
single_quote <- '\'' # or "'"

newline <- "This is the first line\nThis is the second line"
writeLines(newline)

str_c(c("x", "y", "z"), collapse = ", ")
str_c(c("x", "y", "z"), collapse = "")

str_view(c("abc", "a.c", "bef"), "a[.]c")
str_view(c("abc", "a.c", "bef"), "a.c")




x <- c("apple pie", "apple", "apple cake")
str_view(x, "[aeiou]")
str_view(x, "[whateveryoulike]")
str_view(x, "[^aeiou]")
str_view(x, "^[aeiou]")
# 
dir(pattern = "\\.pdf$")
# 
colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match

head(sentences)


has_colour <- str_subset(sentences, colour_match)
head(has_colour, 4)

?parse_date_time


x1 <- c("Dec", "Apr", "Jan", "Mar")
x2 <- c("Dec", "Apr", "Jam", "Mar")

x1 <- c("Dec", "Apr", "Jan", "Mar")
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)
(y1 <- factor(x1, levels = month_levels))
sort(y1)

factor(x2, levels = month_levels)

forcats::fct(x1, levels = month_levels)
(y2 <- forcats::fct(x2, levels = month_levels))

(x <- tibble(m = c("Dec", "Apr", "Jan", "Mar", "Mar") ) %>%
    arrange(m))
(x <- x %>%
    mutate(m_fct = fct(m, levels = month_levels))%>%
    arrange(m_fct))
p1 <- ggplot(data = x) + geom_bar(aes(m_fct)) +
  ggtitle("drop = TRUE")
p2 <- ggplot(data = x) + geom_bar(aes(m_fct)) +
  scale_x_discrete(drop = FALSE) +
  ggtitle("drop = FALSE")
cowplot::plot_grid(p1, p2)

forcats::gss_cat

(relig_summary <- gss_cat %>%
    group_by(relig) %>%
    summarise(
      age = mean(age, na.rm = TRUE),
      tvhours = mean(tvhours, na.rm = TRUE),
      n = n()
    ))

p1 <- ggplot(relig_summary,
              aes(tvhours, relig)) + geom_point() +
   ggtitle("Original")
p1
p2 <- ggplot(relig_summary,
             aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point() + ggtitle("Reordered")
p2
cowplot::plot_grid(p1, p2)

levels(gss_cat$rincome)

(rincome_summary <- gss_cat %>%
    group_by(rincome) %>%
    summarise(
      age = mean(age, na.rm = TRUE),
      tvhours = mean(tvhours, na.rm = TRUE),
      n = n() ))

rincome_summary <- rincome_summary %>%
  mutate(rincome = fct_relevel(rincome, "Not applicable"))
ggplot(rincome_summary, aes(age, rincome)) +
  geom_point()

(by_age <- gss_cat %>%
    filter(!is.na(age)) %>%
    count(age, marital) %>%
    group_by(age) %>%
    mutate(prop = n / sum(n)))

p1 <- ggplot(by_age, aes(age, prop, colour = marital)) +
  geom_line(na.rm = TRUE) + ggtitle("Original")
p2 <- ggplot(by_age, aes(age, prop,
                         colour = fct_reorder2(marital, age, prop))) +
  geom_line() + labs(colour = "marital") + ggtitle("Reordered")
cowplot::plot_grid(p1, p2)


p1 <- gss_cat %>%
  mutate(marital = marital) %>%
  ggplot(aes(y=marital)) +
  geom_bar() +
  ggtitle("Original")

p2 <- gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(y=marital)) +
  geom_bar() +
  ggtitle("Reordered")

cowplot::plot_grid(p1,p2)
