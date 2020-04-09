library(dplyr)

source("test-likert2prop.R")
source("test-percent2prop.R")

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
percents.colslist <- languageEntropy(percents, id = sub, base=base, colsList = list(percent=c("L1_prop","L2_prop")))
likerts <- languageEntropy(likerts, id = sub, !!cols, contextName = "prop", base = base)
percents <- languageEntropy(percents, id = sub, L1_prop, L2_prop, contextName = "percent", base=base)

# test that languageEntropy provides same result as last time
test_that("languageEntropy provides the same result as previous run", {
  expect_known_output(likerts, "likerts.txt", print=T)
  expect_known_output(percents, "percent.txt", print=T)
  expect_known_output(percents.colslist, "percents.colsList.txt", print=T)
})

## TEST that max entropy is approx. equal to log(langs, base=base)
test_that("max entropy is approx. equal to log(langs, base=base)", {
  expect_equal(max(likerts$prop.entropy, na.rm=T), log(langs, base=base))
})

## TEST that min entropy is 0
test_that("min entropy is 0", {
  expect_equal(min(likerts$prop.entropy, na.rm=T), 0)
})

duppercents <- rbind(percents, percents[percents$sub=="15",])
# TEST that languageEntropy throws error with duplicate subjects
test_that("languageEntropy throws error with duplicate subjects",{
  expect_error(languageEntropy(duppercents, id = sub, L1_prop, L2_prop, contextName = "percent", base=base),
               "You have duplicate identifiers in your data: 15")
})

# See if we catch the warning when not specifying context name
test_that("languageEntropy throws a warning when user doesn't specify contextName",{
  expect_warning(languageEntropy(percents, id = sub, L1_prop, L2_prop, base=base),
                 "You didn't name your usage context by supplying a 'contextName' argument. I'm going to name your context 'mycontext.' Note if this happens again, your entropy value will be overwritten, so it is better to give an actual name."
                 )
})

# Compare results of languageEntropy w/ colsList to w/o colsList
test_that("check that results are the same w/ and w/o using colsList argument",{
  expect_equal(percents, percents.colslist)
})
