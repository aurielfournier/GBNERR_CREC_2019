# Modified by Kim Cressman from Data Carpentry
# Original lesson here: https://datacarpentry.org/R-ecology-lesson/04-visualization-ggplot2.html


# load packages
library(tidyr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
#  library(gridExtra)  # some people won't have this
#  library(cowplot)  # other people won't have this. note having this loaded changes the default background of the plots.


### Learning Objectives

# Produce scatter plots, boxplots, and time series plots using ggplot.
# Set universal plot settings.
# Describe what faceting is and apply faceting in ggplot.
# Modify the aesthetics of an existing ggplot plot (including axis labels and color).
# Build complex and customized plots from data in a data frame.



# load data
surveys_complete <- read.csv("data_output/surveys_complete.csv", stringsAsFactors = FALSE)

# examine data
head(surveys_complete)
tail(surveys_complete)
str(surveys_complete)
summary(surveys_complete)



## ggplot2 works really with data in long format

## we build plots in layers:
# ggplot(data = <DATA>, mapping = aes(<MAPPINGS>)) +  <GEOM_FUNCTION>()


# setting up a plot
ggplot(data = surveys_complete)
# notice it's blank - you haven't told it anything about what goes on the plot



ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))
# now it knows what we want the axes to be
# but we haven't yet told it how to put the data on there


ggplot(data = surveys_complete, 
       mapping = aes(x = weight, y = hindfoot_length)) +
    geom_point()
# we've just added points to the plot with geom_point()
# the plus sign lets us add layers

?geom_point

ggplot(data = surveys_complete, 
       mapping = aes(x = weight, y = hindfoot_length)) +
    geom_point(col = "blue")


# we could also save the structure of the plot to an object
surveys_plot <- ggplot(data = surveys_complete, 
                       mapping = aes(x = weight, y = hindfoot_length))

# Draw the plot
surveys_plot + 
    geom_point(col = "blue")


## label the axes
# note that this is much later in the original lesson, so it will be a while before we include this again
surveys_plot +
    geom_point(col = "blue") +
    labs(title = "Hindfoot Length by Weight",
         x = "Weight (g)",
         y = "Hindfoot Length (mm)")

# subtitle is an option too:
surveys_plot +
    geom_point(col = "blue") +
    labs(title = "Hindfoot Length by Weight",
         subtitle = "in the Portal data set",
         x = "Weight (g)",
         y = "Hindfoot Length (mm)")


# what if we want to color by species

# remind yourself of the variable names in the data frame
names(surveys_complete)

surveys_plot + 
    geom_point(aes(col = species_id)) +
    labs(title = "Hindfoot Length by Weight and Species",
         x = "Weight (g)",
         y = "Hindfoot Length (mm)")
# notice, to color by a variable, it needs to go inside aes()


# we can also make the points more transparent using alpha
surveys_plot + 
    geom_point(aes(col = species_id), alpha = 0.2) +
    labs(title = "Hindfoot Length by Weight and Species",
         x = "Weight (g)",
         y = "Hindfoot Length (mm)")


# could also specify this in the plot-level line:
ggplot(data = surveys_complete, 
       mapping = aes(x = weight, y = hindfoot_length, color = species_id)) +
    geom_point(alpha = 0.2)

# up there, it would apply to any other layer we use to represent the data:
ggplot(data = surveys_complete, 
       mapping = aes(x = weight, y = hindfoot_length, color = species_id)) +
    geom_jitter(alpha = 0.2)



### **Notes**
#     
#     - Anything you put in the `ggplot()` function can be seen by any geom layers
# that you add (i.e., these are universal plot settings). This includes the x- and
# y-axis mapping you set up in `aes()`.
# - You can also specify mappings for a given geom independently of the
# mappings defined globally in the `ggplot()` function.
# - The `+` sign used to add new layers must be placed at the end of the line containing
# the *previous* layer. If, instead, the `+` sign is added at the beginning of the line
# containing the new layer, **`ggplot2`** will not add the new layer and will return an 
# error message.



###############################################################################
### Challenge

# Use what you just learned to create a scatter plot of `weight` over
# `species_id` with the `plot types` showing in different colors. 
# Is this a good way to show this type of data?
###############################################################################


# boxplots
ggplot(surveys_complete, aes(x = species_id, y = weight)) +
    geom_boxplot()
# don't always have to type "data = " and "mapping = "


# can fill them in
ggplot(surveys_complete, aes(x = species_id, y = weight)) +
    geom_boxplot(fill = "gray80")
# notice with boxplot, we use "fill" rather than "col"


# can add another layer with the points
# to show the true distribution
ggplot(surveys_complete, aes(x = species_id, y = weight)) +
    geom_boxplot(fill = "gray80") +
    geom_jitter(alpha = 0.3, col = "tomato3")

# notice what happens if we change the order of our calls:
ggplot(surveys_complete, aes(x = species_id, y = weight)) +
    geom_jitter(alpha = 0.3, col = "tomato3") +
    geom_boxplot(alpha = 0.2)  


