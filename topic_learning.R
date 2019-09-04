library(tm)
library(readr)
library(topicmodels)

## loading kmer documents from a directory
dir <- "/home/mcb/li_lab/cgroza/dev/QLS_Li_Lab"
dir.source <- DirSource(dir)
corpus <- SimpleCorpus(dir.source)
kmer.matrix <- DocumentTermMatrix(corpus)

