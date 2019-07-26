# Frequently asked questions

## What language history questionnaire do you use in your work?

In Debra Titone's lab, we have been using a hybrid questionnaire that was adapted to the Montreal context from LEAP-Q (by Viorica Marian’s group; https://www.scholars.northwestern.edu/en/publications/the-language-experience-and-proficiency-questionnaire-leap-q-asse) and the LHQ (by Ping Li’s group; updated version here: http://blclab.org/lhq3/). We do not have extensive experience using other questionnaires. 

## What are the differences between language history questionnaires? Which one should I use for my population?

No questionnaire is perfect for all usage cases; each one has pros and cons. If you're trying to choose the best language history questionnaire for your purposes, I would suggest going through all of them in detail to see if certain questions apply to your situation, or creating a hybrid questionnaire (note, this may change the validity of the questionnaire). 

For example, some questionnaires probe information about multiple languages and others only probe information about two languages, which will matter if you’re testing multilinguals vs. bilinguals.
 
## What questionnaire is best for computing language entropy?
 
Ideally, your questionnaire would identify all of the languages that a given participant uses, and then elicit information about how often the individual uses each of those languages in many different communicative contexts. 

If you're sampling from a multilingual population it becomes important to ask about amount of usage for all languages to get an accurate estimate of language entropy. Both, the LEAP-Q and LHQ 2.0 / 3.0 probe multilingual usage.

## How many communicative contexts should I probe?

We're finding that there is variability across communicative contexts, so our general recommendation would be to elicit how often each language is used within a particular context for as many contexts as possible. The downside to including more contexts is that the questionnaire becomes longer. The LHQ 2.0 / 3.0 probes information about at least 16 different communicative contexts.
  
## How do I do manage all of this data from different communicative contexts?

Language entropy reduces the variables by a factor N (where N is the number of languages probed, commonly 2 or 3). However, you may still be left with many variables depending on the number of communicative contexts that you probe.

We recommend that you use a data reduction technique like PCA or composite scores to group like contexts together. 


## What type of question is best used to compute entropy (e.g., proportion/percentage or Likert scale)?
 

To compute an entropy score you ultimately need the proportion of time that each language us used. While questions that elicit percentage use are the easiest to convert to proportions, Likert scores can also be transformed into proportions by dividing a Likert score for a given language by the sum for all languages (within a communicative context; our package includes a helper function, likert2prop to do this). 

You may want to consider Likert scales vs. percentages for the following reasons (some of which are anecdotal given our own experiences with data). First, percentages require the participants to do mental math. Some participants do not read questions correctly, and they will fail to sum to 100% or sum in a way that you did not intend. Thus, percentage data can be quite messy. Second, while percentages feel like they are very continuous allowing for rich diversity in responses, it seems like people tend to prefer certain combinations (50-50, 60-40, 90-10), so this type of measure may not yield the intended variability. Perhaps visual slider bars could help with this. Note: there is work on response patterns to Likert scales, so it may be difficult to escape this particular problem. 

## Isn’t this language entropy stuff all based on self-repot? Is this reliable? 

While the reliability of self-report data has always been questioned, our sense is that people can more accurately assess language usage vs. language abilities. We’re currently working to more thoroughly assess reliability of language entropy as a construct.
 
