##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param scholar_id
citations_scrape <- function(scholar_id) {

  cites_by_pub <- get_publications(scholar_id) %>%
    as_tibble() %>% 
    rename(ID = pubid) %>% 
    mutate(ID = as.character(ID)) 
  
}
