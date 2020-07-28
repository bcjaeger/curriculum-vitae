##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param x
##' @param .author
##' @param bold
clean_author <- function(x, .author, bold) {
    
    bold_author <- if(bold) glue("**{.author}**") else(.author)
    
    x %>% 
      # replace author with a bolded version
      str_replace(pattern = fixed(.author), replacement = bold_author) %>% 
      # replace .. with ... (why? writing ... in .csv files breaks my R)
      str_replace(pattern = fixed('..'), replacement = '...')
    
}
