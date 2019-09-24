library(tm)
library(tidyverse)
library(topicmodels)
library(Matrix)
library(slam)
library(parallel)
library(foreach)
library(doParallel)
library(purrr)
library(Rfast)
library(ggpointdensity)

## load kmers as matrix
m <- as.matrix(readRDS("kmers_16_dtm.Rds"))

term.vars <- colVars(m)
term.means <- colMeans(m)
term.sums <- colSums(m)
## doc.vars <- rowVars(m)
## doc.means <- rowMeans(m)

## saveRDS(term.vars, "term_vars_16.Rds")
## saveRDS(doc.vars, "doc_vars_16.Rds")

## ggplot() + geom_density(aes(x=log(term.vars))) + ggtitle("Variance of terms across samples") + xlab("log(Variance)")
## ggsave("term_variance.pdf")

## ggplot() + geom_point(aes(x = log(term.means), y=log(term.vars)), alpha=0.1) + ggtitle("Variance vs mean") + ylab("log(Variance)") + xlab("log(Mean)")
## ggsave("term_mean_variance.png")

## ggplot() + geom_density(aes(x=log(doc.vars))) + ggtitle("Variance of samples across terms") + xlab("log(Variance)")
## ggsave("doc_variance.pdf")


## ggplot() + geom_density(aes(x=log(term.means))) + ggtitle("Mean of terms across samples") + xlab("log(Mean)")
## ggsave("term_mean.pdf")

## model <- lm(log(term.vars) ~ log(term.means))
log.term.vars.adj <- log(term.vars) - log(term.means) * 1.877

ggplot() + geom_pointdensity(aes(x = log(term.means), y=log.term.vars.adj), alpha=0.1) + ggtitle("Adjusted variance vs mean") + ylab("log(Variance)") + xlab("log(Mean)")
ggsave("adj_term_mean_variance.png")

## ggplot() + geom_density(aes(x=log(log.term.vars.adj))) + ggtitle("Adjusted variance of terms across samples") + xlab("log(Variance)") 
## ggsave("adj_term_variance.pdf")
list.term.sums <- as.list(term.sums)
list.term.vars <- as.list(term.vars)

kmers <- tibble(Var = unlist(list.term.vars), Count = unlist(list.term.sums), KMER = names(list.term.sums)) %>% arrange(Count) %>% mutate(Rank = row_number())
ggplot(kmers) + geom_point(aes(y=Count, x=Rank))
ggsave("sums_by_rank.png")

removed.kmers <- (kmers %>% filter(Rank > 600000))$KMER
saveRDS(removed.kmers, "removed_kmers.Rds")

m.pruned <- m[, !colnames(m) %in% removed.kmers]
saveRDS(m.pruned, "pruned_matrix.Rds")

term.vars.pruned <- colVars(m.pruned)
term.means.pruned <- colMeans(m.pruned)

ggplot() + geom_point(aes(x = log(term.means.pruned), y=log(term.vars.pruned)), alpha=0.1) + ggtitle("Variance vs mean") + ylab("log(Variance)") + xlab("log(Mean)")
ggsave("log_pruned_term_mean_variance.png")

ggplot() + geom_point(aes(x = term.means.pruned, y=term.vars.pruned), alpha=0.1) + ggtitle("Variance vs mean") + ylab("Variance") + xlab("Mean")
ggsave("pruned_term_mean_variance.png")


ggplot() + stat_ecdf(aes(x = term.vars.pruned)) + ggtitle("Variance cumulative distribution") + ylab("CDF") + xlab("Variance") + scale_x_continuous(limits = c(0,10000))
ggsave("pruned_variance_cdf.pdf")


pruned.kmers <- filter(kmers, Var > 800)$KMER
## To prune the DocumentTermMatrix
dtm <- readRDS("kmers_16_dtm.Rds")
dtm.pruned <- dtm[, ! Terms(dtm) %in% pruned.kmers]
saveRDS(dtm.pruned, "kmers_16_dtm_pruned.Rds")
