library(GPUmatrix)
m <- gpu.matrix(rnorm(100000000), nrow = 10000)
#m

n <- gpu.matrix(rnorm(100000000), nrow = 10000)
#n

start_time <- Sys.time()
o <- m*n
end_time <- Sys.time()
end_time-start_time

#o
