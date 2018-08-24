#' Function to convert to percentages to proportions
#' @param data A dataset that includes columns of percentage data.
#' @param id  ID column corresponding to the unique subject ID.
#' @param ...  Columns of the dataset that contain the percentage data.
#' @import dplyr
#' @importFrom magrittr "%>%"
#' @export
#' @examples
#' library(languageEntropy)
#' data(entropyExData) # load example data
#'
#' # convert percentage data to proportions
#'
#' entropyExData <- percent2prop(entropyExData, L1PercentUse, L2PercentUse, L3PercentUse)
#' print(entropyExData)
percent2prop <- function(data, ...){
  cols_quo   = dplyr::quos(...)
  data <- data %>% dplyr::mutate_at(.vars=vars(!!!cols_quo), .funs=dplyr::funs(prop=./100))
  return(data)
}
