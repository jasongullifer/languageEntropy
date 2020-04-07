library(gtools)

genPercentData <- function(min_percent = 0, max_percent = 100, percent_interval = 5){
  # Generate percentage data
  ## only doing tests for two languages here
  percents <- data.frame(L1=seq(min_percent, max_percent, by=percent_interval))
  percents$L2 <- 100-percents$L1
  percents$sub <- 1:nrow(percents)
  return(percents)
}

genLikertData <- function(min_likert = 1, max_likert = 7, langs = 3){
  likerts <- data.frame(permutations(n = max_likert, r = langs, repeats.allowed = T))
  colnames(likerts) <- gsub("X", "L", colnames(likerts))
  likerts$sub <- min_likert:nrow(likerts) #subject ID
  return(likerts)
}
