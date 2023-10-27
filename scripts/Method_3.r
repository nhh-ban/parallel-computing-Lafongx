
### MTweedieTests function rewritten, split M simulations in more than one core

# Assignment 1:  
library(tweedie) 
library(ggplot2)

simTweedieTest <-  
  function(N){ 
    t.test( 
      tweedie::rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 


# Assignment 2 rewritten  
library(foreach)
library(doParallel)

Cores <- 6

# Register a parallel backend
cl <- makeCluster(Cores)
registerDoParallel(cl)

# Export simTweedieTest function
clusterExport(cl, "simTweedieTest")

# Load the tweedie library on each
clusterEvalQ(cl, library(tweedie))

# MTweedieTests function rewritten. Split M simulations in >1 core
MTweedieTests <- function(N, M, sig) { 

  # Parallelize the simulation. Parallelize the collection of p-values
  results <- foreach(i = 1:M, .combine = 'c') %dopar% {
    simTweedieTest(N)
  }
  
  # P values less than sig
  sum(results < sig) / M
}


# Assignment 3:  
df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 


for(i in 1:nrow(df)){ 
  df$share_reject[i] <-  
    MTweedieTests( 
      N=df$N[i], 
      M=df$M[i], 
      sig=.05) 
} 

# Stop the cluster 
stopCluster(cl)

