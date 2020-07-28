##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param scholar_id
##' @param write_file
get_scholar_pubs <- function(scholar_id, write_file = FALSE) {

  cites_by_pub <- get_publications(scholar_id) %>%
    as_tibble() %>% 
    rename(ID = pubid) %>% 
    mutate(ID = as.character(ID)) 
  
  if(write_file) write_csv(cites_by_pub, 'data/cites_by_pub.csv')
  
  cites_by_pub
  
}
