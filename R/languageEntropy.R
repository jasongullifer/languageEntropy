#' languageEntropy function
#'
#' This function applies the simple entropy function to specified columns within
#' a dataset for each individual subject. The user should supply the column that
#' identifies the unique subject ID (id) as well as the columns of the dataset
#' that contain the data to be converted into entropy (cols). The user must
#' specify the type of data contained in the specified columns (i.e., whether
#' the data are likert data, percentage data, or proportion data). Likert and
#' percentage data are converted to proportions. Note that the probabilities
#' should sum to 1.
#' @param data A dataset that includes columns which will be converted into entropy
#' @param id ID variable corresponding to the unique subject ID
#' @param ... Columns of the dataset that will be converted to entropy.
#' @import dplyr
#' @import tidyr
#' @importFrom magrittr "%>%"
#' @export
languageEntropy <- function(data, id, ..., colsList=NULL){
  id_quo = dplyr::enquo(id)
  cols_quo   = dplyr::quos(...)
  check <- data %>% dplyr::group_by(!!id_quo) %>% tidyr::gather(measure, value, !!!cols_quo) %>% dplyr::summarise(sum=sum(value,na.rm=T))
  if (any(!(check$sum == 1))){
    warning("Proportions for one or more subjects do not add up to 1. Resulting entropy values may be problematic. Please check:")
    print(check)
  }

  df <- data %>% dplyr::group_by(!!id_quo) %>%  tidyr::gather(measure,value,!!!cols_quo) %>%
    dplyr::summarise(entropy=entropy(value), missing=sum(value,na.rm=T) == 0)
  #colnames(df)[colnames(df)=="entropy"]<-entropyName
  #colnames(df)[colnames(df)=="missing"]<-paste0("missing",entropyName)
  data <- dplyr::left_join(data,df,by=dplyr::quo_name(id_quo))
  return(data)
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
