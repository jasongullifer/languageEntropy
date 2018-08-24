#' Function to convert Likert to proportions
#' @param data A dataset that includes columns of likert data.
#' @param id  ID column corresponding to the unique subject ID.
#' @param ...  Columns of the dataset that contain the likert data. If using this argument, proportions will be computed using all columns specified here as the total. If you want to specify several groups of columns, where each group is totaled separately, you may specify them in the colsList agrument below.
#' @param colsList  A list of grouped columns. E.g., list(c("L1Home","L2Home","L3Home"), c("L1Work","L2Work","L3Work")). Totals will be computed separately for each group.
#' @param minLikert The minimum possible value of your likert index / scale. Typically 1.
#' @import dplyr
#' @importFrom magrittr "%>%"
#' @export
#' @examples
#' library(languageEntropy)
#' data(entropyExData) # load example data
#'
#' # convert Likert scale data to proportions
#'
#' ## first for the home sphere
#' entropyExData <- likert2prop(entropyExData, sub, L1Home, L2Home, L3Home)
#' print(entropyExData)
#'
#' # next for the work sphere
#' entropyExData <- likert2prop(entropyExData, sub, L1Work, L2Work, L3Work)
#' print(entropyExData)
#'
#' entropyExData <- likert2prop(entropyExData, sub, L1PercentUse, L2PercentUse, L3PercentUse)
#' print(entropyExData)
#'
#' # alternatively, you can deal with home and work at the same time
#' # by passing home and work as separate vectors within a list
#' data(entropyExData) # reload example data
#' entropyExData <- likert2prop(entropyExData, sub, colsList = list(c("L1Home", "L2Home", "L3Home"), c("L1Work", "L2Work", "L3Work")))
#' print(entropyExData)
likert2prop <- function(data, id, ..., colsList=NULL, minLikert=1){
  id_quo <- dplyr::enquo(id)
  if(is.null(colsList)){ # if not using colsList, convert once for all columns specified in ...
    cols_quo <- dplyr::quos(...)
    data <- conv2prop(data, id_quo, cols_quo, minLikert = minLikert)
  }else if (is.list(colsList)){ #if using cols list, convert for each group of columns in the list
    for(item in colsList){
      cur_cols_quo = dplyr::quos(!!!item)
      data <- conv2prop(data, id_quo, cur_cols_quo, minLikert = minLikert)
    }
  }
  return(data)
}

#' Helper function to convert to Likert to proportions
#' @param data A dataset that includes columns of likert data.
#' @param id_quo  Quoted ID variable corresponding to the unique subject ID
#' @param cols_quo Quoted columns of the dataset that contain the likert data.
#' @param minLikert The minimum possible value of your likert index / scale. Typically 1.
#' @import dplyr
#' @import tidyr
#' @importFrom magrittr "%>%"
#' @export
conv2prop <- function(data, id_quo, cols_quo, minLikert=1){
  df <- data %>% dplyr::select(!!id_quo, !!!cols_quo)
  df <- df %>% tidyr::gather(measure, value, !!!cols_quo) %>%
    dplyr::mutate(value=as.numeric(value)-minLikert) %>%
    dplyr::group_by(!!id_quo) %>%
    dplyr::mutate(total=sum(value,na.rm=T), prop=value/total) %>%
    dplyr::select(-value,-total) %>%
    tidyr::spread(measure,prop)
  data <- dplyr::left_join(data,df,by=dplyr::quo_name(id_quo), suffix=c("","_prop"))
  return(data)
}
