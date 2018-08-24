Compute language entropy with languageEntropy
================
Jason W. Gullifer
2018-08-24

Use this package to compute language entropy within social spheres from language history data. See Gullifer et al. (2018) for more detail.

Installation
============

`languageEntropy` can be installed through `devtools` using the code below.

``` r
# Install devtools package if necessary
if(!"devtools" %in% rownames(installed.packages())) install.packages("devtools")

# Install the stable development verions from GitHub
devtools::install_github("jasongullifer/languageEntropy")
```

Usage
=====

If you have a subject-level dataset (i.e., one row per subject) that contains proportions of language usage that sum up to 1 (e.g., usage of the native language \[L1\], second language \[L2\], and third language \[L3\]), you can compute language entropy using the `languageEntropy()` function.

You simply pass the function your dataset (`data` argument) together with several bare, unquoted identifier columns, including the unique subject identifier (`id` argument) and other variables that index proportion of language usage (`...` argument). There is also a flag (`percentage`) that you can set to `TRUE` in case your language usages are coded as percentages.

Various language history questionnaires collect usage data via Likert scales (e.g., "L1 / L2 / L3 use at home: 1 (none at all) - 7 (all the time)"). The helper function `likert2prop()`, will convert this likert data into proportions. Simply supply your dataset and variables as above, store the result, and use that result in the `languageEntropy()` function. Note: by default `likert2prop()` assumes your baseline for "no usage" is scored as 1. You may have to manually rescale your questions so everything is on the same scale.

As a concrete example, a participant might report the following usage pattern: L1: 7 (all the time), L2: 1 (none at all), L3: 3 (sometimes). First the baseline is subtracted from each usage question, and then each rebaselined usage is divided by the total, resulting in L1: 6/8, L2: 0/8, L3: 2/8.

Examples
========

Example (fake) dataset has 5 subjects. Subjects reported L1/L2/L3 use at home and at work. Home and work data are represented as Likert scales (1: uses Lx none at all; 7: uses Lx all the time). Subjects also reported percentage of L1/L2/L3 use overall.

``` r
library(languageEntropy)
data(entropyExData) # load example data
print(entropyExData)
```

    ##   sub L1Home L2Home L3Home L1Work L2Work L3Work L1PercentUse L2PercentUse
    ## 1   1      7      7      4      1      7      1           40           50
    ## 2   2      1      7     NA      7      5     NA           60           40
    ## 3   3      7      2     NA      7      2     NA           90           10
    ## 4   4      3      2      6      5      5      5           33           33
    ## 5   5      1      1      7      2      2      6           10           10
    ##   L3PercentUse
    ## 1           10
    ## 2           NA
    ## 3           NA
    ## 4           33
    ## 5           80

``` r
# convert Likert scale data to proportions

## first for the home sphere
entropyExData <- likert2prop(entropyExData, sub, L1Home, L2Home, L3Home)
print(entropyExData)
```

    ##   sub L1Home L2Home L3Home L1Work L2Work L3Work L1PercentUse L2PercentUse
    ## 1   1      7      7      4      1      7      1           40           50
    ## 2   2      1      7     NA      7      5     NA           60           40
    ## 3   3      7      2     NA      7      2     NA           90           10
    ## 4   4      3      2      6      5      5      5           33           33
    ## 5   5      1      1      7      2      2      6           10           10
    ##   L3PercentUse L1Home_prop L2Home_prop L3Home_prop
    ## 1           10   0.4000000   0.4000000       0.200
    ## 2           NA   0.0000000   1.0000000          NA
    ## 3           NA   0.8571429   0.1428571          NA
    ## 4           33   0.2500000   0.1250000       0.625
    ## 5           80   0.0000000   0.0000000       1.000

``` r
## next for the work sphere
entropyExData <- likert2prop(entropyExData, sub, L1Work, L2Work, L3Work)
print(entropyExData)
```

    ##   sub L1Home L2Home L3Home L1Work L2Work L3Work L1PercentUse L2PercentUse
    ## 1   1      7      7      4      1      7      1           40           50
    ## 2   2      1      7     NA      7      5     NA           60           40
    ## 3   3      7      2     NA      7      2     NA           90           10
    ## 4   4      3      2      6      5      5      5           33           33
    ## 5   5      1      1      7      2      2      6           10           10
    ##   L3PercentUse L1Home_prop L2Home_prop L3Home_prop L1Work_prop L2Work_prop
    ## 1           10   0.4000000   0.4000000       0.200   0.0000000   1.0000000
    ## 2           NA   0.0000000   1.0000000          NA   0.6000000   0.4000000
    ## 3           NA   0.8571429   0.1428571          NA   0.8571429   0.1428571
    ## 4           33   0.2500000   0.1250000       0.625   0.3333333   0.3333333
    ## 5           80   0.0000000   0.0000000       1.000   0.1428571   0.1428571
    ##   L3Work_prop
    ## 1   0.0000000
    ## 2          NA
    ## 3          NA
    ## 4   0.3333333
    ## 5   0.7142857

``` r
## alternatively, you can deal with home and work at the same time
## by passing home and work as separate vectors within a list
data(entropyExData) # reload example data
entropyExData <- likert2prop(entropyExData, sub, colsList = list(c("L1Home", "L2Home", "L3Home"), c("L1Work", "L2Work", "L3Work")))
print(entropyExData)
```

    ##   sub L1Home L2Home L3Home L1Work L2Work L3Work L1PercentUse L2PercentUse
    ## 1   1      7      7      4      1      7      1           40           50
    ## 2   2      1      7     NA      7      5     NA           60           40
    ## 3   3      7      2     NA      7      2     NA           90           10
    ## 4   4      3      2      6      5      5      5           33           33
    ## 5   5      1      1      7      2      2      6           10           10
    ##   L3PercentUse L1Home_prop L2Home_prop L3Home_prop L1Work_prop L2Work_prop
    ## 1           10   0.4000000   0.4000000       0.200   0.0000000   1.0000000
    ## 2           NA   0.0000000   1.0000000          NA   0.6000000   0.4000000
    ## 3           NA   0.8571429   0.1428571          NA   0.8571429   0.1428571
    ## 4           33   0.2500000   0.1250000       0.625   0.3333333   0.3333333
    ## 5           80   0.0000000   0.0000000       1.000   0.1428571   0.1428571
    ##   L3Work_prop
    ## 1   0.0000000
    ## 2          NA
    ## 3          NA
    ## 4   0.3333333
    ## 5   0.7142857

``` r
# compute language entropy for home sphere

# compute language entropy for work sphere

# compute language entropy for overall percentage usage
```

References
==========

Gullifer, J. W., Chai, X. J., Whitford, V., Pivneva, I., Baum, S., Klein, D., & Titone, D. (2018). Bilingual experience and resting-state brain connectivity: Impacts of L2 age of acquisition and social diversity of language use on control networks. Neuropsychologia, 117, 123–134. <http://doi.org/10.1016/j.neuropsychologia.2018.04.037>
