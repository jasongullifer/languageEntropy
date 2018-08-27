# tests for percent2prop
source("tests/helper-genData.R")

percents <- genPercentData()

## compute proportions by hand
percents$pL1 <- percents$L1/100
percents$pL2 <- percents$L2/100

## compute proportions using percent2prop()
percents <- percent2prop(data = percents, L1, L2)

## test equality
percents$prop_test <- (percents$pL1==percents$L1_prop) & (percents$pL2==percents$L2_prop)

## should be nrow(), if they all match eachother
length(percents$prop_test[percents$prop_test & !is.na(percents$prop_test)]) == nrow(percents)

