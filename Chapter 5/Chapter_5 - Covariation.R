library(tidyverse)
library(nycflights13)

### Exploratory Data Analysis

## Covariation
## A categorical and continuous variable

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
# install.packages("lvplot")
library("lvplot")
ggplot(data = diamonds) +
  geom_lv(mapping = aes(x = cut, y = price))

ggplot(data = diamonds) +
  geom_violin(mapping = aes(x = cut, y = price))

# Question 5

# Compare and contrast geom_violin() with a faceted geom_histogram(), 
# or a colored geom_freqpoly() . 
# What are the pros and cons of each method?

# For each plot we can consider cut vs price from the diamonds dataset.
# Coloured Freqpoly
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut))

# Faceted histogram
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram() +
  facet_wrap(~cut, ncol = 1, scales = "free_y")

# Violin plot
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_violin() +
  coord_flip()

# The geom_freqpoly() is better for look-up: meaning that given a price, 
# it is easy to tell which cut has the highest density. However, the overlapping lines 
# makes it difficult to distinguish how the overall distributions relate to each other. 
# The geom_violin() and faceted geom_histogram() have similar strengths and weaknesses. 
# It is easy to visually distinguish differences in the overall shape of the distributions 
# (skewness, central values, variance, etc). However, since we can’t easily compare the 
# vertical values of the distribution, it is difficult to look up which category has the 
# highest density for a given price. 
# All of these methods depend on tuning parameters to determine the level of smoothness of 
# the distribution.

## Colored freqpoly:
# Strength:
#   Easy to lookup i.e. compare densities of distribution.
# Weakness:
#   Overlapping lines can make it difficult to see how the different distributions relate
#   to each other. This is compounded as the number of factor levels increases.

## Faceted histogram:
# Strength:
#   Easy to compare the characteristics of each distribution i.e. skewness, central tendency,
#   variance etc.)
# Weakness:
#   It is difficult to compare the density at a certain point as we can't, easily, compare 
#   vertical values.

# Question 6
# If you have a small dataset, it’s sometimes useful to use geom_jitter() to see the 
# relationship between a continuous and categorical variable. 
# The ggbeeswarm package provides a number of methods similar to geom_jitter() . 
# List them and briefly describe what each one does.

# install.packages("ggbeeswarm")
library(ggbeeswarm)

# There are two methods:
# 1 - geom_quasirandom(): produces plots that are a mix of jitter and violin plots. 
# 2 - geom_beeswarm(): produces a plot similar to a violin plot, but by offsetting the points.

# As jitter, generally, works best with a smaller dataset, we work with the mpg data rather
# than diamonds or flights as previously.
# Plotting highway mpg vs class
ggplot(data = mpg) +
  geom_quasirandom(mapping = aes(
    x = reorder(class, hwy, FUN = median),
    y = hwy
  )) +
  labs(x = "class", title = "Quasirandom")

? geom_quasirandom
# From the documentation of quasirandom, we can see there are 4 methods
# to distribute the points: 
# quasirandom, pseudorandom, smiley and frowney
# quasirandom is the default method.

ggplot(data = mpg) +
  geom_quasirandom(mapping = aes(
    x = reorder(class, hwy, FUN = median),
    y = hwy
  ),
  method = "pseudorandom") +
  labs(x = "class", title = "Pseudorandom")

ggplot(data = mpg) +
  geom_quasirandom(mapping = aes(
    x = reorder(class, hwy, FUN = median),
    y = hwy
  ),
  method = "smiley") +
  labs(x = "class", title = "Smiley")

ggplot(data = mpg) +
  geom_quasirandom(mapping = aes(
    x = reorder(class, hwy, FUN = median),
    y = hwy
  ),
  method = "frowney") +
  labs(x = "class", title = "Frowney")

# beeswarm plot
ggplot(data = mpg) +
  geom_beeswarm(mapping = aes(
    x = reorder(class, hwy, FUN = median), 
    y = hwy)
    ) +
  labs(x = "class", title = "Beeswarm")





