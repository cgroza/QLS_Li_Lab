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

data <- readRDS("kmers_16_dtm_pruned.Rds")
s<-sample(1:3484, 2000)
train <- data[s,]
test  <- data[-s,]

k <- 7
SEED <- 2019
topic.model <- LDA(train, k = k, method = "Gibbs", control = list(
                                                     seed = SEED,
                                                     burnin = 1000,
                                                     thin = 100,
                                                     iter = 1000,
                                                     verbose = 10,
                                                     save = 1,
                                                     prefix = "LDA_"
                                                     ))
