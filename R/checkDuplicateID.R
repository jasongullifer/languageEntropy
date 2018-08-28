#' Function to check duplicate ID variables
#'
#' @param data S dataset
#' @param id  ID column corresponding to the unique subject ID.
#' @import dplyr
#' @export
checkDuplicateID <- function(data, id){
  ids <- unlist(data %>% dplyr::pull(!!id))
  if(any(duplicated(ids))){
    return(ids[duplicated(ids)])
  }else{
    return(NULL)
  }
}
