##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param ... targets to bind
bind_scholar_data <- function(...) {

  # safer to bind if all numerics are coerced to characters.
  supp <- list(...) %>% 
    map(mutate_if, is.numeric, as.character) %>% 
    bind_rows()
  
  main <- read_csv(file.path('data', 'scholar.csv'))
  
  list(main, supp) %>% 
    map(mutate_if, is.numeric, as.character) %>% 
    bind_rows()

}
