library(dplyr)
library(tidyr)

# tests for likert2prop
source("tests/helper-genData.R")

likerts <- genLikertData()

cols <- colnames(likerts %>% select(contains("L")))

## rebaseline likerts at 0
likerts <- likerts %>% mutate_at(.vars=vars(contains("L")), .funs = funs(rb=.- min_likert))

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

## TEST that there should be 1 NA, since as the sub with every likert at baseline will be undefined
length(likerts$prop_test[is.na(likerts$prop_test)]) == 1

## TEST that the remaining values all match, besides the 1 NA
length(likerts$prop_test[likerts$prop_test & !is.na(likerts$prop_test)]) == nrow(likerts) - 1

