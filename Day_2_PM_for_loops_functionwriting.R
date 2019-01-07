#Function writing, why learn it?
# There's a couple of reasons learning functions is helpful. One you can write your own common functions. two you can better understand how to troubleshoot your code and other peoples functions. Three the principles of function writing teach us more about good coding tips to learn including reproduciability.  
# What is a function and why is it necessary in R
# A function lets you package code into one unit that doesnt need to be loaded multiple times, or rewritten.
sem<-function(x, na.rm = TRUE){
  sd(x, na.rm = na.rm)/sqrt(length(x))
}

data<-sample.int(100,10,
             replace=TRUE)

c(hi = mean(data) + sem(data),
  mean = mean(data),
  lo = mean(data) - sem(data))

#And we can create a list of all these functions, so we never have to write them again, just load them. And we'll show you how to do this today.

# A function is the functional unit in R. R is built around vectorization and function writing.
# Once you understand this you'll get better at understanding why R does things the way it does them. And be able to fix functions or use them for your own troubleshooting
# A function is anything that has two parenthesis next to it. 
# But a function is simply a way to package up code and run it in a confined space. For example lets look at sd

sd

# you see that? That's actually the underlying code in the function.



# but why do this?
# 1. It's much cleaner. Typing sd() and not having anyone worry about the underlying stuff can be good for readability.
# 2. It's reproduciable, and no one can mess with the function. This code will work everytime the way its supposed to, there's no accidently messing up the code. You can hand this to someone and it will always work. And then hark back to #1
# 3. Much easier to give finished product to collaborator or someone with lower R understanding. Including package building
# 4. It's actually more memory friendly. Lets actually look at that. Here's a function.
# say we wanted to find the range of a vector. A post the maxinum, minimum, and range. How might we do that


### CHALLENGE 

# I want to create a function that converts farenheit measurements to celsius. Lets see if we can do that real quick

temp_fun <- function(temp_values){
  (temp_values - 32) * 5/9
}

# What if we want to add an extra layer of complexity? 

temp_fun <- function(temp_values, input_temp){
  if(input_temp=="F"){return((temp_values - 32) * 5/9)}
  if(input_temp=="K"){return(temp_values - 273.15)}
  if(input_temp=="C"){return(temp_values)}
}

######
# What we start learning now are functions that are useful not just for our function writing but for your future codes in general.
#teach print
#As you get farther into programming youll find it useful to print out messages. Either something like 'Hey im starting', or 'oops i stopped', 'or you messed up!'. And if you get tired of your favorite R functions giving you illogical error messages you can even start writing in your own error messages. 

#The simple function to do this is print(). with fairly easy syntax
?print
print(i)

#Whatever you put in quotes will be printed to the console. This is useful because it will print out while code is going, including inside functions and for loops. Meaning you can put in status messages

#for example

for(i in 1:100000000){
  if(i==1) {print('im thinking')}
  # do some stuff
  if(i==100000000/2) {print('im thinking hard')}
  # do some more stuff
  if(i==100000000){print('im done')}
}

my.fun1<-function(){
  print('im thinking')
}
my.fun1()

#Theres a function that is very useful with the print function and gives a bit of an intro into more programming-esque functions. One of the first lessons is the If statement. This is part of the control structure of programming codes. They direct how codes are supposed to run. And are some of the fundamentals of programming.

#An If statement reads like this, IF something is true or false then DO something specific. So  write it out. If I am hungry then I will eat. so If something was true, I am hungry, then I should DO something. 

#In R it works like this. 
if(TRUE){print('I did it')}
if(FALSE){print('I did it')}
#So it splits out into two directions. And either does or doesnt do something. And this can be any statement as long as it makes a resulting statement that is either true or false
x<-1
if(x==1){print('I did it')}
x<-2

#And while currently it doesnt do anything if its not true, you can make it do something if the statement is not true.

if(TRUE){print('i did it')} else {'i didnt do it'}
if(FALSE){print('i did it')} else {'i didnt do it'}

#
#paste
#A very powerful tool in programming is the ability to create dynamic messages or outputs. For instance, in this code, what if we wanted to add to our error message and them them what Confidence interval they actual put in? You do this with paste. In other languages this is the same as concatenate. 

?paste
?paste0
x<-'matt'
paste0('hello','my','name','is',x)
paste('hello','my','name','is',x)
#How these work is they 'paste' together whatever things you give it, exactly how you tell it to

paste0('hello')
paste('hello','world')
paste0('hello','world')
paste0('hello',' world')
paste('hello','world',sep='-')
paste('hello','world','my name is',sep=' ')

#This becomes useful when you add in dynamic variables
i<-'the best'

paste0('i am a: ',i)

#Paste is most useful with two things. Reading/writing in files and in concert with the print function.
#For instance say you have a set of data but is seperated by state. You could input:
  
