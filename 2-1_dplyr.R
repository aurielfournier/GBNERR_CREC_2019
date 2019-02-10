# Modified by Kim Cressman from Data Carpentry lesson
# "Manipulating, analyzing, and exporting data with tidyverse"
# Original lesson here: https://datacarpentry.org/R-ecology-lesson/03-dplyr.html


# load libraries for this chunk of the day
library(tidyr)
library(dplyr)


# read in the data
# tell it *not* to turn every text column into a "factor"
surveys <- read.csv("data/portal_data_joined.csv", stringsAsFactors = FALSE)


################################################################################
# explore the data
################################################################################

## what are the column names?
names(surveys)

## what do the top few rows look like?
head(surveys)

## what do the last few rows look like?
tail(surveys)

## default for head and tail is 6 rows.
## to see a different number of rows, specify it:
head(surveys, 10)

## what are the different data types in this data frame?
str(surveys)


########
## make it a 'tibble' (a tidyverse version of a data frame)
## and it gets a bit easier to see these things in one place
## note that putting parentheses around the whole command lets us
## print the result of the command as well as saving it as the object
(surveys <- as_tibble(surveys))
########


## get some numerical summaries of the variables
summary(surveys)

## to see the unique values of a certain column, call it out:
unique(surveys$taxa)

## to get counts of those unique values:
table(surveys$taxa)

## get counts of one variable by another:
table(surveys$plot_type, surveys$taxa)

################################################################################
# What we really want to do is pick and choose columns and rows from the data frame
################################################################################

## let's start by choosing columns of interest
## the function is select()
## the first argument is the data frame
## any following arguments should be column names
select(surveys, plot_id, species_id, weight)

## notice that just prints to the console
## if we want to make it a data frame to work with later,
## we have to name it
surveys_sub <- select(surveys, plot_id, species_id, weight)

## if you want to exclude certain columns, put a - in front
select(surveys, -record_id, -species_id)



## note that, rather than putting the data frame inside parentheses,
## you can also do this using a pipe operator.
## the result of one command is fed straight into the next.
## hear it in your head as "and then":
surveys %>%
    select(plot_id, species_id, weight) 



## now let's choose some rows of interest 
## this uses the filter() function
filter(surveys, year == 1995) 


## to keep years after 1995:
filter(surveys, year > 1995) 


## notice the double equals sign
## that tells R we want to see if "year = 1995" is true, and keep it if so
## if we wanted to keep all years BUT 1995, the syntax would be !=
filter(surveys, year != 1995) 


## remember, to work with it later,
## you need to assign it to an object
surveys_non1995 <- surveys %>%
    filter(year != 1995)
head(surveys_non1995)


## if we want to choose certain columns AND certain rows,
## this is where the pipe really comes in handy:
surveys_sub <- surveys %>%
    select(year, plot_id, species_id, weight) %>%
    filter(year == 1995) 
head(surveys_sub)

dim(surveys_sub)
ncol(surveys_sub)
nrow(surveys_sub)



################################################################################
## Pipes Challenge:
##  Using pipes, subset the data to include animals collected
##  before 1995, and retain the columns `year`, `sex`, and `weight.`
################################################################################




################################################################################
# mutate function
################################################################################

# make new columns, based on other columns
surveys %>%
    mutate(weight_kg = weight / 1000) 


# the other columns can be ones you made earlier in the mutate call
surveys %>%
    mutate(weight_kg = weight / 1000,
           weight_kg2 = weight_kg * 2) 


# can also get rid of "NA"s
# using filter
# and !is.na  (vs. 'is.na')
surveys %>%
    filter(!is.na(weight)) %>%
    mutate(weight_kg = weight / 1000) 


################################################################################
## Mutate Challenge:
##  Create a new data frame from the `surveys` data that meets the following
##  criteria: contains only the `species_id` column and a column that
##  contains values that are half the `hindfoot_length` values (e.g. a
##  new column `hindfoot_half`). In this `hindfoot_half` column, there are
##  no NA values and all values are < 30.

##  Hint: think about how the commands should be ordered to produce this data frame!
################################################################################




################################################################################
# Split-Apply-Combine
################################################################################ 

## using dplyr's group_by() and summarize() functions  

## example: find mean weight for males vs. females
## first, group by sex
## then, summarize by finding the mean of the weight column
## exclude NAs with na.rm = TRUE
surveys %>%
    group_by(sex) %>%
    summarize(mean_weight = mean(weight, na.rm = TRUE))



## we probably don't want to see it overall though;
## we want species_id to be a grouping variable
surveys %>%
    group_by(species_id, sex) %>%
    summarize(mean_weight = mean(weight, na.rm = TRUE))



## we can also get rid of missing values earlier
## to avoid all those NAs (and a NaN) in the weight column
## by doing this, we don't have to include na.rm = TRUE
## because they're already gone
surveys %>%
    filter(!is.na(weight)) %>%
    group_by(sex, species_id) %>%
    summarize(mean_weight = mean(weight))


## we can sort with "arrange"
surveys %>%
    filter(!is.na(weight)) %>%
    group_by(sex, species_id) %>%
    summarize(mean_weight = mean(weight)) %>%
    arrange(species_id, sex)


## it is also possible to make multiple summaries:
## for example, not just mean weight, but minimum weight too
surveys %>%
    filter(!is.na(weight)) %>%
    group_by(sex, species_id) %>%
    summarize(mean_weight = mean(weight),
              min_weight = min(weight)) %>%
    arrange(species_id, sex)

## if we want to arrange with the lowest mean weights at the top, use that:
surveys %>%
    filter(!is.na(weight)) %>%
    group_by(sex, species_id) %>%
    summarize(mean_weight = mean(weight),
              min_weight = min(weight)) %>%
    arrange(mean_weight)

