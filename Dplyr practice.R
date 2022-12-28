install.packages('gapminder')
library(gapminder)
library(dplyr)

colnames(gapminder)

#the 'filter' function works on rows i.e. observations

gapminder %>% filter(country == 'Philippines') %>% head(4)

loc <-gapminder %>% lm(pop~year, data = .)
  
gapminder %>% filter(country == 'Philippines') %>% head(8)

gapminder %>% filter(country == 'Philippines' & year > 1980 & year <= 2000)
gapminder %>% filter(country == 'Philippines' , year > 1980, year <= 2000) # you can use comma aside from ampersand

# use %in% operator

former_yugoslavia <- c("Bosnia and Herzegovina", "Croatia", "Macedona",
                       "Montenegro", "Serbia", "Slovenia")
yugoslavia <- gapminder %>% filter(country %in% former_yugoslavia)

head(yugoslavia) # first 6 observations
head(yugoslavia, 10) # display the first 10
tail(yugoslavia) # the last /bottom 6 observations
tail(yugoslavia, 10) # displaying hte last 10


# arrange function

yugoslavia %>% arrange(year, desc(pop)) # sort by year and descending order by population

# keeping columns : 'select' function works on columns/variables
colnames(gapminder)
yugoslavia %>% select(country, year, pop) %>% head(10)

#can also make negative aside from positive selection
yugoslavia %>% select(-country, -year, -pop) %>% head(10)

?select
# use 'startswith' and 'endswith' argument in the select function
#this will only select those variables/columns containing those specific words/matches
DYS %>% select(starts_with('married'))
DYS %>% select(ends_with('18'))

#renaming variables/columns
yugoslavia %>% select(Life_Expectancy = lifeExp) %>% head(10) # this syntax drops other variables

yugoslavia %>% select(country, year, lifeExp ) %>% 
  rename(Life_Expectancy = lifeExp) %>% 
  head(4) #this syntax retains all the other variables

# creating variables using the 'mutate' function

yugoslavia %>% filter(country == 'Serbia') %>% 
  select(year, pop, lifeExp) %>% 
  mutate(pop_million = pop/1000000) %>% head(5) #can create only 1 or even multiple variables

yugoslavia %>% filter(country == 'Serbia') %>% 
  select(year, pop, lifeExp) %>% 
  mutate(pop_million = pop/1000000,
         life_past_40 = lifeExp - 40) %>% head(5) #can create even multiple variables

#ifelse function: will be applied to a vector

ifelse(test = x == y, yes =  first_value, no = second_value) # the general format

example <-c(1, 0, NA, -2)
ifelse(example>0, "Positive", "Negative")
ifelse(example<0, "Positive", "Negative")

yugoslavia %>% mutate(short_country = ifelse(country == "Bosnia and Hervegovina",
                                             "B and H", as.character(country))) %>% 
  select(short_country, year, pop) %>% 
  arrange(year, short_country) %>% 
  head(5)


yugoslavia %>% mutate(short_country = ifelse(country == "Bosnia and Hervegovina",
                                             "B and H", as.character(country))) %>% 
  select(short_country, year, pop) %>% 
  arrange(year, short_country) %>% 
  head(5)


# use of case_when function: handles multiple sequential variable creation and mutation
# use tilde (~) sign to create new variables

gapminder %>% mutate(gdpPercap_ordinal =
  case_when(
    gdpPercap < 700 ~ "low",
    gdpPercap >= 700 & gdpPercap < 800 ~ "moderate",
    TRUE ~ "high")) %>% 
  slice(6:9) # get rows from 6 to 9 


# summarizing data: will return a single value/aggregate

yugoslavia %>% filter(year == 1982) %>% 
  summarise(n_obs = n(), #takes all the observations. this is base function.
            total_pop = sum(pop), #sum
            mean_life_exp = mean(lifeExp), #mean
            range_life_exp = max(lifeExp) - min(lifeExp))

#summarize_at function - avoiding repetition
yugoslavia %>% filter(year == 1982) %>% 
  summarize_at(vars(lifeExp,pop), funs(mean, sd)) #different functions

#otehr summary functions
yugoslavia %>% filter(year == 1982) %>% 
  summarize_all(funs(mean, sd)) #this will give an error since you have a categorical variable

yugoslavia %>% filter(year == 1982) %>% 
  summarize_if(is.numeric, funs(mean, sd)) #here you specify only the numeric variables

