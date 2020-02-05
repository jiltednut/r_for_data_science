library(tidyverse)
data("diamonds")

### Exploratory Data Analysis
## Variation

## Exercises
####################################################
## Question 1

# Explore the distribution of each of the x , y , and z variables in
# diamonds . 
# What do you learn? 
# Think about a diamond and how you might decide which dimension 
# is the length, width, and depth.
? diamonds
diamonds

# x represents the length
# y represents the width 
# z represents the depth

# Histogram of x
ggplot(data = diamonds, mapping = aes(x = x)) +
  geom_histogram(binwidth = 0.25)
# There are a number of x diamonds with an x value close to or equal to 0.
# We can zoom in to check the quantity.
ggplot(data = diamonds, mapping = aes(x = x)) +
  geom_histogram(binwidth = 0.1) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 10))
# There are 8 diamonds with a length of 0, suggesting measurememt errors.
# Removing these from the data and replotting
diamonds %>% 
  filter(x > 0) %>% 
  ggplot(mapping = aes(x = x)) +
  geom_histogram(binwidth = 0.25)
# There are some very long diamonds that need to be investigated
diamonds %>% 
  filter(x > 8) %>% 
  ggplot(mapping = aes(x = x, y = y)) +
  geom_point()
# There appears to be one extreme outlier (examined below) with y = ~60
# The remaining values seem plausibly large and rare.
# We can plot the price vs length to see if any are underpriced, suggesting a
# measurement error
diamonds %>% 
  filter(x > 9) %>% 
  ggplot(mapping = aes(x = x, y = price)) +
  geom_point(mapping = aes(color = clarity))

# Although some diamonds are cheaper, they also tend to be lower clarity.
# After removing the 0 length diamonds, all x values seem valid.

# Histogram of y
ggplot(data = diamonds, mapping = aes(x = y)) +
  geom_histogram(binwidth = 0.25)
# There appear to be some outliers in the data. We can assert this due to the range of the
# x-axis and because there are no visible data points.
# We can zoom in using coord_cartesian with a small valie of "count" i.e. 30 and a wider binwidth.
# We can then tweak the parameters to zoom in or out further.
ggplot(data = diamonds, mapping = aes(x = y)) +
  geom_histogram(binwidth = 1) +
  coord_cartesian(ylim = c(0, 30))
# There are a number of values at 0, this suggests a measurement error and the values at
# ~30 and ~60 require further investigation.
diamonds %>% 
  arrange(desc(y)) %>% 
  head()
# Both of the y outliers appear to be measurement errors.#
# The price in the context of other similarly sized diamonds suggests that either these
# diamonds are extremely under priced or the dimensions are incorrect.

# Histogram of z
ggplot(data = diamonds, mapping = aes(x = z)) +
  geom_histogram(binwidth = 0.5)
diamonds %>% 
  count(cut_width(z, 1))
# The majority of values occur between 2 & 6
# 20 values appear at ~0, and a number are greater than 6.5.
# Looking at the values < 1
diamonds %>% 
  filter(z < 1.5) %>% 
  arrange(desc(z))
# after removing the 0 values, measurement errors, we can look at the lower values in the range.
# While there are 2 diamonds with a depth of ~1, it is necessary to see these in the context
# of similar diamonds
diamonds %>% 
  filter(z>1) %>% 
  arrange(z)
# There are 3 diamonds with z < 2 where the dimensions, cut and price suggest that 
# there has been a measurement error. These 3 have an ideal cut, have x & y dimensions
# larger than their "z peers" and a substantially larger price.


## Question 2

# Explore the distribution of price . Do you discover anything
# unusual or surprising? (Hint: carefully think about the bin
# width and make sure you try a wide range of values.)

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 100, center = 0)

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 50, center = 0)

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 10, center = 0)


# There are a number of gaps in pricing when using a binwidth on 50/10
# One at ~1400 and one at ~2000
# Zooming in to diamonds with a price below $2000 to see if there is anyting interesting.
diamonds %>% 
  filter(price < 2000) %>% 
  ggplot(mapping = aes(x = price)) +
    geom_histogram(binwidth = 10, center = 0)

## Question 3

# How many diamonds are 0.99 carat? How many are 1 carat?
# What do you think is the cause of the difference?

diamonds %>% 
  filter(carat > 0.95 & carat < 1.05) %>% 
  ggplot(mapping = aes(x = carat))+
  geom_histogram(binwidth = 0.005, center = 1)

diamonds %>% 
  filter(carat > 0.95 & carat < 1.05) %>% 
  count(carat)

