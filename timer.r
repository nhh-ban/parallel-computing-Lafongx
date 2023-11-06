library(tictoc)
library(dplyr)   
library(tidyr)
library(stringr)

# Define the function
determine_fastest_method <- function() {
  # Retrieve the tic-toc log
  timing_log <- tic.log()
  
  # Vectors to store method names and elapsed times
  method_names <- vector("character", length(timing_log))
  elapsed_times <- vector("numeric", length(timing_log))
  
  # Parse the log entries to extract method names and elapsed times
  for (i in seq_along(timing_log)) {
    # Extract the method name and elapsed time 
    method_name <- str_extract(timing_log[[i]], "^[^:]+")
    elapsed_time <- as.numeric(str_extract(timing_log[[i]], "\\d+\\.\\d+")) 
    
    # Store the method name and elapsed time
    method_names[i] <- method_name
    elapsed_times[i] <- elapsed_time
  }
  
  # What is the fastest method? The one with the smallest elapsed time
  fastest_method_index <- which.min(elapsed_times)
  
  # Extract the name and the elapsed time of the fastest method
  fastest_method <- method_names[fastest_method_index]
  fastest_elapsed_time <- elapsed_times[fastest_method_index]
  
  # Return the fastest method with how much time it takes
  return(list(
    method = fastest_method, 
    elapsed_time = fastest_elapsed_time
  ))
}


# Reset the tic-toc log to ensure it's empty before starting
tic.clearlog()

# Method 1 (solution as is)
tic("Method_1")
source("scripts/method_1.r")
toc(log = TRUE)

# Method 2 (parallel computing in the final loop)
tic("Method_2")
source("scripts/method_2.r")
toc(log = TRUE)

# Method 3 (MTweedieTests function rewritten to split the M simulations in >1 core)
tic("Method_3")
source("scripts/method_3.r")
toc(log = TRUE)

# Determine and print the fastest method
fastest_method_info <- determine_fastest_method()
print(paste("The fastest method is:", fastest_method_info$method, 
            "with an elapsed time of", fastest_method_info$elapsed_time, "seconds."))



### The fastest method is: Method_3 with an elapsed time of 9.45 seconds.
### I think my function should work properly - I tried to make a function that spits out
### what kind of method that is the fastest. 
### I found line 15 to 19 on a stackoverflow script and tried to adjust for my script. 
### This line of code caused multiple errors, but after asking ChatGPT what the problem is,
### I arrived at a solution where I wrote "^[^:]+" and "\\d+\\.\\d+". This essentially extracts
### the numerical value of elapsed time each method uses, along with the character "value"
### of what that method is, for example "9.45" and "Method_3". 
### "^[^:]+" means that I extract all characters from the start of the string until the first colon is encountered. 
### "\\d+\\.\\d+" means that I match and extract a decimal number from the log entry. The "as.numeric" command 
### is used to convert this extracted text into a numeric value.
### This is the only part of the code that I am not entirely sure how works, because I used it from 
### a stackoverflow script, and it seems to work. However, I have tried to the best of my ability to 
### explain what I think is happening in the text above. I would very much like feedback
### on whether or not my interpretation is correct!!!

### In the final part of my script, I simply extract these values and print them into
### a pre-determined text.

### Method 3 is the fastest method, by far. This is due to the fact that it is 
### much quicker to parallelize the simulations, than to only parallelize
### the loops as we did in method 2. We are running the simulations on several cores, rather than 
### one single core. 
### This shows that parallelization can be a useful tool to reduce the time of running a simulation 
### script. It also shows that it is more efficient to parallelize the simulations, rather than
### the actual loop. I think this is because you spread out the majority of the workload (which I
### intuitively think is the simulation) on multiple cores. In my head, it requires less 
### work for a computer to do a loop, rather than a simulation. 

### Conclusion: Method 3 is the fastest of all methods, and Method 2 is faster than Method 1, 
### because Method 1 does not utilize any form of parallelization. 

