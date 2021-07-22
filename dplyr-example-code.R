#Introduction to dplyr from the tidyverse
#Created 5/13/21 by Erica Bennion
#Updated 7/22/21 by Erica Bennion

#Load the tidyverse -------------------
library(tidyverse)
#Note: If you try loading the tidyverse and it fails, you may need to install it (you have to re-install packages every time you update RStudio)

#Open the data set included in the dplyr package called "diamonds"
View(diamonds)
#View properties of the data set
str(diamonds)
#View summary statistics
summary(diamonds)

#Select columns
select(diamonds, carat, cut, color, clarity)
select(diamonds, carat:clarity)
select(diamonds, 1:4)
select(diamonds, c(1:2,4))
select(diamonds, starts_with("c"))

#Filter rows
filter(diamonds, carat > 1 | cut %in% c("Very Good", "Premium", "Ideal"))
filter(diamonds, carat <= 1 & !(cut %in% c("Very Good", "Premium", "Ideal")))
filter(diamonds, cut != "Ideal")

#Sort rows
arrange(diamonds, cut, price) #arrange sorts the data by the argument after the data set, and then by the second argument, etc.
arrange(diamonds, cut, desc(price)) #default is ascending, desc() option sorts in descending order

#Add pipe
diamonds2 <- select(diamonds, carat, cut, color, clarity) %>% 
  filter(carat > 1)

diamonds2 <- diamonds %>% 
  select(carat, cut, color, clarity) %>% 
  filter(carat > 1) 

#Group and summarize
diamonds2 <- diamonds %>% 
  group_by(cut) %>% 
  summarise(n = n(), mean_price = mean(price))

#Mutate using ifelse()
diamonds2 <- diamonds %>% 
  mutate(cut_binary = ifelse(cut == "Fair" | cut == "Good", "Decent", "Best"))

#Another way to do the same thing: 
diamonds2 <- diamonds %>% 
  mutate(cut_binary = ifelse(cut %in% c("Fair","Good"), "Decent", "Best"))

#To play it safe in case there's a category you're not aware of: 
diamonds2 <- diamonds %>% 
  mutate(cut_binary = ifelse(cut %in% c("Fair","Good"), "Decent", ifelse(cut %in% c("Very Good", "Premium", "Ideal"), "Best",  NA)))

#Perform a function across multiple columns
diamonds2 <- diamonds %>% 
  mutate(across(x:z, log)) %>% 
  rename(log_x = x, log_y = y, log_z = z) %>% #rename variables
  select(carat, log_x:log_z) #select just the variables you want

#Join multiple data frames
diamonds2 <- left_join(diamonds, diamonds2, by = "carat")
#Note: If you are joining by a common variable that has different names in each data set, you would write: by = c("var1" = "var2") where "var1" is the name in the first data set (on the left) and "var2" is the name in the second.


