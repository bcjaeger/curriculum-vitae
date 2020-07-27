##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##'
##' @param infile
##' @param scholar_citations 
##' @param author 
clean_pubs <- function(infile, scholar_citations, .author) {

  data_pubs <- read_csv(file.path(here(),'data', infile))
  
  just_the_citations <- scholar_citations %>% 
    select(ID, cites)
  
  bold_author <- glue("**{.author}**") 
  
  left_join(data_pubs, just_the_citations, by = "ID") %>% 
    select(-ID) %>% 
    # set up for use in .Rmd doc
    mutate(
      cites = if_else(is.na(cites), 0, cites),
      section = 'publications',
      # bolden author name
      author = str_replace(
        string = author,
        pattern = fixed(.author),
        replacement = bold_author
      ),
      # replace .. with ... (why? writing ... in .csv files breaks my R)
      author = gsub(
        pattern = '..',
        replacement = '...',
        x = author,
        fixed = TRUE
      ),
      # give links if you got em.
      title = if_else(
        condition = is.na(link), 
        true = title,
        false = as.character(glue("[{title}]({link})"))
      ),
      # italic journal names
      journal = paste0("*",journal,"*"),
      # format author / journal / number for the .Rmd doc
      author = glue("{author} <br/> {journal}, {number}"),
      # show citations for each paper
      description_1 = glue("Citations: {cites}"),
      # no need to get super specific with dates, just show the year
      date = as.Date(date, format = '%m/%d/%Y'),
      year = lubridate::year(date)
    ) %>% 
    rename(
      subtitle = author,
      description_2 = doi,
      end = year
    )

}
