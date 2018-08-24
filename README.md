languageEntropy
===============

Use this package to compute language entropy within social spheres from language history data. See Gullifer et al. (2018) for more detail.

Usage
-----

If you have a dataset that contains proportions of language usage within that sum up to 1 (e.g. usage at home, work, overall, etc), use the `languageEntropy()` function. You pass it your whole dataset, a bare (unquoted) column name that contains the unique subject ID, and bare (unquoted) column names that contain language usage (that total to 1). 

There is also a helper function `likert2prop()`, which will take likert question data (passed to the function in a similar manner as above) and convert to proportions, for use in the languageEntropy() function.

Examples
--------

Eventually I will supply various example usages with fake datasets. 

If you have a dataset that contains proportions of language usage within that sum up to 1 (e.g. usage at home, work, overall, etc), use the languageEntropy() function. You pass it your whole dataset, a bare (unquoted) column name that contains the unique subject ID, and bare (unquoted) column names that contain language usage (that total to 1). 

There is also a helper function likert2prop(), which will take likert question data (passed to the function in a similar manner as above) and convert to proportions, for use in the languageEntropy() function.


References
----------
Gullifer, J. W., Chai, X. J., Whitford, V., Pivneva, I., Baum, S., Klein, D., & Titone, D. (2018). Bilingual experience and resting-state brain connectivity: Impacts of L2 age of acquisition and social diversity of language use on control networks. Neuropsychologia, 117, 123–134. http://doi.org/10.1016/j.neuropsychologia.2018.04.037

