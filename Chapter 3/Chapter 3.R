library(tidyverse)
library(nycflights13)
#### Using filter
## Exercises

# 1
# a 
flights
filter(flights, arr_delay > 120)

filter(flights, dest %in% c("IAH", "HOU"))

unique(flights$carrier)
filter(flights, carrier %in% c("UA", "AA", "DL"))

filter(flights, month >= 7 & month <=9)

filter(flights, dep_delay <= 0 & arr_delay >= 120)

filter(flights, dep_delay >= 60 & dep_delay - arr_delay > 30)

filter(flights, dep_time >= 0000 & dep_time <= 0600) # Error as midnight = 2400
filter(flights, dep_time %% 2400 <= 600)

# 2
filter(flights, between(month, 7, 9))
filter(flights, between(dep_time, 0, 600))


# 3
summary(flights)


#### Using arrange

## Exercises
# 1
arrange(flights, desc(is.na(dep_delay)))
arrange(flights, desc(is.na(dep_delay)), dep_delay)

# 2
arrange(flights, desc(dep_delay))
arrange(flights, dep_delay)

# 3
flights <- flights %>% mutate(ground_speed = distance / (air_time / 60))
arrange(flights, desc(ground_speed)) %>% 
  select(ground_speed, year, month, day, dep_time, arr_time, arr_delay)

# 4
arrange(flights, desc(distance))
arrange(flights, distance)



#### Using select
## Exercises

# 1
cols = c("dep_delay","arr_time", "dep_time", "arr_delay")
select(flights, one_of(cols))

# 2
select(flights, dep_delay, dep_delay, dep_delay, dep_delay)

# 3
cols <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, cols)

# 4
select(flights, contains("TIME"))
select(flights, contains("TIME", ignore.case = FALSE))
names(flights)
?select

#### Using mutate

flights_sml <- flights %>% 
  select(year:day, 
         ends_with("delay"),
         distance,
         air_time)

flights_sml %>% 
  mutate(
    gain = arr_delay - dep_delay,
    speed = distance / (air_time / 60)
  )

flights_sml %>% 
  mutate(
    gain = arr_delay - dep_delay,
    hours = air_time / 60, 
    speed = distance / hours
  )

flights_sml %>% 
  transmute(
    gain = arr_delay - dep_delay,
    hours = air_time / 60, 
    speed = distance / hours
    
  )

## Exercises
# 1
head(flights)
flights %>% 
  select(dep_time, sched_dep_time) %>% 
  mutate(dep_time_mins = ((dep_time %/% 100) * 60) + dep_time %% 100,
         sched_dep_time_hours = ((sched_dep_time %/% 100) * 60) + sched_dep_time %% 100
  )

# 2
get_mins <- function(num){ return (((num %/% 100) * 60) + num %% 100)}
flights %>% 
  select(air_time, dep_time, arr_time) %>% 
  mutate(flight_time = get_mins(arr_time) - get_mins(dep_time))

# 3
flights %>% 
  select(dep_time, sched_dep_time, dep_delay) %>% 
  mutate(delay = get_mins(dep_time) - get_mins(sched_dep_time),
         same = dep_delay == delay) %>% 
  filter(same == FALSE)

# 4
flights %>% 
  select(carrier, flight, arr_delay, dep_delay) %>% 
  mutate(rank = min_rank(desc(dep_delay))) %>% 
  arrange(rank) 
  # filter(rank == 234113) %>% 
  # group_by(rank) %>% 
  # summarise(n = n()) %>% 
  # arrange(desc(n))
?min_rank

# 5
1:3 + 1:10


#### Using summarise and the pipe method

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# Counting
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay) 
  )
ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10) +
  labs(x = "delay (mins)")

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE), 
    n = n()
  )
ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

batting <- Lahman::Batting
batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
    geom_point() +
    geom_smooth(se = FALSE)


not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    # average delay
    avg_delay = mean(arr_delay),
    # avg positive delay
    avg_delay2 = mean(arr_delay[arr_delay> 0])
  )

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance), 
            mean_dist = mean(distance)) %>% 
  arrange(desc(distance_sd))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

## Exercises

# 2
# a
not_cancelled %>% 
  count(dest)

not_cancelled %>%
  group_by(dest) %>% 
  summarise(n = n())

# b
not_cancelled %>% 
  count(tailnum, wt = distance)

not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(n = sum(distance))

# 4
cancelled <- flights %>% 
  anti_join(not_cancelled)

cancelled %>% 
  group_by(year, month, day) %>%
  summarise(n = n(),
            avg_delay = mean(dep_delay, na.rm = TRUE)) %>% 
  mutate(date = as.Date(paste0(year, "/", month, "/", day, format = "%Y/%m/%d")),
         weekday = weekdays(date)) %>%
    ggplot(mapping = aes(x = weekday, y = avg_delay)) +
    geom_line()

(cancelled <- flights %>%
    mutate(cancelled = (is.na(arr_delay) | is.na(dep_delay))) %>%
    group_by(year, month, day) %>% 
    summarise(
      avg_delay = mean(dep_delay, na.rm = TRUE), 
      prop_cancelled = sum(cancelled), 
      n = n()
    )
)

ggplot(cancelled, mapping = aes(x = n, y = avg_delay)) +
  geom_point()


# 5
flights %>% 
  group_by(origin, dest, carrier) %>% 
  summarise(n = n(),
            avg_arr_delay = mean(arr_delay, na.rm = TRUE),
            avg_dep_delay = mean(dep_delay, na.rm = TRUE)) %>% 
  arrange(origin, dest,carrier, desc(avg_dep_delay))






#### Using Grouped Mutates (and Filters)

# Find the top or bottom 10 of a group
flights_sml %>% 
  group_by(year, month, day) %>% 
  filter(rank(desc(arr_delay)) < 10)

# Find all groups bigger than a certain threshold
(popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365))

# Standardise to compute group metrics
popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)


## Exercises

# 1

# 2
flights %>% 
  group_by(tailnum) %>% 
  filter(!(is.na(arr_delay)) & n() > 30) %>% 
  summarise(avg_arr_delay = mean(arr_delay),
            sd = sd(arr_delay),
            n = n()) %>% 
  arrange(desc(avg_arr_delay))

flights %>% 
  filter(!(is.na(tailnum))) %>%
  mutate(on_time = !is.na(arr_time) & (arr_delay <= 0)) %>% 
  group_by(tailnum) %>% 
  summarise(on_time = mean(on_time),
            avg_arr_delay = mean(arr_delay),
            sd = sd(arr_delay),
            n = n()) %>% 
  filter(n >= 20) %>% 
  filter(min_rank(on_time) == 1)


# 3












