Compute language entropy with languageEntropy
================
Jason W. Gullifer and Debra Titone
2018-08-24

[![DOI](https://zenodo.org/badge/142208995.svg)](https://zenodo.org/badge/latestdoi/142208995)

Use this package to compute language entropy from language history data. This package and the functions within were developed by Jason Gullifer with conceptual input from Debra Titone.

If you use this package in your research, please consider citing us:

    ## Warning: 'DESCRIPTION' file has an 'Encoding' field and re-encoding is not
    ## possible

    ## 
    ## To cite languageEntropy in publications use:
    ## 
    ##   Gullifer, J. W., & Titone, D. (2018). Compute language entropy
    ##   with {languageEntropy}. Retrieved from
    ##   https://github.com/jasongullifer/languageEntropy.
    ##   doi:10.5281/zenodo.1403272
    ## 
    ##   Gullifer, J. W., & Titone, D. (under review). Characterizing the
    ##   social diversity of bilingualism using language entropy.
    ## 
    ##   Gullifer, J. W., Chai, X. J., Whitford, V., Pivneva, I., Baum,
    ##   S., Klein, D., & Titone, D. (2018). Bilingual experience and
    ##   resting-state brain connectivity: Impacts of L2 age of
    ##   acquisition and social diversity of language use on control
    ##   networks. Neuropsychologia, 117, 123–134.
    ##   http://doi.org/10.1016/j.neuropsychologia.2018.04.037

Overview
========

In the language sciences, we frequently collect data about language usage in various contexts, such as overall daily exposure to known languages or extent of language use in communicative contexts (e.g., at home, at work, in social settings). However, there is not wide usage of these various measures as covariates or predictors of behavior, despite their practical and theoretical significance. One reason for underuse is that the number of variables related to usage in a multilingual context can be overwhelming. Another reason for underuse is that the distribution of these data may not be ideal for analysis, particularly if they were collected via discrete responses (such as Likert scales). Language entropy helps to solve some of these issues.

Language entropy is a measure that characterizes the diversity of language usage (or the degree of balance in language usage). Language entropy ranges from 0 to `log(number_of_languages, base=2)`, where 0 represents compartmentalized usage of a single language and `log(number_of_languages, base=2)` represents perfectly balanced usage of each reported language. Below, you can see an example of the theoretical distribution of entropy vs. proportion of L2 exposure (for a situation in which two languages are used).

<img src="inst/images/entropy.png" alt="theoretical entropy distribution" width="500"/>

Language entropy can be computed from the data elicited by language history questionnaires that have become ubiquitous in the field. In recent papers, we have argued that language entropy is an ideal way to measure theoretically relevant variables such as the *social diversity of language usage* or *inteactional context of langauge usage* (see e.g. the *Adaptive Control Hypothesis* by Green & Abutalebi, 2013) in a continuous manner. We have also shown that language entropy relates to various cognitive and neural processes (see Gullifer et al., 2018; Gullifer & Titone, under review). Language entropy generalizes well to multilingual contexts (while reducing the number of variables), and it is distributed continuously.

Installation
============

`languageEntropy` can be installed through `devtools` using the code below.

``` r
# Install devtools package if necessary
if(!"devtools" %in% rownames(installed.packages())) install.packages("devtools")

# Install the development version from github
devtools::install_github("jasongullifer/languageEntropy")
```

Usage
=====

This package works on subject-level data (i.e., one row per subject, one column per measure). The typical use case will be in computing language entropy (or any entropy really) given a set (or sets) of proportions that sum to 1. For example, in the fake dataset below, we have some language history data for five participants. Specifically, participants reported usage of the native language (L1), second language (L2), and third language (L3) at home, at work, and overall.

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

Here, home and work use were elicited via 7-point Likert scales (where 1 represents "no usage at all" and 7 represents "usage all the time"). Overall usage was elicited via data entry in the form of percentages.

We can compute language entropy at home, at work, and for overall usage with the `languageEntropy` package. The general steps are as follows:

1.  You must identify contexts of language usage in which to compute entropy (e.g., here we choose home, at work, percent usage).
2.  For each context of usage, convert your data to proportions of language usage. We supply two convenience functions (`likert2prop()` and `percent2prop()`) to convert Likert scales and percentages to proportions. Note: proportions should sum to 1 within each context of usage.
3.  For each context of usage, compute language entropy using `languageEntropy()`.

Note: The functions `likert2prop()` and `languageEntropy()` include an input argument, `colsList` which allows the user to specify independent contexts of usage as separate items in a list. Entropy / proportions will be calculated independently for each context without necessitating the user to run the function several times. In the case of `percent2prop()`, percentages are computed by dividing each observation by 100, and therefore, the function needs no knowledge of the context of usage.

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

Step 1: Identify contexts of usage.
-----------------------------------

We will compute entropy independently for the home context, the work context, and percent language usage.

Step 2: Convert data to proportions for each context
----------------------------------------------------

In the example dataset, some data are represented by Likert scales and some are represented by percentages. Both types of data need to be converted to proportions.

For Likert data, the following is a concrete example of the conversion process. A participant (e.g., Subject 1) might report the following usage pattern at home: L1: 7 (all the time), L2: 7 (all the time), L3: 4 (sometimes). First, we rebaseline the Likert scale to 0, so that a score of 0 reflects "no usage", resulting in: L1: 6, L3:6, L3: 3. Next, each rebaselined usage is divided by the sum total (15), resulting in the following proportions of language usage at home, L1: 6/15, L2: 6/15, L3: 3/15.

The following R code does this for each subject in the home context. You must specify the dataset (here, `entropyExData`), the subject ID column (here, `sub`), and the columns that contain the context-specific Likert data (here, `L1home`, `L2Home`, and `L3home`) You can see the output contains three new variables (with `_prop` appended to the column names).

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

Next, we will convert the data from the work context.

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

Alternatively, `likert2prop()` can be told to separate the contexts and work on them individually within one command. This can be done by passing home and work usages as separate vectors within a list to the `colsList` argument.

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

Now we will convert the percentages to proportions with the helper function `percent2prop()`.

``` r
entropyExData <- percent2prop(entropyExData, L1PercentUse, L2PercentUse, L3PercentUse)

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
    ##   L3Work_prop L1PercentUse_prop L2PercentUse_prop L3PercentUse_prop
    ## 1   0.0000000              0.40              0.50              0.10
    ## 2          NA              0.60              0.40                NA
    ## 3          NA              0.90              0.10                NA
    ## 4   0.3333333              0.33              0.33              0.33
    ## 5   0.7142857              0.10              0.10              0.80

Step 3: Compute language entropy for each context
-------------------------------------------------

Now that we have percentages, we can compute language entropy for each context of usage with `languageEntropy()`. This function works similarly to `likert2prop()`.

Compute entropy for the home context. We again specify the dataset (`entropyExData`), the subject ID column (`sub`), and the columns that contain context-specific proportions (`L1Home_prop`, `L2Home_prop`, and `L3Home_prop`). You should also supply the `contextName` arguments, which allows `languageEntropy()` to give your new entropy column a name.

``` r
entropyExData <- languageEntropy(entropyExData, sub, L1Home_prop, L2Home_prop, L3Home_prop, 
                                 contextName = "Home")
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
    ##   L3Work_prop L1PercentUse_prop L2PercentUse_prop L3PercentUse_prop
    ## 1   0.0000000              0.40              0.50              0.10
    ## 2          NA              0.60              0.40                NA
    ## 3          NA              0.90              0.10                NA
    ## 4   0.3333333              0.33              0.33              0.33
    ## 5   0.7142857              0.10              0.10              0.80
    ##   Home.entropy
    ## 1    1.5219281
    ## 2    0.0000000
    ## 3    0.5916728
    ## 4    1.2987949
    ## 5    0.0000000

Now we do the same for the work context.

``` r
entropyExData <- languageEntropy(entropyExData, sub, L1Work_prop, L2Work_prop, L3Work_prop, 
                                 contextName = "Work")
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
    ##   L3Work_prop L1PercentUse_prop L2PercentUse_prop L3PercentUse_prop
    ## 1   0.0000000              0.40              0.50              0.10
    ## 2          NA              0.60              0.40                NA
    ## 3          NA              0.90              0.10                NA
    ## 4   0.3333333              0.33              0.33              0.33
    ## 5   0.7142857              0.10              0.10              0.80
    ##   Home.entropy Work.entropy
    ## 1    1.5219281    0.0000000
    ## 2    0.0000000    0.9709506
    ## 3    0.5916728    0.5916728
    ## 4    1.2987949    1.5849625
    ## 5    0.0000000    1.1488349

No we do the same for overall use.

``` r
entropyExData <- languageEntropy(entropyExData, sub, L1PercentUse_prop, L2PercentUse_prop, L3PercentUse_prop, 
                                 contextName = "PercentUse")
```

    ## Warning in codeEntropy(data, id_quo, cols_quo, contextName = contextName, :
    ## Proportions for one or more subjects do not add up to 1. Resulting entropy
    ## values may be problematic. This warning may also occur if you converted
    ## percentages to proportions and the sum is very close to 1. Please check:

    ## # A tibble: 5 x 2
    ##     sub   sum
    ##   <int> <dbl>
    ## 1     1  1   
    ## 2     2  1   
    ## 3     3  1   
    ## 4     4  0.99
    ## 5     5  1

``` r
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
    ##   L3Work_prop L1PercentUse_prop L2PercentUse_prop L3PercentUse_prop
    ## 1   0.0000000              0.40              0.50              0.10
    ## 2          NA              0.60              0.40                NA
    ## 3          NA              0.90              0.10                NA
    ## 4   0.3333333              0.33              0.33              0.33
    ## 5   0.7142857              0.10              0.10              0.80
    ##   Home.entropy Work.entropy PercentUse.entropy
    ## 1    1.5219281    0.0000000          1.3609640
    ## 2    0.0000000    0.9709506          0.9709506
    ## 3    0.5916728    0.5916728          0.4689956
    ## 4    1.2987949    1.5849625          1.5834674
    ## 5    0.0000000    1.1488349          0.9219281

Alternatively, `languageEntropy()` can be told to separate the contexts and work on them individually within one command. This can be done by passing all the contexts as separate vectors within a list to the `colsList` argument.

``` r
entropyExData <- languageEntropy(entropyExData, sub, 
                                 colsList = list(Home=c("L1Home_prop", "L2Home_prop", "L3Home_prop"),
                                                 Work=c("L1Work_prop","L2Work_prop","L3Work_prop"),
                                                 PercentUse=c("L1PercentUse_prop", "L2PercentUse_prop",
                                                              "L3PercentUse_prop")))
```

    ## Warning in codeEntropy(data, id_quo, cur_cols_quo, contextName = name, base
    ## = base): Proportions for one or more subjects do not add up to 1. Resulting
    ## entropy values may be problematic. This warning may also occur if you
    ## converted percentages to proportions and the sum is very close to 1. Please
    ## check:

    ## # A tibble: 5 x 2
    ##     sub   sum
    ##   <int> <dbl>
    ## 1     1  1   
    ## 2     2  1   
    ## 3     3  1   
    ## 4     4  0.99
    ## 5     5  1

``` r
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
    ##   L3Work_prop L1PercentUse_prop L2PercentUse_prop L3PercentUse_prop
    ## 1   0.0000000              0.40              0.50              0.10
    ## 2          NA              0.60              0.40                NA
    ## 3          NA              0.90              0.10                NA
    ## 4   0.3333333              0.33              0.33              0.33
    ## 5   0.7142857              0.10              0.10              0.80
    ##   Home.entropy.x Work.entropy.x PercentUse.entropy.x Home.entropy.y
    ## 1      1.5219281      0.0000000            1.3609640      1.5219281
    ## 2      0.0000000      0.9709506            0.9709506      0.0000000
    ## 3      0.5916728      0.5916728            0.4689956      0.5916728
    ## 4      1.2987949      1.5849625            1.5834674      1.2987949
    ## 5      0.0000000      1.1488349            0.9219281      0.0000000
    ##   Work.entropy.y PercentUse.entropy.y
    ## 1      0.0000000            1.3609640
    ## 2      0.9709506            0.9709506
    ## 3      0.5916728            0.4689956
    ## 4      1.5849625            1.5834674
    ## 5      1.1488349            0.9219281

References
==========

Gullifer, J. W., Chai, X. J., Whitford, V., Pivneva, I., Baum, S., Klein, D., & Titone, D. (2018). Bilingual experience and resting-state brain connectivity: Impacts of L2 age of acquisition and social diversity of language use on control networks. *Neuropsychologia*, *117*, 123–134. <http://doi.org/10.1016/j.neuropsychologia.2018.04.037>

Green, D. W., & Abutalebi, J. (2013). Language control in bilinguals: The adaptive control hypothesis. *Journal of Cognitive Psychology*, *25*, 515–530. <http://doi.org/10.1080/20445911.2013.796377>

Gullifer, J. W., & Titone, D. (under review). Characterizing the social diversity of bilingualism using language entropy.

Acknowledgments
===============

This work was supported by the Natural Sciences and Engineering Research Council of Canada (individual Discovery Grant, 264146 to Titone); the Social Sciences and Humanities Research Council of Canada (Insight Development Grant, 01037 to Gullifer & Titone); the National Institutes of Health (Postdoctoral training grant, F32-HD082983 to Gullifer, Titone, and Klein); the Centre for Research on Brain, Language & Music.

Special thanks to [Ashley M. DaSilva](https://github.com/adasilva), [Denise Klein](https://www.mcgill.ca/denise-klein-lab/lab), Pauline Palma, [Mehrgol Tiv](https://github.com/mehrgoltiv), [Janet Van Hell](http://bild.la.psu.edu/people/principal-investigator), [Robert D. Vincent](http://www.bic.mni.mcgill.ca/users/bert/), Naomi Vingron, and Junyan Wei for fruitful discussions regarding (language) entropy and the social diversity of language usage.