#group_by function
#this will be grouped by year with the no of distinct countries
yugoslavia %>% group_by(year) %>% # group by years
  summarise(num_countries = n_distinct(country), #distinct by countries
            total_pop = sum(pop),
            total_gdp_per_cap = sum(pop*gdpPercap)/total_pop) %>% 
  head(5)

#this is grouped by country, summarising their no. of years
yugoslavia %>% group_by(country) %>% # group by years
  summarise(num_years = n_distinct(year), #distinct by countries
            total_pop = sum(pop),
            total_gdp_per_cap = sum(pop*gdpPercap)/total_pop) %>% 
  head(5)

#window functions: combination of mutate and filter


yugoslavia %>% 
  select(country, year, pop) %>% 
  filter(year >= 2002) %>% 
  group_by(country) %>% 
  mutate(lag_pop = lag(pop, order_by = year), #create lagged variables that is no variable previously
         pop_chg = pop - lag_pop) %>% #the lag() can handle several operations
  head(4)
 
# use gather() function: it takes a set of columns and rotates them down to make two new columns
library(tidyr) #from being wide (too many columns) to being long (too many rows)
billboard_2000 <-billboard_2000 %>% 
  gather(key = week, value = rank, starts_with("wk"))
dim(billboard_2000)
billboard_2000

billboard_2000 <-billboard_2000 %>% 
  gather(key = week, value = rank, wk1:wk76)
head(billboard_2000)
#colnames(billboard_2000)

summary(billboard_2000$rank) #there's too many NAs

#na.rm
billboard_2000 <-billboard_2000 %>% 
  gather(key = week, value = rank, starts_with("wk"),
         na.rm = T)
summary(billboard_2000$rank) #removed all the NAs

names(billboard_2000)

#separate(): convert the 'time' column to a number rather than the character

billboard_2000 <-billboard_2000 %>% 
  separate(time, into = c("minutes", "seconds"),
           sep = ":", convert = T) %>% 
  mutate(length = minutes + seconds / 60) %>% 
  select(-minutes,-seconds) #dropping the minutes and seconds

summary(billboard_2000$length)

#parse_number() function - transforms to numeric information

billboard_2000 <- billboard_2000 %>% 
  mutate(week = parse_number(week)) # you can override existing variables
summary(billboard_2000$week) #this will give u numbers infomration

#spread()

#before spread
too_long_data <-data.frame(Group = c(rep("A", 3), rep("B", 3)),
                           Statistic = rep(c("Mean", "Median", "SD"), 2),
                           Value = c(1.28, 1.0, 0.72, 2.81, 2, 1.33)); too_long_data

#after spread

just_right_data <-too_long_data %>% 
  spread(key = Statistic, value = Value); just_right_data

#find the best rank for each song

best_rank <-billboard_2000 %>% 
  group_by(artist, track) %>% 
  summarize(min_rank = min(rank),
            weeks_at_1 = sum(rank == 1)) %>% 
  mutate(`Peak rank` = ifelse(min_rank == 1,
                              "Hit #1",
                              "Didn't #1")); best_rank
#use back tics to create more
billboard_2000 <-billboard_2000 %>% 
  left_join(best_rank, by = c("artist", "track"))

head(billboard_2000, 5)


#Joining datasets####
install.packages("nycflights13")
library(nycflights13)

data(flights)
data(airlines)
data(airports)
data(planes)

colnames(planes)
colnames(flights)
colnames(airlines)
colnames(airports)

flights %>% filter(dest == "SEA") %>% select(tailnum) %>%
  left_join(planes %>% select(tailnum, manufacturer),
            by = "tailnum") %>% #count observations by manufacturer
  count(manufacturer) %>%  #arrange data descending by count
  arrange(desc(n))

glimpse(flights)
dim(flights)

#Visualization: ggplot####
str(gapminder)
glimpse(gapminder)

# it is a nested/hierarchical structure: year in country in continent; a panel data

library(tidyverse)
library(dplyr)

#subsetting ####
China <- gapminder %>% filter(country == 'China')  
head(China, 10)

library(ggplot2)
ggplot(data = China, aes(x = year, y = lifeExp))+
  geom_point(color = "red", size = 3) +
  xlab("Year") + 
  ylab("Life Expectancy") +
  ggtitle("Life Expectancy in China") +
  theme_bw(base_size = 18)

Phils <- gapminder %>% filter(country == 'Philippines')  
head(Phils, 10)

