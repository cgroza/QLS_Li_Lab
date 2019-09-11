library(tm)
library(tidyverse)
library(topicmodels)
library(Matrix)
library(slam)
library(parallel)
library(foreach)
library(doParallel)
library(purrr)

## Use half the cores
no_cores <- detectCores() - 4
# Initiate cluster
cl <- makeCluster(no_cores)
registerDoParallel(cl)
## loading kmer documents from a directory
dir <- "/home/mcb/li_lab/cgroza/kmers"
counts <- list.files(dir, full.names = T)

clusterEvalQ(cl, library(tidyverse))
clusterEvalQ(cl, library(slam))
clusterEvalQ(cl, library(Matrix))
clusterEvalQ(cl, library(tm))
clusterExport(cl, "counts")

countsToDocumentMatrix <- function(filename)
{
  kmer <- read_delim(filename, col_names=F, delim=" ")
  ## initialize matrix
  dtm <- simple_triplet_matrix(
    i=rep(1, length(kmer$X1)),
    j =1:length(kmer$X2),
    v = kmer$X3,
    dimnames = list(kmer$X1[1], kmer$X2))
  dtm = as.DocumentTermMatrix(dtm, weighting = weightTf)
  print(paste("Computed ", filename))
  return(dtm)
}

breaks <- c(seq(1,3486, by=100), 3485)
dtm.acc <- FALSE
for (i in 1:(length(breaks) - 1)){
  print(paste("Running 100 samples from ", i))
  dtm <- foreach(kmer = counts[breaks[i]:(breaks[i+1]-1)],
                 .combine = "c",
                 .multicombine = T,
                 .inorder = F,
                 .verbose = T
                 )  %dopar% countsToDocumentMatrix(kmer)

  print(dtm)
  if(dtm.acc) {
    dtm.acc <- c(dtm, dtm.acc)
    dtm.acc <- removeSparseTerms(dtm.acc, 0.9)
  }
  else {
    dtm.acc <- dtm
  }
}
stopCluster(cl)

## k <- 30
## SEED <- 2010
## jss_TM <- list(VEM = LDA(JSS_dtm, k = k, control = list(seed = SEED)),
##                VEM_fixed = LDA(JSS_dtm, k = k, control = list(estimate.alpha = FALSE, seed = SEED)),
##                Gibbs = LDA(JSS_dtm, k = k, method = "Gibbs", control = list(seed = SEED, burnin = 1000, thin = 100, iter = 1000)),
##                CTM = CTM(JSS_dtm, k = k,  control = list(seed = SEED, var = list(tol = 10^-4), em = list(tol = 10^-3))))
