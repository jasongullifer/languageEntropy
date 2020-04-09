library(languageEntropy)

context("percent2prop")

# parameters
min_percent = 0
max_percent = 100
percent_interval = 5
# tests for percent2prop
source("helper-genData.R")

percents <- genPercentData()

## compute proportions by hand
percents$pL1 <- percents$L1/100
percents$pL2 <- percents$L2/100

## compute proportions using percent2prop()
percents <- percent2prop(data = percents, L1, L2)

## test equality
test_that("computed propotion is expected", {
  expect_equal(percents$pL1, percents$L1_prop)
  expect_equal(percents$pL2, percents$L2_prop)
})