###############################################################################
## Challenge with boxplots:
##  Start with the boxplot we created:
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
    geom_boxplot(alpha = 0) +
    geom_jitter(alpha = 0.3, color = "tomato")

##  1. Replace the box plot with a violin plot; see `geom_violin()`.

##  2. Represent weight on the log10 scale; see `scale_y_log10()`.

##  3. Create boxplot for `hindfoot_length` overlaid on a jitter layer.

##  4. Add color to the data points on your boxplot according to the
##  plot from which the sample was taken (`plot_id`).

##  *Hint:* Check the class for `plot_id`. Consider changing the class
##  of `plot_id` from integer to factor. Why does this change how R
##  makes the graph?

###############################################################################


# plotting time series data  
# note this process is essentially the same if you have dates in 'date' or 'POSIXct' format (e.g. continuous data)

# first get yearly counts
yearly_counts <- surveys_complete %>%
    count(year, species_id)

# now plot
ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) +
    geom_line()
# oops; didn't separate out species, so it looks crazy


# use 'group' inside aes()
ggplot(data = yearly_counts, 
       mapping = aes(x = year, y = n, group = species_id)) +
    geom_line()


# sure would be nice to have some color, yes?
ggplot(data = yearly_counts, 
       mapping = aes(x = year, y = n, color = species_id)) +
    geom_line()


# a really nice option in ggplot is 'faceting' -
# separating into different panels
ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) +
    geom_line() +
    facet_wrap(~ species_id)


# we could fit more information into each panel
# first let's make another data frame that separates each species
# into male and female
yearly_sex_counts <- surveys_complete %>%
    count(year, species_id, sex)

