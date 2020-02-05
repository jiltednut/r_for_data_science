library(tidyverse)
library(nycflights13)

### Exploratory Data Analysis
## Missing Values

## Examples
# When dealing with missing values and are not in the mood to imputate values,
# there are 2 options, discard the observations completely or mark the datapoints as NA
# and  use na.rm = TRUE when processing that variable.

# Discard the rows.
(diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20)))

# Convert missing values to NA
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

# Option number 2 has the advantage of retaining the non missing values for other variables
# in the dataset. When operating on these NA values, ggplot will display a warning telling
# you that missing data has been excluded.

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point()

# To suppress this warning use na.rm - TRUE

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point(na.rm = TRUE)

flights %>% 
  mutate(
    cancelled = is.na(dep_time), 
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(
    mapping = aes(color = cancelled), 
    binwidth = 1/4
  )


## Exercises
####################################################
## Question 1

# What happens to missing values in a histogram? 
# What happens to missing values in a bar chart? 
# Why is there a difference?

?geom_bar # default statistical function - count
?geom_histogram # default statistical function - bin

# Plot a histrogram with NAs
ggplot(data = diamonds2, mapping = aes(x = y)) +
  geom_histogram(binwidth = 0.01)

# Plot a bar chart with NAs
diamonds2 %>% 
  mutate(cutb = ifelse(is.na(y), NA_character_, as.character(cut))) %>% 
  ggplot() +
  geom_bar(mapping = aes(x = cutb))

# The difference is bar chart counts the number of unique categorical values
# Bar chart adds a separate bar, treating NA as a distinct category.
# Histogram bins the numeric values so missing values get rolled up.


## Question 2

# What does na.rm = TRUE do in mean() and sum() ?

# na.rm removes NA from the vector being processed before calculating.





