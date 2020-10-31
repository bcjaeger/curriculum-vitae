##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param infile
##' @param author
clean_grants <- function(infile, .author) {

  bold_author <- glue("**{.author}**") 
  
  data_in <- read_csv(file.path("data", infile)) %>%
    as_tibble(.name_repair = 'universal') %>%
    select(
      title = Project.Title,
      subtitle = PI.Name,
      description_1 = Primary.Sponsor,
      description_2 = Project.Status,
      grant_num = Sponsor.Award.Number,
      date_processed = Processed.Date
    ) %>%
    arrange(desc(date_processed)) 
  
  total_active <- sum(tolower(data_in$description_2) == 'active')
  
  data_out <- data_in %>%
    separate(date_processed, into = c('year', 'month', 'day')) %>% 
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
  
  list(inline = list(total_active = total_active),
       data = data_out)
  

}