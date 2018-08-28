#' Function to convert Likert scale data to proportions
#'
#' @param data Your dataset
#' @param id  ID column corresponding to the unique subject ID.
#' @param ...  Columns of the dataset that contain the Likert data to be
#'   converted to proportions. If using this argument, proportions for each column will be
#'   computed by summing together all columns. If you want to specify groups of
#'   columns to be converted independently, you may specify them in the colsList
#'   argument instead
#' @param colsList  A list of grouped columns. E.g.,
#'   list(c("L1Home","L2Home","L3Home"), c("L1Work","L2Work","L3Work")). Totals
#'   will be computed separately for each group.
#' @param minLikert The minimum possible value of your Likert index / scale.
#'   Typically 1. This is used in rebaselining Likert values to 0.
#' @import dplyr
#' @importFrom magrittr "%>%"
#' @export
#' @examples
#' library(languageEntropy)
#' data(entropyExData) # load example data
#'
#' # convert Likert scale data to proportions
#'
#' ## first for the home context
#' entropyExData <- likert2prop(entropyExData, sub, L1Home, L2Home, L3Home)
#' print(entropyExData)
#'
#' # next for the work context
#' entropyExData <- likert2prop(entropyExData, sub, L1Work, L2Work, L3Work)
#' print(entropyExData)
#'
#' entropyExData <- likert2prop(entropyExData, sub, L1PercentUse, L2PercentUse, L3PercentUse)
#' print(entropyExData)
#'
#' # alternatively, you can convert home and work at the same time
#' # by passing home and work as separate vectors within a list
#' data(entropyExData) # reload example data
#' entropyExData <- likert2prop(entropyExData, sub, colsList = list(c("L1Home", "L2Home", "L3Home"), c("L1Work", "L2Work", "L3Work")))
#' print(entropyExData)
likert2prop <- function(data, id, ..., colsList=NULL, minLikert=1){
  id_quo <- dplyr::enquo(id)
  cd <- checkDuplicateID(data, id_quo)
  if(!is.null(cd)){
    stop(paste0("You have duplicate identifiers in your data: ", cd))
    }

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

#' Helper function to convert to Likert to proportions. This function does all the work.
#'
#' @param data The dataset
#' @param id_quo  Quoted ID variable corresponding to the unique subject ID
#' @param cols_quo Quoted columns of the dataset that contain the Likert data.
#' @param minLikert The minimum possible value of the Likert index / scale. Typically 1. This is used in rebaselining Likert values to 0.
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
