library(tm)
library(tidyverse)
library(topicmodels)
library(Matrix)
library(slam)
library(parallel)
library(foreach)
library(doParallel)
library(purrr)

## load Kmers

k <- 7
SEED <- 2019
topic.model <- LDA(JSS_dtm, k = k, method = "Gibbs", control = list(seed = SEED, burnin = 1000, thin = 100, iter = 1000)),
