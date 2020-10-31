##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##'
##' @param infile
##' @param scholar_pubs 
##' @param author 
clean_pubs <- function(infile, scholar_pubs, .author) {

  data_pubs <- read_csv(file.path(here(), 'data', infile))
  
  just_the_citations <- scholar_pubs %>% 
    select(ID, cites)
  
  total_citations <- sum(just_the_citations$cites)
  
  data_out <- left_join(data_pubs, just_the_citations, by = "ID") %>% 
    select(-ID) %>% 
    # set up for use in .Rmd doc
    mutate(
      # fill missing
      cites = if_else(is.na(cites), 0, cites),
      # format author values so its easier to see your name
      author = clean_author(x = author, .author = .author, bold = TRUE),
      # journal names should be italic
      journal = paste0("*",journal,"*")
    ) %>% 
    arrange(desc(as.Date(date, format = '%m/%d/%Y'))) %>% 
    transmute(
      # label section
      section = 'publications',
      # give links if you've got em.
      title = if_else(
        condition = is.na(link), 
        true = title,
        false = as.character(glue("[{title}]({link})"))
      ),
      # combine author <new line> journal, number for the .Rmd doc
      subtitle = glue("{author} <br/> {journal}, {number}"),
      # show citations for each paper
      description_1 = glue("Citations: {cites}"),
      description_2 = if_else(
        is.na(doi),
        NA_character_,
        as.character(glue("DOI: {doi}"))
      ),
      # Just show the year that paper was published
      end = year(as.Date(date, format = '%m/%d/%Y')),
      aside
    )
  
  total_first_author = sum(str_detect(data_out$subtitle, "^\\*\\*BC Jaeger"))
  
  list(
    inline = list(
      total_citations = total_citations,
      total_first_author = total_first_author
    ), 
    data = data_out)
  
}
