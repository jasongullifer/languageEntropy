#' languageEntropy function
#'
#' This function applies the simple entropy function to specified columns within
#' a dataset for each individual subject. The user should supply the column that
#' identifies the unique subject ID (id) as well as the columns of the dataset
#' that contain the data to be converted into entropy (...).
#'
#' Note that entropy will be computed from proportions and these proportions
#' should sum to 1 within a usage sphere. There are various helper functions to
#' help you convert different types of data to propotions (likert2prop() and
#' percent2prop()).
#'
#' @param data A dataset that includes columns which will be converted into
#'   entropy
#' @param id ID variable corresponding to the unique subject ID
#' @param ... Columns of the dataset that will be converted to entropy.
#' @param sphereName A title you give for the resulting entropy column. Leave
#'   this NULL if you use colsList.
#' @param colsList  A list of grouped columns. Entropy will be computed
#'   separately for each group. E.g., list(Home=c("L1Home","L2Home","L3Home"),
#'   Work=c("L1Work","L2Work","L3Work")).
#' @param base Base of the logarithm. Default is Shannon Entropy with base 2.
#'   Other common bases are e (natural) and 10 (hartley).
#' @import dplyr
#' @import tidyr
#' @importFrom magrittr "%>%"
#' @export
#' @examples
#' library(languageEntropy)
#' data(entropyExDataProp) # load example data with proportions
#'
#' # first for the home sphere
#' entropyExDataProp <- languageEntropy(entropyExDataProp, sub, L1Home_prop, L2Home_prop, L3Home_prop, sphereName = "Home")
#' print(entropyExDataProp)
#'
#' # next for the work sphere
#' entropyExDataProp <- languageEntropy(entropyExDataProp, sub, L1Work_prop, L2Work_prop, L3Work_prop, sphereName = "Work")
#' print(entropyExDataProp)
#'
#' # finally for percent/proportion usage sphere
#' entropyExDataProp <- languageEntropy(entropyExDataProp, sub, L1PercentUse_prop, L2PercentUse_prop, L3PercentUse_prop, sphereName = "PercentUse")
#' print(entropyExDataProp)
#'
#' # alternatively, you can deal with home, work and percent at the same time
#' # by passing data for these spheres as separate vectors within a list
#' data(entropyExDataProp) #reload the data
#' entropyExData <- languageEntropy(entropyExData, sub,
#' colsList = list(Home=c("L1Home_prop", "L2Home_prop", "L3Home_prop"),
#'                 Work=c("L1Work_prop","L2Work_prop","L3Work_prop"),
#'                 PercentUse=c("L1PercentUse_prop", "L2PercentUse_prop", "L3PercentUse_prop")))
languageEntropy <- function(data, id, ..., sphereName = NULL, colsList=NULL, base=2){
  id_quo = dplyr::enquo(id)

  if(is.null(sphereName) & is.null(colsList)){
    sphereName = "mySphere"
    warning("You didn't name your usage sphere by supplying a 'sphereName' argument. I'm going to name your sphere 'mySphere.' Note if this happens again, your entropy value will be overwritten, so it is better to give an actual name.")
  }

  if(is.null(colsList)){
    cols_quo <- dplyr::quos(...)
    data <- codeEntropy(data, id_quo, cols_quo, sphereName = sphereName, base = base)
  }else if(is.list(colsList)){
    for(name in names(colsList)){
      cur_cols_quo = dplyr::quos(!!!colsList[name])
      data <- codeEntropy(data, id_quo, cur_cols_quo, sphereName = name, base = base)
    }
  }
  return(data)
}

#' Helper function to convert code language entropy
#' @param data A dataset that includes columns of Likert data.
#' @param id_quo  Quoted ID variable corresponding to the unique subject ID
#' @param cols_quo Quoted columns of the dataset that contain the Likert data.
#' @param sphereName  Title for the resulting entropy column.
#' @param base Base of the logarithm.
#' @import dplyr
#' @import tidyr
#' @importFrom magrittr "%>%"
#' @export
codeEntropy <- function(data, id_quo, cols_quo, sphereName, base){
  check <- data %>% dplyr::group_by(!!id_quo) %>% tidyr::gather(measure, value, !!!cols_quo) %>% dplyr::summarise(sum=sum(value, na.rm=T))
  if (any(!(check$sum == 1))){
    warning("Proportions for one or more subjects do not add up to 1. Resulting entropy values may be problematic. This warning may also occur if you converted percentages to proportions and the sum is very close to 1. Please check:")
    print(check)
  }

  df <- data %>% dplyr::group_by(!!id_quo) %>%  tidyr::gather(measure, value, !!!cols_quo) %>%
    dplyr::summarise(entropy = entropy(value, base = base))
  colnames(df)[colnames(df) == "entropy"] <- paste(sphereName, "entropy", sep = ".")
  data <- dplyr::left_join(data, df, by = dplyr::quo_name(id_quo))
}

#' Simple entropy function
#'
#' Given a vector of discrete probabilities, this function will output an
#' Entropy score (a measure of uncertainty). This function doesn't do any type
#' of error checking (e.g., that proportions add up to 1). However, if all
#' proportions add up to 0, the function will output NA.
#' @param x A vector of discrete probabilities
#' @param base Base of the logarithm. Shannon Entropy uses base 2. Other common bases are e (natural) and 10 (hartley).
#' @keywords shannon entropy
#' @export
#' @examples
#' prob_table <- data.frame(event=c("A","B"), prob=c(.25,.75))
#' entropy(prob_table$prob)
entropy <- function(x, base=2){
  entr <- 0 # total entropy

  if(sum(x,na.rm=T) == 0){ # if the data is all 0s or NAs, then return NA
    return(NA)
  }else{
    for (i in x){
      if(i > 0 & !is.na(i)){
        entr = entr + (i * log(1 / i, base = base)) # compute entropy and add it to the total
      }
    }
  }
  return(entr)
}
