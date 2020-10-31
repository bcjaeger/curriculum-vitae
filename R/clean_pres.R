##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param infile
##' @param scholar_pubs
##' @param .author
clean_pres <- function(infile,
                       scholar_pubs,
                       .author) {

  pres <- read_csv(file.path('data', infile)) %>% 
    left_join(select(scholar_pubs, ID, cites)) %>% 
    select(-ID) %>% 
    mutate(
      section = 'presentations',
      in_resume = FALSE,
      # bolden my name
      author = gsub(
        pattern = 'BC Jaeger',
        replacement = '**BC Jaeger**',
        x = .author,
        fixed = TRUE
      ),
      # fix dot dots 
      #  I can't write dot dot dot manually
      #  b/c excel autoformats it
      author = gsub(
        pattern = '..',
        replacement = '...',
        x = .author,
        fixed = TRUE
      ),
      cites = if_else(is.na(cites), 0, cites),
      title = glue("[{title}]({link})"),
      journal = paste0("*",journal,"*"),
      author = glue("{author} <br/> {journal}, {number}"),
      description_1 = glue("Citations: {cites}"),
      date = as.Date(date, format = '%m/%d/%Y'),
      year = lubridate::year(date)
    ) %>% 
    rename(
      subtitle = author,
      end = year
    )
  
  data_out <- pres %>% 
    select(
      section,
      in_resume,
      title,
      subtitle,
      end,
      description_1
    )
  
  list(data = data_out)

}
