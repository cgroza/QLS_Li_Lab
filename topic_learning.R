library(tm)
library(readr)
library(topicmodels)
library(Matrix)
library(slam)

## loading kmer documents from a directory
dir <- "/home/mcb/li_lab/cgroza/kmers"
setwd(dir)

counts <- list.files(dir)

# for testing purposes
## counts <- counts[1:3]


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
  return(dtm)
}

dtm.acc <- countsToDocumentMatrix(counts[1])
for(kmer.counts in counts[2:length(counts)])
{
  dtm.acc <- c(dtm.acc, countsToDocumentMatrix(kmer.counts))
}
print(dtm.acc)
save.image(file="/home/mcb/li_lab/cgroza/kmers.Rdata")


## corpus <- PCorpus(dir.source, dbControl = list(dbName = "kmer_corpus.db", dbType = "DB1"))
## kmer.matrix <- DocumentTermMatrix(corpus)

## k <- 30
## SEED <- 2010
## jss_TM <- list(VEM = LDA(JSS_dtm, k = k, control = list(seed = SEED)),
##                VEM_fixed = LDA(JSS_dtm, k = k, control = list(estimate.alpha = FALSE, seed = SEED)),
##                Gibbs = LDA(JSS_dtm, k = k, method = "Gibbs", control = list(seed = SEED, burnin = 1000, thin = 100, iter = 1000)),
##                CTM = CTM(JSS_dtm, k = k,  control = list(seed = SEED, var = list(tol = 10^-4), em = list(tol = 10^-3))))