state<-'AZ'
paste0('myfiles_',state,'.csv')
state<-c('AZ','TX')
paste0('myfiles_',state,'.csv')
read.csv(paste0('myfiles_',state,'.csv'))
  
#So you can use this in for loops to load multiple files at once, or decide what to load.
  
#Same with file saving
  
extension<-'final1'
write.csv(data,paste0('myfiles_',extension,'.csv'))
  


#So I want us to break out and try something real quick. I want this function to not only return our list, but tell us (print) the upper, lower, and mean value. Can you do this?

temp_fun <- function(temp_values, input_temp){
  if(input_temp=="F"){return(paste0('The temp has been converted to', input_temp, " ", (temp_values - 32) * 5/9))}
  if(input_temp=="K"){return(paste0('The temp has been converted to', input_temp, " ", temp_values - 273.15))}
  if(input_temp=="C"){return(paste0('The temp has been converted to ', input_temp, " ", temp_values))}
}


#And weve basically created our function. And you can make these for anything you do often. To solve any problems you have.
# Not every situation is 
# Troubleshooting, its defintely an end game
# Changed inputs. 
# Sharing

for(i in 1:10){ 
  print(i) 
}   ###what did this do?
i<-1
print(i)
i<-2
print(i)
i<-3
print(i)
# it wrapped through all values between 1 and 10...
for(i in 1:10){
  #stores the value as the variable i (or any variable name we told it to)
  i<-1
  #and then runs EVERYTYHING between the brackets with the variable as that value
  print(i) 
}

i<-2
print(i)

# it then does this for the 1st value, then the 2nd, and so on until all values have been looped through the entire sequence of whatever it is we give to it

# because all its doing is storing the value as the variable (again it can be named anything)
#we can treat it like a normal variable

for(i in 1:10){
  print(i+1)
}  ## in this case we want to add 1 to that value. So it took 1 and added 1 (equals 2), then took the next value (2) and added 1 (equals 3) so on and so on.

#####
# We can do this for characters, it doesnt matter. It does a simple thing but this simple thing makes endless complexities
for(i in c('Matt','Auriel')){
  print(i)
}

for(i in c('Matt','Auriel','Liz')){
  if(i=='Matt'){print('Matt is awesome')}
  if(i=="Auriel"){print('Auriel is not')}
}
## for loops are useful for refering to rows or columns in a data set if we just feed it sequential numbers
data<-matrix(1:100,nrow=10,ncol=10)
data

for(i in 1:10){
  print(data[i,1])
}    ### is going to loop through all the rows in column 1 (and print that value)

for(i in 1:10){
  print(data[i,2])
}    ###loops through all the rows in column 2 (and prints that value)

for(i in 1:10){
  print(data[i,1]+5)
}   ###loops through all the rows in column 1 and adds 5 to that value

data[,1] <- 100

for(i in 1:10){
  data[i,2]<-data[i,1]+10
}   ###does the same thing but stores the value in the correct row in column 2

data

data[,2]<- data[,1]+10  ###is the best way to do this particular task

#At this point you may be asking, well this is extremely useful or but wait Matt, that's not how you do that. 
# You're correct, for loops are one of the bases of all of programming. But, R has already written many of its functions with internal for loops, but in the C++ code, not in the R code.
#many functions can be vectorized, meaning r automatically loops things together
paste0('hd',1:10)   ### automatically adds the numbers 1 through 10 onto the word 'hd'
#All this is doing is basically this, but more effeciently:
for(i in 1:10){
  print(paste0('hd',i))
}

#I use the term vectorizing for refering to the concept that R functions have already written iterative proccesses in the function

#Trouble shooting for loops. For loops can be difficult to troubleshoot when they hit a snag so I wanted to give you a couple of tips on troubleshooting them.

#1. Put in a line at the top that allows you to read in a dummy variable

for(i in 1:10){
  #i<-1
  print(i)
  
}

#2. Print the outputs, or save middle outputs
for(i in c(1,2,NA,4)){
  print(i)
  sub.data<-i+1
  print("heres the middle data set")
  print(sub.data)
  print('now printing mean')
  mean(sub.data)
}

#3. Write the for loop last
for(i in 1:10){
  #i<-1
  mean(i)+2
  print(paste0('the answer is: ', i))}


##############################
# Summary of if and for loops
#####################################################################

##-'for' loops are best to do tasks that can not be vectorized or when memory is an issue
##- 'for' loops are ideal for looping through files or starter values
##-'If' statements should only be used if vectorizing was not an option
##-If you have to make more than one 'if' statement you can probably vectorize it
##-Neither is ideal for math, since R is very good at doing this
##-Exceptions are when a function can not be vectorized or when referencing previous values
##-Also for lowering memory usage 
#(If your files exceed 1.5gb looping or other packages may be requried)

#end of lesson

