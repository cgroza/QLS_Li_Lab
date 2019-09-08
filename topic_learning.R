library(tm)
library(readr)
library(topicmodels)

## loading kmer documents from a directory
dir <- "/home/mcb/li_lab/cgroza/kmers"
dir.source <- DirSource(dir, pattern = "kmers")
corpus <- PCorpus(dir.source, dbControl = list(dbName = "kmer_corpus.db", dbType = "DB1"))
kmer.matrix <- DocumentTermMatrix(corpus)

## k <- 30
## SEED <- 2010
## jss_TM <- list(VEM = LDA(JSS_dtm, k = k, control = list(seed = SEED)),
##                VEM_fixed = LDA(JSS_dtm, k = k, control = list(estimate.alpha = FALSE, seed = SEED)),
##                Gibbs = LDA(JSS_dtm, k = k, method = "Gibbs", control = list(seed = SEED, burnin = 1000, thin = 100, iter = 1000)),
##                CTM = CTM(JSS_dtm, k = k,  control = list(seed = SEED, var = list(tol = 10^-4), em = list(tol = 10^-3))))
