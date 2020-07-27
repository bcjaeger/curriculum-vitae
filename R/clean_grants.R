##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param infile
##' @param author
clean_grants <- function(infile, .author) {

  bold_author <- glue("**{.author}**") 
  
  read_csv(file.path("data", infile)) %>%
    arrange(desc(date_processed)) %>%
    separate(date_processed, into = c('month', 'day', 'year')) %>% 
    mutate(
      section = 'grants',
      subtitle = str_replace(
        string = subtitle,
        pattern = fixed(.author),
        replacement = bold_author
      ),
      subtitle = glue("*Primary Investigator:* {subtitle}"),
      description_1 = glue("*Submitted to* {description_1}"),
      description_2 = if_else(
        condition = !is.na(grant_num),
        true = glue("{description_2}, {grant_num}"),
        false = description_2
      )
    ) %>%
    select(
      section,
      title, 
      subtitle,
      starts_with("descr"),
      end = year
    )
  

}
