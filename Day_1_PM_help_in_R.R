
# Getting help with R

# Everyone who uses R runs into issues, from error messages, to not knowing what functions to use to do the kind of task they want to complete. 

# There are a lot of places you might go for help with R, depending on what task you are trying to complete. 


# Maelle Salmon has a great post about where to go to get help with R that covers many of the main sources of help
# https://masalmon.eu/2018/07/22/wheretogethelp/

# lean on your friends

# find new friends! 
  # R for Data Science Community
  # Local or Remote R-Ladies Community 
  # Google Forms and other groups formed around different kinds of analyses or packages

# what is twitter good for? 

  # rstats

  # not for big complex questions, unless you can point to reproducible code
  # if you have questions about a package, look on github, and see how the package authors want to be contacted with questions, some might welcome twitter, other prefer email, or github issues

    # what is github?
    # what is a github issue? 

# What is a reproducible question? 

# lets say you are trying to use a function to run a test on some data, say to see if the size of sharks is different between two populations, and you get an error message. (OH NO!)

# If you are going to email a friend, or post online to find an answer, it is very helpful to include a reproducible example.

# this is better then sending along your own data, as it means you can share your problem with anyone without any worry about sharing your data, and its also much simpler, no one has to read in any data to see what is going on. 

dat <- data.frame(shark_size_a = c(1,5,6,"7"),
                  shark_size_b = c(6,7,9,10))

t.test(dat$shark_size_a, dat$shark_size_b)

# reproducible examples are also great ways of solving your own problem, when creating a fake small dataset that creates the same problem, you might discover the solution to the problem yourself!!

