
### Final loop rewritten with parallel computing

# Assignment 1:  
install.packages("tweedie")
install.packages("parallel")
install.packages("doParallel")
install.packages("foreach")
library(tweedie) 
library(ggplot2)

simTweedieTest <-  
  function(N){ 
    t.test( 
      tweedie::rtweedie(N, mu=10000, phi=100, power=1.9), 
      mu=10000 
    )$p.value 
  } 


# Assignment 2:  
MTweedieTests <-  
  function(N,M,sig){ 
    sum(replicate(M,simTweedieTest(N)) < sig)/M 
  } 


# Assignment 3:  
df <-  
  expand.grid( 
    N = c(10,100,1000,5000, 10000), 
    M = 1000, 
    share_reject = NA) 


### Parallel computing

library(parallel)
library(doParallel)


# 6 core cluster
cl <- makeCluster(6)

# Register the cluster
registerDoParallel(cl)

# Replace the original loop 
df$share_reject <- 
  foreach(i = 1:nrow(df),
          .combine = 'c') %dopar% {
  MTweedieTests(
    N = df$N[i], 
    M = df$M[i], 
    sig = .05)
}

# Stop the cluster 
stopCluster(cl)


