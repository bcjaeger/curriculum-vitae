##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param infile
##' @param scholar_id
clean_r_packages <- function(infile = "r_packages.csv", scholar_pubs) {

  scholar_rpacks <- scholar_pubs %>%
    select(google_id = ID, cites)
  
  data_rpacks <- read_csv(file.path('data', infile)) %>% 
    filter(on_cran == 'yes') %>% 
    separate_rows(google_id, sep = '; ') %>% 
    left_join(scholar_rpacks, by = 'google_id')
  
  stats_rpacks <- data_rpacks %>% 
    distinct(title) %>% 
    pull(title) %>% 
    cran_stats(use_cache = FALSE)
  
  total_downloads <- table_value(sum(stats_rpacks$downloads))
  
  years_rpacks <- stats_rpacks %>% 
    group_by(package) %>% 
    arrange(start) %>% 
    slice(1, n()) %>% 
    summarize(start = year(min(start)), 
              end = year(max(end)),
              .groups = 'drop') %>% 
    rename(title = package)
  
  total_downloads_by_package <- stats_rpacks %>% 
    group_by(package) %>% 
    summarize(downloads = sum(downloads), .groups = 'drop') %>% 
    transmute(title = as.character(package),
              downloads = format(downloads, big.mark = ','))
  
  data_out <- data_rpacks %>% 
    group_by(title, link, subtitle) %>% 
    summarize(cites = sum(cites), .groups = 'drop') %>% 
    left_join(years_rpacks, by = 'title') %>% 
    left_join(total_downloads_by_package, by = 'title') %>% 
    arrange(desc(start)) %>% 
    transmute(
      section = 'r_packages', 
      title,
      subtitle, 
      location = NA_character_,
      start, 
      end,
      description_1 = glue("[GitHub Repository]({link})"),
      description_2 = glue("Total downloads: {downloads}"),
      description_3 = if_else(
        is.na(cites),
        NA_character_,
        as.character(glue("Total citations: {cites}"))
      )
    )
  
  list(
    inline = list(
      total_downloads = total_downloads
    ), 
    data = data_out)
  
}
