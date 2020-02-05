library(tidyverse)
library(nycflights13)

### Exploratory Data Analysis

## Covariation

## Examples

# In order to view covariance between categorical and continuous variables, it is 
# reasonable to use the geom_freqpoly. However, the difficulty in this case is that 
# freqpoly uses count to determine it height on the y-axis. This means that values 
# with a small number of observations are difficult to understand in the wider context.

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), bindwidth = 500)

# Because the overall counts differ so much, its hard to see the distribution of the lower
# volume cuts. 

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

# To make the comparison easier, rather than using count as the y variable, we
# can use density instead. Where density is a the frequency density of each point.

ggplot(data = diamonds, 
       mapping = aes(x = price, y = ..density..)
       ) +
  geom_freqpoly(mapping = aes(color = cut))

diamonds %>% 
  group_by(cut) %>% 
  summarise(avg_price = mean(price, na.rm = TRUE))

# It appears that Ideal diamonds (highest quality) have a lower average price that 
# Fair diamonds (lowest quality) but that could be due to a number of reasons.
# Looking at physical sizes, Fair diamonds tend to be bigger
diamonds %>% 
  group_by(cut) %>% 
  summarise(avg_price = mean(z, na.rm = TRUE))

head(diamonds)

# An alternative to the freqpoly density plot is to use a boxplot.
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

# Cut is an ordered categorical variable i.e. fair < Good < Very good etc..
# Many categorical variables do not have an instrinsic order so it is important to 
# have the option to reorder as necessary.

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

# For this plot of highway mileage by class, it might be easier to notice a trend
# if the class are reordered by median highway mileage

ggplot(data = mpg) +
  geom_boxplot(
    mapping = aes(
      x = reorder(class, hwy, FUN = median), 
      y = hwy
    )
  )

# To emhance the plot, because of the long, overlapping class names
# use coord_flip() to turn the boxpplot 90 degrees
ggplot(data = mpg) +
  geom_boxplot(
    mapping = aes(
      x = reorder(class, hwy, FUN = median),
      y = hwy
    )
  ) +
  coord_flip() +
  labs(x = "Class", y = "Highway MPG")

####################################################
## Exercises
## Question 1

# Use what you’ve learned to improve the visualization of the
# departure times of cancelled versus noncancelled flights.
flights %>% 
  mutate(status = ifelse(is.na(dep_time), "cancelled", "ok")) %>% 
  ggplot(mapping = aes(x = sched_dep_time, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = status)) +
  xlim(c(0, 2400))

flights %>% 
  mutate(status = ifelse(is.na(dep_time), "cancelled", "ok")) %>% 
  ggplot() +
  geom_boxplot(mapping = aes(x = status, y = sched_dep_time))

# Viewing the time series by time rather tha hour shows that flights scheduled
# for before 1pm tend to be cancelled less often that flights in the afternoon / evening.
# This may make sense considering that airlines would probably try to prevent cancellations
# and so put off cancelling a flight unless all options have been exhausted which takes 
# time and may be more likely to occur later in the evening.

## Question 2

# What variable in the diamonds dataset is most important for predicting the price of a 
# diamond? 
# How is that variable correlated with cut? 
# Why does the combination of those two relationships lead to lower quality diamonds 
# being more expensive?

glimpse(diamonds)

# First we examine numeric correlation
diamonds_n <- select(diamonds, carat, depth, table, price, x, y, z)
corrplot::corrplot(cor(diamonds_n))


# Carat and the size dimension are very highly correlated. We can ignore the dimension
# as carat relates to size and so with represent much of the information available in each
# of the dimensions.

# Using carat, cut, color & clarity as depth and table both have weak relationships.
ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point(mapping = aes(color = clarity))

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

# Carat is obvious strongly related to price.
# Clarity seems to decrease as the carat size increases

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point(mapping = aes(color = color))
# Small diamonds appear to also have a better color
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = color, y = price))

ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = color, y = carat))

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point(mapping = aes(color = cut))
# Small diamonds appear to also appear to have a better cut.
ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = cut, y = price))

ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = cut, y = carat))

# It seems that small diamonds tend to have better characteristics that larger diamonds.
# As diamonds lose their descriptive qualities, the price commanded is maintained by
# selling a larger diamond. eg. an ideal, best color, best cut 1 ct diamond will cost the
# same, 15k, as a very good cut diamond, with medium color and medium clarity but 
# is 2 - 2.5 ct.
# This suggests that larger diamonds can command a higher price with poorer characteristics.
# Small diamonds need the best characteristics to sell for high prices.


# Question 4

# One problem with boxplots is that they were developed in an era of much smaller 
# datasets and tend to display a prohibitively large number of “outlying values.” 
# One approach to remedy this problem is the letter value plot. 
# Install the lvplot package, and try using geom_lv() to display the distribution of 
# price versus cut. What do you learn? How do you interpret the plots?
install.packages("lvplot")





             