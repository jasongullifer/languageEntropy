#' Helper function to convert to proportions
#' @param data A dataset that includes columns of likert data.
#' @param id_quo  Quoted ID variable corresponding to the unique subject ID
#' @param cols_quo Quoted columns of the dataset that contain the likert data.
#' @param minLikert The minimum possible value of your likert index / scale. Typically 1.
#' @export
conv2prop <- function(data, id_quo, cols_quo, minLikert=1){
  df <- data %>% select(!!id_quo, !!!cols_quo)
  df<-df %>% gather(measure, value, !!!cols_quo) %>%
    mutate(value=as.numeric(value)-minLikert) %>%
    group_by(!!id_quo) %>%
    mutate(total=sum(value,na.rm=T), prop=value/total) %>%
    select(-value,-total) %>%
    spread(measure,prop)
  data <- left_join(data,df,by=quo_name(id_quo), suffix=c("","_prop"))
  return(data)
}

#' Function to convert to proportions
#' @param data A dataset that includes columns of likert data.
#' @param id  ID column corresponding to the unique subject ID.
#' @param ...  Columns of the dataset that contain the likert data. If using this argument, proportions will be computed using all columns specified here as the total. If you want to specify several groups of columns, where each group is totaled separately, you may specify them in the colsList agrument below.
#' @param colsList  A list of grouped columns. E.g., list(c("L1Home","L2Home","L3Home"), c("L1Work","L2Work","L3Work")). Totals will be computed separately for each group.
#' @param minLikert The minimum possible value of your likert index / scale. Typically 1.
#' @export
likert2prop <- function(data, id, ..., colsList=NULL, minLikert=1){
  id_quo <- enquo(id)
  if(is.null(colsList)){ # if not using colsList, convert once for all columns specified in ...
    cols_quo <- quos(...)
    data=conv2prop(data, id_quo, cols_quo, minLikert = minLikert)
  }else if (is.list(colsList)){ #if using cols list, convert for each group of columns in the list
    for(item in colsList){
      cur_cols_quo = quos(!!!item)
      data=conv2prop(data, id_quo, cur_cols_quo, minLikert = minLikert)
    }
  }
  return(data)
}