# and now, color by sex
ggplot(data = yearly_sex_counts, 
       mapping = aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(~ species_id)


# can control the number of columns:
ggplot(data = yearly_sex_counts, 
       mapping = aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(~ species_id, ncol = 3)

# or rows, with nrow = __

## can change appearance by using different build-in themes:

ggplot(data = yearly_sex_counts, 
       mapping = aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(~ species_id, ncol = 3) +
    theme_bw()

ggplot(data = yearly_sex_counts, 
       mapping = aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(~ species_id, ncol = 3) +
    theme_classic()

ggplot(data = yearly_sex_counts, 
       mapping = aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(~ species_id, ncol = 3) +
    theme_dark()


# if you want to just remove the grids from the bw theme, you can specify it:
ggplot(data = yearly_sex_counts, 
       mapping = aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(~ species_id) +
    theme_bw() +
    theme(panel.grid = element_blank())


###############################################################################
### Plotting time series challenge:
##
##  Use what you just learned to create a plot that depicts how the
##  average weight of each species changes through the years.
###############################################################################


## more with faceting: facet_grid to go rows ~ columns:

yearly_sex_weight <- surveys_complete %>%
    group_by(year, sex, species_id) %>%
    summarize(avg_weight = mean(weight))

# One column, facet by rows
ggplot(data = yearly_sex_weight, 
       mapping = aes(x = year, y = avg_weight, color = species_id)) +
    geom_line() +
    facet_grid(sex ~ .)
# One row, facet by column
ggplot(data = yearly_sex_weight, 
       mapping = aes(x = year, y = avg_weight, color = species_id)) +
    geom_line() +
    facet_grid(. ~ sex)

# what if we want separate panels for each species?
# One row, facet by column
ggplot(data = yearly_sex_weight, 
       mapping = aes(x = year, y = avg_weight, color = species_id)) +
    geom_line() +
    facet_grid(species_id ~ sex)



## back to labels in the original lesson
ggplot(data = yearly_sex_counts, mapping = aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(~ species_id) +
    labs(title = "Observed species in time",
         x = "Year of observation",
         y = "Number of species") +
    theme_bw()

## can change the font size
ggplot(data = yearly_sex_counts, mapping = aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(~ species_id) +
    labs(title = "Observed species in time",
         x = "Year of observation",
         y = "Number of species") +
    theme_bw() +
    theme(text=element_text(size = 16))

## change the orientation of the x-axis labels
## using "angle = " in the axis.text.x command
ggplot(data = yearly_sex_counts, mapping = aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(~ species_id) +
    labs(title = "Observed species in time",
         x = "Year of observation",
         y = "Number of species") +
    theme_bw() +
    theme(axis.text.x = element_text(colour = "grey20", size = 12, 
                                     angle = 90, hjust = 0.5, 
                                     vjust = 0.5),
          axis.text.y = element_text(colour = "grey20", size = 12),
          text = element_text(size = 16))


## you can make those your own theme, and use it for multiple graphs
## later in the script
grey_theme <- theme(axis.text.x = element_text(colour = "grey20", size = 12,
                                               angle = 90, hjust = 0.5, 
                                               vjust = 0.5),
                    axis.text.y = element_text(colour = "grey20", size = 12),
                    text = element_text(size = 16))

ggplot(surveys_complete, aes(x = species_id, y = hindfoot_length)) +
    geom_boxplot() +
    grey_theme



## also play with "ggThemeAssist" addin
# install.packages("ggThemeAssist")
surveys_plot +
    geom_point() + 
    theme(plot.subtitle = element_text(vjust = 1), 
          plot.caption = element_text(vjust = 1), 
          panel.background = element_rect(fill = NA)) +
    labs(title = "Hindfoot Length", 
         x = "weight (g)", 
         y = "hindfoot length (mm)")

###############################################################################
### Challenge
 
 # With all of this information in hand, please take another five minutes to
 # either improve one of the plots generated in this exercise or create a
 # beautiful graph of your own. Use the RStudio [**`ggplot2`** cheat sheet](https://www.rstudio.com/wp-content/uploads/2016/11/ggplot2-cheatsheet-2.1.pdf)
 # for inspiration. Here are some ideas:
 # 
 # * See if you can change the thickness of the lines.
 # * Can you find a way to change the name of the legend? What about its labels?
 # * Try using a different color palette (see
 #   http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/).

###############################################################################

# if you need a graph to improve:
surveys_plot +
    geom_line() + 
    theme(axis.text.x = element_text(size = 15, ang=90, color = "purple"), 
          axis.text.y = element_text(size = 2, color = "red"), 
          axis.title.y = element_text(size = 20), 
          plot.background = element_rect(fill="green"), 
          panel.background = element_rect(fill="red", color="black"), 
          panel.grid.major = element_line(colour = "red"), 
          panel.grid.minor = element_line(colour = "purple"), 
          title = element_text(size = 1), 
          #        axis.line.x = element_line(colour = "black"), 
          #        axis.line.y = element_line(colour = "black"), 
          strip.background = element_rect(fill = "orange", color = "black"), 
          strip.text = element_text(size = 15, color="red"),
          legend.background = element_rect(fill="black"),
          legend.text = element_text(color="gray"),
          legend.key=element_rect(fill="white"))



##### Arranging Plots using gridExtra or cowplot
library(gridExtra)
# library(cowplot)

# make a couple plots, and name them
spp_weight_boxplot <- ggplot(data = surveys_complete, 
                             mapping = aes(x = species_id, y = weight)) +
    geom_boxplot() +
    xlab("Species") + 
    ylab("Weight (g)") +
    scale_y_log10()
spp_count_plot <- ggplot(data = yearly_counts, 
                         mapping = aes(x = year, y = n, color = species_id)) +
    geom_line() + 
    xlab("Year") + 
    ylab("Abundance")

# now put them next to each other

# gridExtra option:
grid.arrange(spp_weight_boxplot, spp_count_plot, ncol = 2, widths = c(4, 6))
#cowplot option:
plot_grid(spp_weight_boxplot, spp_count_plot, rel_widths = c(4, 6))

# remember that help files are useful:
?grid.arrange
?plot_grid


### saving plots
# can use 'export' from the plot window; not great
# ggsave is good
my_plot <- ggplot(data = yearly_sex_counts, 
                  mapping = aes(x = year, y = n, color = sex)) +
    geom_line() +
    facet_wrap(~ species_id) +
    labs(title = "Observed species in time",
         x = "Year of observation",
         y = "Number of species") +
    theme_bw() +
    theme(axis.text.x = element_text(colour = "grey20", size = 12, 
                                     angle = 90, hjust = 0.5, vjust = 0.5),
          axis.text.y = element_text(colour = "grey20", size = 12),
          text=element_text(size = 16))
ggplot2::ggsave("fig_output/yearly_sex_counts.png", my_plot, width = 15, height = 10)
# had to use this notation because ggplot's ggsave is masked by having cowplot open
# :: lets you specify the package that a function comes from


# This also works for grid.arrange() plots
combo_plot <- grid.arrange(spp_weight_boxplot, spp_count_plot, 
                           ncol = 2, widths = c(4, 6))
ggplot2::ggsave("fig_output/combo_plot_abun_weight.png", combo_plot, width = 10, dpi = 300)


# to save a cowplot, use either cowplot or ggplot2's ggsave
combo_plot2 <- plot_grid(spp_weight_boxplot, spp_count_plot, rel_widths = c(4, 6))
cowplot::ggsave("fig_output/combo_plot_abun_weight2.png", combo_plot2, width = 10, dpi = 300)


###############################################################################
### Final plotting challenge:
##  With all of this information in hand, please take another five
##  minutes to either improve one of the plots generated in this
##  exercise or create a beautiful graph of your own. 

##  Export it to the fig_output folder.

##  Use the RStudio
##  ggplot2 cheat sheet for inspiration:
##  https://www.rstudio.com/wp-content/uploads/2015/08/ggplot2-cheatsheet.pdf
###############################################################################