library(ggplot2)
ggplot(data = Phils, aes(x = year, y = lifeExp))+
  geom_point(color = "red", size = 3) +
  xlab("Year") + 
  ylab("Life Expectancy") +
  ggtitle("Life Expectancy in Philippines") +
  theme_bw(base_size = 18) + geom_point(aes(color = continent))

#plotting all countries

ggplot(data = gapminder, aes(x= year, y = lifeExp,
       group = country,
       color = continent)) +#be careful not to enclose it if you're adding colors and groupings
  geom_line() +
  xlab("Year") +
  ylab("Life expectancy")+
  ggtitle("Life expectancy over time") +
  theme_bw(base_size = 18)+ #the scales will not be readable
  facet_wrap(~continent)

ggplot(data = gapminder, aes(x= year, y = lifeExp,
                             group = country,
                             color = continent)) +#be careful not to enclose it if you're adding colors and groupings
  geom_line() +
  xlab("Year") +
  ylab("Life expectancy")+
  ggtitle("Life expectancy over time per continent") +
  theme_bw()+ #the scales will not be readable
  facet_wrap(~continent)

#storing plots

lifeExp_by_year <- ggplot(data = gapminder, aes(x= year, y = lifeExp,
                             group = country,
                             color = continent)) +#be careful not to enclose it if you're adding colors and groupings
  geom_line() +
  xlab("Year") +
  ylab("Life expectancy")+
  ggtitle("Life expectancy over time per continent") +
  theme_bw()+ #the scales will not be readable
  facet_wrap(~continent)

lifeExp_by_year

#add more arguments/ adding a layer
lifeExp_by_year + theme(legend.position = "bottom")

#Common problem: overplotting
#if you do scatterplots on discrete (binary/categorical) values instead of continuous values

ggplot(data = gapminder, aes(x= continent, y=year, color=continent)) +
  geom_point() #the plot is uninformative

#overplotting with jitter - shifts points up to a units horizontally and b units vertically
ggplot(data = gapminder, aes(x= continent, y=year, color=continent)) +
  geom_point(position = position_jitter(width = 0.5,
                             height = 2)) #the plot is uninformative
#draw histograms: automatically bin data; you only have one variable
gapminder %>% ggplot(aes(x = lifeExp, fill = continent)) +
  geom_histogram(bins=30) #no.of bins/counts/ stacked not overlaid
#other way of storing
a <-gapminder %>% ggplot(aes(x = lifeExp, fill = continent)) +
  geom_histogram(bins=30)
a + theme(legend.position = "bottom")

#changing the axes using xlim, ylim etc

ggplot(data=China, aes(x=year, y = gdpPercap)) +
  geom_line() +
  scale_y_log10(breaks = c(1000, 2000, 3000, 4000, 5000),
                labels = scales::dollar) + #the scales package will convert all input to dollars
  xlim(1940, 2010) + ggtitle("Chinese GDP per capita in US dollars") +theme_bw() +theme()

#text and tick adjustments

#legend name and manual colors
lifeExp_by_year + scale_color_manual(
  name ="Which\ncontinent\nare we\nlooking at?",# \n adds a line break
values = c("Africa" = "seagreen", "Americas" = "turquoise1",
           "Asia" = "royalblue", "Europe" = "violetred1",
           "Oceania" = "yellow"))

#saving ggplot plots
ggsave("I_saved_a_file.pdf", plot = lifeExp_by_year,
       height = 3, width = 5, units = "in")


#plotting model results####

#geom_smooth() - smoothed conditional means i.e. it gives you a value of y conditional on the value of x

ggplot(data = gapminder,
       aes(x = year, y = lifeExp, color = continent)) +
  geom_point(position = position_jitter(1,0), size = 0.5) +
  geom_smooth() 

#glm
ggplot(data = gapminder,
       aes(x = year, y = lifeExp, color = continent)) +
  geom_point(position = position_jitter(1,0), size = 0.5) +
  geom_smooth(method = 'glm', formula = y ~ x) + theme_bw()

#polynomial glm i.e. x + x2
ggplot(data = gapminder,
       aes(x = year, y = lifeExp, color = continent)) +
  geom_point(position = position_jitter(1,0), size = 0.5) +
  geom_smooth(method = 'glm', formula = y ~ poly(x, 2)) + theme_bw() #it adds a quadratic models/lines


#Mapping: ggmap####

