Compute language entropy with languageEntropy
===============

Use this package to compute language entropy within social spheres from language history data. See Gullifer et al. (2018) for more detail.

Installation
------------

`languageEntropy` can be installed through `devtools` using the code below.

```r
# Install devtools package if necessary
if(!"devtools" %in% rownames(installed.packages())) install.packages("devtools")

# Install the stable development verions from GitHub
devtools::install_github("jasongullifer/languageEntropy")
```

Usage
-----

If you have a subject-level dataset (i.e., one row per subject) that contains proportions of language usage that sum up to 1 (e.g., usage of the native language [L1], second language [L2], and third language [L3]), you can compute language entropy using the `languageEntropy()` function. 

You simply pass the function your dataset (`data` argument) together with several bare, unquoted identifier columns, including the unique subject identifier (`id` argument) and other variables that index proportion of language usage (`...` argument). There is also a flag (`percentage`) that you can set to `TRUE` in case your language usages are coded as percentages.

Various language history questionnaires collect usage data via Likert scales (e.g., "L1 / L2 / L3 use at home: 1 (none at all) - 7 (all the time)"). The helper function `likert2prop()`, will convert this likert data into proportions. Simply supply your dataset and variables as above, store the result, and use that result in the `languageEntropy()` function. Note: by default `likert2prop()` assumes your baseline for "no usage" is scored as 1. You may have to manually rescale your questions so everything is on the same scale. 

As a concrete example, a participant might report the following usage pattern: L1: 7 (all the time), L2: 1 (none at all), L3: 3 (sometimes). First the baseline is subtracted from each usage question, and then each rebaselined usage is divided by the total, resulting in L1: 6/8, L2: 0/8, L3: 2/8.  



Examples
--------
Example (fake) dataset has 5 subjects. Subjects reported L1/L2/L3 use at home and at work. Home and work data are represented as Likert scales (1: uses Lx none at all; 7: uses Lx all the time). Subjects also reportedpercentage of L1/L2/L3 use overall. 

```r
library(languageEntropy)
data(entropyExData) # load example data


```


References
----------
Gullifer, J. W., Chai, X. J., Whitford, V., Pivneva, I., Baum, S., Klein, D., & Titone, D. (2018). Bilingual experience and resting-state brain connectivity: Impacts of L2 age of acquisition and social diversity of language use on control networks. Neuropsychologia, 117, 123–134. http://doi.org/10.1016/j.neuropsychologia.2018.04.037

