library(dplyr)

source("tests/test-likert2prop.R")
source("tests/test-percent2prop.R")

# parameters
base = 2             # log base for entropy
min_likert = 1
max_likert = 7
langs = 3
min_percent = 0
max_percent = 100
percent_interval = 5

# tests for languageEntropy

## compute entropy
cols <- colnames(likerts %>% select(contains("_prop")))
likerts <- languageEntropy(likerts, id = sub, !!cols, contextName = "prop", base = base)
percents <- languageEntropy(percents, id = sub, L1_prop, L2_prop, contextName = "percent", base=base)
# should run an entropy computation by hand and cross check with the function
#### HERE

# ## TEST for equality between by hand entropy and languageEntropy()
# likerts$entropy_test <- likerts$prop.entropy == likerts$p.entropy
#
# ## TEST that there should be 1 NA, since as the sub with every likert at baseline will be undefined
# length(likerts$entropy_test[is.na(likerts$entropy_test)]) == 1
#
# ## TEST that the remaining values all match, besides the 1 NA
# length(likerts$entropy_test[likerts$entropy_test & !is.na(likerts$entropy_test)]) == nrow(likerts)-1

## TEST that max entropy is approx. equal to log(langs, base=base)
all.equal(max(likerts$prop.entropy, na.rm=T), log(langs, base=base))

## TEST that min entropy is approx. equal to log(langs, base=base)
min(likerts$prop.entropy, na.rm=T) == 0

duppercents <- rbind(percents, percents[percents$sub=="15",])
# TEST that languageEntropy throws error with duplicate subjects
languageEntropy(duppercents, id = sub, L1_prop, L2_prop, contextName = "percent", base=base)


plot(percents$L1_prop, percents$percent.entropy)
