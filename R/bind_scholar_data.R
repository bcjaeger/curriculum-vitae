##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param ... targets to bind
bind_scholar_data <- function(...) {

  data_to_bind <- list(...)
  
  supp <- bind_rows(data_to_bind) %>% 
    # safer to bind to main if all numerics are coerced to characters.
    mutate_if(is.numeric, as.character)
  
  main <- read_csv(file.path('data', 'BCJ.csv'))
  
  bind_rows(main, supp)

}
