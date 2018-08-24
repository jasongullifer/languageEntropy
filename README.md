Compute language entropy with languageEntropy
================
Jason W. Gullifer and Debra Titone
2018-08-24

Use this package to compute language entropy within social spheres from language history data.

Overview
========

In the language sciences, we frequently collect data about language usage in different contexts such as daily exposure to known languages or daily language use in various communicative contexts. However, few people make use of these measures for a variety of reasons, including that the sheer number of variables related to usage for several languages can be overwhelming.

Language entropy is a measure that characterizes the diversity in language usage (or the degree of balance in language usage). Language entropy ranges from 0 to `log(number_of_languages, base=2)`, where 0 represents compartmentalized usage of one language and `log(number_of_languages, base=2)` (1 for 2 languages, and 1.585 for 3 language) represents perfectly balanced usage of each language. Below, you can see an example of the theoretical distribution of entropy vs. proportion of L2 exposure (for a two-language situation).

<img src="inst/images/entropy.png" alt="theoretical entropy distribution" width="500"/>

When dealing with multiple languages and spheres of language usage, language entropy can reduce the number of data points and generalizes well to multilingual contexts (whereas simple difference scores do not). We have also shown that language entropy relates to various cognitive and neural processes. For more information see, for example, Gullifer et al. (2018).

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

This package works on subject-level data (i.e., one row per subject). The typical use case will be in computing language entropy (or any entropy really) given a set of proportions that sum to 1. For example, you might have a language history dataset where participants reported usage of the native language (L1), second language (L2), and third language (L3), as in the (fake) dataset below.

``` r
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

Here, five subjects reported L1/L2/L3 use in the home and at work (via 1-7 Likert scales, where 1 represents "no usage at all" and 7 represents "usage all the time"). They also reported percent usage of L1/L2/L3 overall.

We can compute language entropy at home, at work, and for overall usage with the `languageEntropy` package. The general steps are as follows:

1.  You must identify spheres of usage in which to compute entropy (e.g., here we choose home, at work, percent usage).
2.  For each sphere of usage, convert your data to proportions of usage. We have convenience functions to convert Likert scales and percentages to proportions. Note: proportions should sum to 1 within each sphere of usage!
3.  For each sphere of usage, compute language entropy using `languageEntropy()`.

Load example dataset
--------------------

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

Step 1: Identify spheres of usage.
----------------------------------

We will compute entropy independently for the home sphere, the work sphere, and percent language usage.

Step 2: Convert Likert data to proportions for each sphere
----------------------------------------------------------

As a concrete example of what we're doing here, a participant (e.g., Subject 1) might report the following usage pattern at home: L1: 7 (all the time), L2: 7 (all the time), L3: 4 (sometimes). First, we rebaseline the Likert scale to 0, so that a score of 0 reflects "no usage", resulting in: L1: 6, L3:6, L3: 3. Next, each rebaselined usage is divided by the sum total (15), resulting in the following proportions of usage L1: 6/15, L2: 6/15, L3: 3/15.

Here's the R code to do this for each subject in the home sphere.

``` r
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

Next, we'll convert the data from the work sphere.

``` r
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

Alternatively, `likert2prop()` can be told to separate the spheres and work on them individually with one command. This can be done by passing home and work usages as separate vectors within a list to the `colsList` argument.

``` r
data(entropyExData) # reload example data
entropyExData <- likert2prop(entropyExData, sub, colsList = list(c("L1Home", "L2Home", "L3Home"),
                                                                 c("L1Work", "L2Work", "L3Work")))
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

Step 3: Compute language entropy for each sphere
------------------------------------------------

``` r
# compute language entropy for home sphere

# compute language entropy for work sphere

# compute language entropy for overall percentage usage
```

References
==========

Gullifer, J. W., Chai, X. J., Whitford, V., Pivneva, I., Baum, S., Klein, D., & Titone, D. (2018). Bilingual experience and resting-state brain connectivity: Impacts of L2 age of acquisition and social diversity of language use on control networks. Neuropsychologia, 117, 123–134. <http://doi.org/10.1016/j.neuropsychologia.2018.04.037>

Acknowledgments
===============

This work was supported by the Natural Sciences and Engineering Research Council of Canada (individual Discovery Grant, 264146 to Titone); the Social Sciences and Humanities Research Council of Canada (Insight Development Grant, 01037 to Gullifer & Titone); the National Institutes of Health (Postdoctoral training grant, F32-HD082983 to Gullifer, Titone, and Klein); the Centre for Research on Brain, Language & Music.

Special thanks to [Ashley M. DaSilva](https://github.com/adasilva), [Mehrgol Tiv](https://github.com/mehrgoltiv), Pauline Palma, [Robert D. Vincent](http://www.bic.mni.mcgill.ca/users/bert/), Junyan Wei, and Naomi Vingron for fruitful discussions regarding (language) entropy.
