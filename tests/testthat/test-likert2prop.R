library(languageEntropy)
library(dplyr)
library(tidyr)

context("likert2prop")

# parameters
min_likert = 1
max_likert = 7
langs = 3

# tests for likert2prop
source("helper-genData.R")

likerts <- genLikertData(min_likert = min_likert, max_likert = max_likert, langs=3)

cols <- colnames(likerts %>% select(contains("L")))

## rebaseline likerts at 0
likerts <- likerts %>% mutate_at(.vars=vars(contains("L")), .funs = funs(rb = .- min_likert))

## compute proportions
likerts.prop <- likerts %>% gather(measure, value, contains("rb")) %>% group_by(sub) %>% mutate(total=sum(value)) %>% ungroup()
likerts.prop <- likerts.prop %>% mutate(prop = value / total)
likerts.prop$measure <- paste0("p",likerts.prop$measure)
likerts.prop <- likerts.prop %>% select(-value) %>% spread(measure, prop)

likerts <- left_join(likerts, likerts.prop)

rm(likerts.prop)

## compute proportions using likert2prop()
likerts <- likert2prop(data = likerts, id = sub, !!cols, minLikert = min_likert)

## get equality between proportions computed here and proportions computed by likert2prop()
likerts$prop_test <- (likerts$pL1_rb==likerts$L1_prop) & (likerts$pL2_rb==likerts$L2_prop)

test_that("proportions computed equal actual expected propotions",{
  expect_equal(likerts$pL1_rb, likerts$L1_prop)
  expect_equal(likerts$pL2_rb, likerts$L2_prop)
  expect_equal(likerts$pL3_rb, likerts$L3_prop)
})

## TEST that there should be 1 NA, since as the sub with every likert at baseline will be undefined
test_that("there is 1 subject in the dataset who had likerts at baseline thus NANs",{
  expect_equal(length(likerts$L1_prop[is.nan(likerts$L1_prop)]), 1)
  expect_equal(length(likerts$L2_prop[is.nan(likerts$L2_prop)]), 1)
  expect_equal(length(likerts$L3_prop[is.nan(likerts$L3_prop)]), 1)
})

duplikerts <- rbind(likerts, likerts[likerts$sub=="15",])
# TEST that likert2prop throws error with duplicate subjects
test_that("likert2prop catches the duplicate subject we added",{
  expect_error(likert2prop(duplikerts, sub, L1, L2, L3),
               "You have duplicate identifiers in your data: 15")
})