## if we want the highest mean_weight at the top, we use desc()
## inside of arrange(). it stands for "descending".
surveys %>%
    filter(!is.na(weight)) %>%
    group_by(sex, species_id) %>%
    summarize(mean_weight = mean(weight),
              min_weight = min(weight)) %>%
    arrange(desc(mean_weight))

## notice the number types here are "double", not "integer"
## (there are multiple types of number)

###############################################################################

# counting in dplyr
surveys %>%
    count(sex) 

## similar to table
table(surveys$sex)
## but you can use it inside pipes and summaries

## also the same as:
surveys %>%
    group_by(sex) %>%
    summarise(count = n())

## can sort
surveys %>%
    count(sex, sort = TRUE) 

## can count combinations of things
surveys %>%
    count(sex, species)

## and keep adding categories
surveys %>%
    count(sex, species, month) 
## don't add so many that it stops being informative

## can use arrange here as well
## grouping alphabetically by species, and then decreasing count
surveys %>%
    count(sex, species) %>%
    arrange(species, desc(n))


################################################################################
## Count Challenges:
##  1. How many animals were caught in each `plot_type` surveyed?

##  2. Use `group_by()` and `summarize()` to find the mean, min, and max
## hindfoot length for each species (using `species_id`). Also add the number of
## observations (hint: see `?n`).

##  3. What was the heaviest animal measured in each year? Return the
##  columns `year`, `genus`, `species_id`, and `weight`.
################################################################################



################################################################################
# Reshaping data with tidyr's gather() and spread()
################################################################################

# 1: long to wide format
################################################################################
## first we'll make ourselves a new data frame to manipulate
## finding the mean weight of each genus by plot_id
surveys_gw <- surveys %>%
    filter(!is.na(weight)) %>%
    group_by(genus, plot_id) %>%
    summarize(mean_weight = mean(weight))

str(surveys_gw)
surveys_gw

## this is what we call "long format"
## how many rows are there?
nrow(surveys_gw)

## what if we want fewer rows?
## say, every genus as a column head; then just one row per plot?
## we use spread():
surveys_spread <- surveys_gw %>%
    spread(key = genus, value = mean_weight)
surveys_spread

# `spread()` takes three principal arguments:
#     
# 1. the data (not necessary to specify inside a pipe)
# 2. the *key* column variable: whose values will become new column names.  
# 3. the *value* column variable whose values will fill the cells.

## can use "fill" to fill in missing values:
surveys_gw %>%
    spread(genus, mean_weight, fill = 0) 


################################################################################
# 2: wide to long
################################################################################

## gather() does the opposite of spread()

# it takes four principal arguments:
#     
#  1. the data
#  2. the *key* column variable we wish to create from column names.
#  3. the *values* column variable we wish to create and fill with values 
# associated with the key.
#  4. the names of the columns we use to fill the key variable (or to drop).

surveys_gather <- surveys_spread %>%
    gather(key = genus, value = mean_weight, -plot_id)
surveys_gather
## notice that we got rows with NAs in them
## so the lengths of the data frames "surveys_gw" and "surveys_gather" are different
(na_sum <- sum(is.na(surveys_gather$mean_weight)))

# but they should add up to be the same
na_sum + nrow(surveys_gw)
na_sum + nrow(surveys_gw) == nrow(surveys_gather)

## Spreading and then gathering can be a useful way to balance out a dataset 
## so every replicate has the same composition.


###############################################################################
## Reshaping challenges

## 1. Make a wide data frame with `year` as columns, `plot_id`` as rows, and where the values are the number of genera per plot. You will need to summarize before reshaping, and use the function `n_distinct` to get the number of unique genera within a chunk of data. It's a powerful function! See `?n_distinct` for more.

## 2. Now take that data frame, and make it long again, so each row is a unique `plot_id` `year` combination

## 3. The `surveys` data set is not truly wide or long because there are two columns of measurement - `hindfoot_length` and `weight`.  This makes it difficult to do things like look at the relationship between mean values of each measurement per year in different plot types. Let's walk through a common solution for this type of problem. First, use `gather` to create a truly long dataset where we have a key column called `measurement` and a `value` column that takes on the value of either `hindfoot_length` or `weight`. Hint: You'll need to specify which columns are being gathered.

## 4. With this new truly long data set, calculate the average of each `measurement` in each `year` for each different `plot_type`. Then `spread` them into a wide data set with a column for `hindfoot_length` and `weight`. Hint: Remember, you only need to specify the key and value columns for `spread`.
################################################################################


################################################################################
# Some data cleanup before the ggplot2 module  
################################################################################
### Create the dataset for exporting:
##  Start by removing observations for which the `species_id`, `weight`,
##  `hindfoot_length`, or `sex` data are missing:
surveys_complete <- surveys %>%
    filter(species_id != "",        # remove missing species_id
           !is.na(weight),                 # remove missing weight
           !is.na(hindfoot_length),        # remove missing hindfoot_length
           sex != "")                      # remove missing sex

##  Now remove rare species in two steps. First, make a list of species which
##  appear at least 50 times in our dataset:
species_counts <- surveys_complete %>%
    count(species_id) %>% 
    filter(n >= 50) %>%
    select(species_id)

##  Second, keep only those species:
surveys_complete <- surveys_complete %>%
    filter(species_id %in% species_counts$species_id)

## make sure there's a data_output folder to write to
if (!dir.exists("data_output")) dir.create("data_output")
## and export the csv file
write.csv(surveys_complete, file = "data_output/surveys_complete.csv", row.names = FALSE)
