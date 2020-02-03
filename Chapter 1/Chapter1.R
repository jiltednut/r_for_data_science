library(tidyverse)
library(maps)
####################################################################
# Exercises: ggplot introduction.

# Exercise 1: I see a blank coordinate grid.
ggplot(data = mpg)

# Exercise 2: 11 columns with 234 observations.
dim(mpg)

# Exercise 3: drv describes the drive type i.e. fr, ff or 4wd.
?mpg

# Exercise 4:
ggplot(data = mpg, aes(x = cyl, y = hwy)) +
  geom_point(aes(colour = drv))

glimpse(mpg)

# Exercise 5: This plot is not useful because both variables are categorical.
ggplot(data = mpg, aes(x = class, y = drv)) + 
  geom_point()

####################################################################
# Examples: Adding color as an aesthetic property
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))


# Exercises: Aesthetics
# Exercise 1: the color parameter was passed as an aesthetic mapping rather than as an aesthetic outside the aes function.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# Exercise 2:
?mpg
glimpse(mpg)

# Exercise 3:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = fl, y = cty, size = hwy))

# Exercise 4:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = fl, y = cty, size = cty))

# Exercise 4:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = fl, y = cty, size = cty))

# Exercise 6:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = fl, y = cty, colour = cty > 20))


####################################################################
# Examples: Adding facets to plots
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~class, nrow = 2)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(drv ~ cyl)


# Exercises: Facet Wrapping

# Exercise 1:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = hwy)) +
  facet_wrap(~cty)

# Exercise 2:
ggplot(data = mpg) +
       geom_point(mapping = aes(x = drv, y = cyl))

# Exercise 3: 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(class, nrow = 2)
  
# Exercise 4: 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~class, nrow = 2)
  
# Exercise 5: 
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_map(~class)


####################################################################
# Geometric Object

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, col = drv)) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv), show.legend = FALSE)

ggplot(data = mpg) + 
       geom_point(mapping = aes(x = displ, y = hwy)) +
         geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(data = filter(mpg, class == "subcompact"), 
              se = FALSE)


## Exercise:
# 1. 
ggplot(data = mpg, aes(x = hwy)) +
  geom_histogram()

ggplot(data = mpg, aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg, aes(x = cty, y = hwy)) +
  geom_line()

ggplot(data = mpg, aes(x = hwy, y = class)) +
  geom_area()


# 2.
ggplot(
  data = mpg,
  mapping = aes(x = displ, y = hwy, color = drv)
) +
  geom_point() +
  geom_smooth(se = FALSE)


# 3.

# 4.
?geom_smooth

# 5.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  ) +
  geom_smooth(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  )

# 6.
# a
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

# b
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point() +?geom_point
  geom_smooth(se = FALSE, aes(class = drv))

# c
ggplot(data = mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE, aes(class = drv))
  
# d
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(se = FALSE)

# e
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) + 
  geom_smooth(se = FALSE, aes(linetype = drv))

# f
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(size = 4, aes(color = "white")) +
  geom_point(aes(color = drv))

?geom_point              



##### Statitical Transformations

# Exercises
# 1
ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth), 
    fun.ymin = min,
    fun.ymax = max, 
    fun.y = median
  )
?stat_summary

ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = "summary",
    fun.ymin = min, 
    fun.ymax = max, 
    fun.y = median
  )
?geom_pointrange

# 2
?geom_col

?stat_smooth

# 5

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop.., group = 1))


#### Position Adjustments
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

# Set position to fill for 100% stacked bar chart
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

# Adding jitter to scatterplots
ggplot(data = mpg) +
  geom_point(
    mapping = aes(x = displ, y = hwy), 
    position = "jitter"
  )
ggplot(data = mpg) +
  geom_jitter(mapping = aes(x = displ, y = hwy))

### Exercises
# 1

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()

# 2

# The parameters to control jitter in geom_jitter are width & height
?geom_jitter

# 3


# 4
?geom_boxplot
ggplot(data = mpg, aes(x = drv, y = hwy, color = class)) + 
  geom_boxplot(position = "dodge2")

ggplot(data = mpg, aes(x = drv, y = hwy, color = class)) + 
  geom_boxplot(position = "identity")

#### Coordinate System

# Using coord_flip() - switches the plot axes
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()


# Using coord_quickmap - automatically adjust the aspect ratio of the plot
nz <- map_data("nz")
?map_data

ggplot(data = nz, mapping = aes(x = long, y = lat, group = group))+
  geom_polygon(fill = "white", color = "black")

ggplot(data = nz, mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

# Using cood_polar - Plots on circular plane
bar <- ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut),
  show.legend = FALSE,
  width = 1) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)
  
bar
bar + coord_flip()
bar + coord_polar()


### Exercises

# 1
# Build pie charts using a stacked bar chart and adding polar coordinates
ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar()

ggplot(data = mpg, aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y")

ggplot(data = mpg, aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar()

# 2
# labs() adds the ability to label the plot
?labs

# 3
?coord_map

# 4
p <- ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline()

p
p + coord_fixed()
  

#### The Layer Grammar Of Graphics






